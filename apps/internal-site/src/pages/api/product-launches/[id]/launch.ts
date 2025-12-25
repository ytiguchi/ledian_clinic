import type { APIRoute } from 'astro';
import { getDb } from '../../../../lib/db';

// 発売処理（subcategories + treatment_plans にマージ）
export const POST: APIRoute = async ({ params, request, locals }) => {
  try {
    const db = getDb(locals);
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
      plan_name = '1回',
      price,
      price_taxed,
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

    const finalPrice = price || launch.planned_price;
    const finalPriceTaxed = price_taxed || launch.planned_price_taxed;

    if (!finalPrice || !finalPriceTaxed) {
      return new Response(JSON.stringify({ error: '料金が設定されていません' }), {
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

    // 2. treatment_plans に料金プラン作成
    await db.prepare(`
      INSERT INTO treatment_plans (
        subcategory_id, plan_name, plan_type, 
        price, price_taxed, is_active
      ) VALUES (?, ?, 'single', ?, ?, 1)
    `).bind(
      subcategoryId,
      plan_name,
      finalPrice,
      finalPriceTaxed
    ).run();

    // 3. product_launches を更新
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
      message: `「${launch.name}」を発売しました`
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

