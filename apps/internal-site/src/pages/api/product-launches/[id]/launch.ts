import type { APIRoute } from 'astro';
import { getDB } from '../../../../lib/db';
import {
  jsonResponse,
  requireParam,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
  type ValidationFieldError,
} from '../../../../lib/api';

// 発売処理（subcategories + treatments + treatment_plans にマージ）
export const POST: APIRoute = async ({ params, request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    const idResponse = requireParam(id, '発売予定商品ID');
    if (idResponse) return idResponse;

    // 発売予定商品を取得
    const launch = await db.prepare(`
      SELECT * FROM product_launches WHERE id = ?
    `).bind(id).first() as any;

    if (!launch) {
      return jsonResponse(404, { error: '発売予定商品が見つかりません' });
    }

    if (launch.status === 'launched') {
      return validationError('すでに発売済みです', [
        { field: 'status', message: 'すでに発売済みです' },
      ]);
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
      const fields: ValidationFieldError[] = [];
      if (!category_id) {
        fields.push({ field: 'category_id', message: 'カテゴリは必須です' });
      }
      if (!subcategory_name) {
        fields.push({ field: 'subcategory_name', message: 'サブカテゴリ名は必須です' });
      }
      if (!subcategory_slug) {
        fields.push({ field: 'subcategory_slug', message: 'スラッグは必須です' });
      }
      return validationError('カテゴリ、サブカテゴリ名、スラッグは必須です', fields);
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
      return validationError('料金プランが1つ以上必要です', [
        { field: 'plans', message: '料金プランが1つ以上必要です' },
      ]);
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

    const checkResult = await db.prepare(`PRAGMA table_info(treatment_plans)`).all<{ name: string }>();
    const hasTreatmentId = checkResult.success && checkResult.results?.some(col => col.name === 'treatment_id');
    const hasStaffCost = checkResult.success && checkResult.results?.some(col => col.name === 'staff_cost');

    // 3. treatment_plans に全料金プランをコピー
    let copiedPlansCount = 0;
    for (const plan of plansToCreate) {
      await db.prepare(`
        INSERT INTO treatment_plans (
            ${hasTreatmentId ? 'treatment_id' : 'subcategory_id'}, plan_name, plan_type, sessions, quantity,
            price, price_taxed, price_per_session, price_per_session_taxed,
            supply_cost, ${hasStaffCost ? 'staff_cost' : 'labor_cost'}, total_cost, cost_rate,
            staff_discount_rate, staff_price,
            sort_order, is_active, is_public, is_recommended, notes
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, ?, ?)
      `).bind(
        hasTreatmentId ? treatmentId : subcategoryId,
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

    return jsonResponse(200, { 
      success: true,
      subcategory_id: subcategoryId,
      treatment_id: treatmentId,
      plans_copied: copiedPlansCount,
      message: `「${launch.name}」を発売しました（${copiedPlansCount}件のプランをコピー）`
    });
  });
};
