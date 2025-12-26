import type { APIRoute } from 'astro';
import { getDB } from '../../../../lib/db';

// 発売処理（subcategories + treatments + treatment_plans にマージ）
export const POST: APIRoute = async ({ params, request, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    // 発売予定商品を取得
    const launch = await db.prepare(`
      SELECT * FROM product_launches WHERE id = ?
    `).bind(id).first() as any;

    if (!launch) {
      return new Response(JSON.stringify({ error: '発売予定商品が見つかりません' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    if (launch.status === 'launched') {
      return new Response(JSON.stringify({ error: 'すでに発売済みです' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    const {
      category_id,
      subcategory_name,
      subcategory_slug,
      treatment_name,
      plans = [],
      web_register = false,
      smaregi_product_code,
      medical_force_product_id
    } = body;

    if (!category_id || !subcategory_name || !subcategory_slug) {
      return new Response(JSON.stringify({ 
        error: 'カテゴリ、サブカテゴリ名、スラッグは必須です' 
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    // launch_plans からプランを取得（渡されなかった場合）
    let plansToCreate = plans;
    if (plansToCreate.length === 0) {
      const { results: launchPlans } = await db.prepare(`
        SELECT * FROM launch_plans WHERE launch_id = ? ORDER BY sort_order, id
      `).bind(id).all();
      plansToCreate = launchPlans || [];
    }

    if (plansToCreate.length === 0) {
      return new Response(JSON.stringify({ error: '料金プランが1つ以上必要です' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    // 1. subcategories に新規作成
    const maxSortOrder = await db.prepare(`
      SELECT COALESCE(MAX(sort_order), 0) + 1 as next_order 
      FROM subcategories WHERE category_id = ?
    `).bind(category_id).first() as any;

    const subcategoryResult = await db.prepare(`
      INSERT INTO subcategories (category_id, name, slug, sort_order, is_active)
      VALUES (?, ?, ?, ?, 1)
    `).bind(
      category_id,
      subcategory_name,
      subcategory_slug,
      maxSortOrder?.next_order || 1
    ).run();

    const subcategoryId = subcategoryResult.meta.last_row_id;

    // 2. treatments に施術を作成
    const finalTreatmentName = treatment_name || subcategory_name;
    const treatmentResult = await db.prepare(`
      INSERT INTO treatments (subcategory_id, name, slug, sort_order, is_active)
      VALUES (?, ?, ?, 1, 1)
    `).bind(
      subcategoryId,
      finalTreatmentName,
      subcategory_slug
    ).run();

    const treatmentId = treatmentResult.meta.last_row_id;

    // 3. treatment_plans に全料金プランをコピー
    let copiedPlansCount = 0;
    for (const plan of plansToCreate) {
    await db.prepare(`
      INSERT INTO treatment_plans (
          treatment_id, plan_name, plan_type, sessions, quantity,
          price, price_taxed, price_per_session, price_per_session_taxed,
          supply_cost, staff_cost, total_cost, cost_rate,
          staff_discount_rate, staff_price,
          sort_order, is_active, is_public, is_recommended, notes
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, ?, ?)
    `).bind(
      treatmentId,
        plan.plan_name,
        plan.plan_type || 'single',
        plan.sessions || 1,
        plan.quantity || null,
        plan.price,
        plan.price_taxed,
        plan.price_per_session || null,
        plan.price_per_session_taxed || null,
        plan.supply_cost || 0,
        plan.labor_cost || plan.staff_cost || 0,
        plan.total_cost || 0,
        plan.cost_rate || null,
        plan.staff_discount_rate || null,
        plan.staff_price || null,
        plan.sort_order || copiedPlansCount,
        plan.is_recommended || 0,
        plan.notes || null
    ).run();
      copiedPlansCount++;
    }

    // 4. product_launches を更新
    const now = new Date().toISOString();
    await db.prepare(`
      UPDATE product_launches SET
        status = 'launched',
        subcategory_id = ?,
        slug = ?,
        launched_at = ?,
        web_registered_at = ?,
        smaregi_product_code = ?,
        smaregi_registered_at = ?,
        medical_force_product_id = ?,
        medical_force_registered_at = ?,
        updated_at = datetime('now')
      WHERE id = ?
    `).bind(
      subcategoryId,
      subcategory_slug,
      now,
      web_register ? now : null,
      smaregi_product_code || null,
      smaregi_product_code ? now : null,
      medical_force_product_id || null,
      medical_force_product_id ? now : null,
      id
    ).run();

    return new Response(JSON.stringify({ 
      success: true,
      subcategory_id: subcategoryId,
      treatment_id: treatmentId,
      plans_copied: copiedPlansCount,
      message: `「${launch.name}」を発売しました（${copiedPlansCount}件のプランをコピー）`
    }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error launching product:', error);
    return new Response(JSON.stringify({ 
      error: '発売処理に失敗しました',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

