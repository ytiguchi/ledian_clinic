import type { APIRoute } from 'astro';
import { getDB } from '../../../lib/db';

// 発売予定商品詳細取得
export const GET: APIRoute = async ({ params, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;

    const launch = await db.prepare(`
      SELECT 
        pl.*,
        c.name as category_name
      FROM product_launches pl
      LEFT JOIN categories c ON pl.target_category_id = c.id
      WHERE pl.id = ?
    `).bind(id).first();

    if (!launch) {
      return new Response(JSON.stringify({ error: 'Not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    const tasks = await db.prepare(`
      SELECT * FROM launch_tasks WHERE launch_id = ? ORDER BY sort_order ASC
    `).bind(id).all();

    const plans = await db.prepare(`
      SELECT * FROM launch_plans WHERE launch_id = ? ORDER BY sort_order, id
    `).bind(id).all();

    return new Response(JSON.stringify({
      launch,
      tasks: tasks.results || [],
      plans: plans.results || []
    }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error fetching product launch:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to fetch product launch',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// 発売予定商品更新（部分更新対応）
export const PUT: APIRoute = async ({ params, request, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    // 現在のデータを取得
    const currentLaunch = await db.prepare('SELECT * FROM product_launches WHERE id = ?').bind(id).first() as any;
    
    if (!currentLaunch) {
      return new Response(JSON.stringify({ error: 'Not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    // 部分更新：渡されたフィールドのみ更新、undefined は現在の値を維持
    const getValue = (key: string, defaultValue: any = null) => {
      return body[key] !== undefined ? (body[key] || defaultValue) : currentLaunch[key];
    };

    const status = getValue('status');
    
    // ステータス変更時に完了日を更新
    let pricingCompletedAt = getValue('pricing_completed_at');
    let protocolCompletedAt = getValue('protocol_completed_at');
    let trainingCompletedAt = getValue('training_completed_at');

    if (status !== currentLaunch.status) {
      const now = new Date().toISOString();
      if (status === 'protocol' && !pricingCompletedAt) pricingCompletedAt = now;
      if (status === 'training' && !protocolCompletedAt) protocolCompletedAt = now;
      if (status === 'ready' && !trainingCompletedAt) trainingCompletedAt = now;
    }

    await db.prepare(`
      UPDATE product_launches SET
        name = ?,
        description = ?,
        status = ?,
        target_category_id = ?,
        target_subcategory_name = ?,
        planned_price = ?,
        planned_price_taxed = ?,
        price_notes = ?,
        pricing_completed_at = ?,
        protocol_document_url = ?,
        protocol_notes = ?,
        protocol_completed_at = ?,
        training_document_url = ?,
        training_video_url = ?,
        training_notes = ?,
        training_completed_at = ?,
        target_launch_date = ?,
        owner_name = ?,
        priority = ?,
        notes = ?,
        updated_at = datetime('now')
      WHERE id = ?
    `).bind(
      getValue('name'),
      getValue('description'),
      status,
      getValue('target_category_id'),
      getValue('target_subcategory_name'),
      getValue('planned_price'),
      getValue('planned_price_taxed'),
      getValue('price_notes'),
      pricingCompletedAt,
      getValue('protocol_document_url'),
      getValue('protocol_notes'),
      protocolCompletedAt,
      getValue('training_document_url'),
      getValue('training_video_url'),
      getValue('training_notes'),
      trainingCompletedAt,
      getValue('target_launch_date'),
      getValue('owner_name'),
      getValue('priority', 0),
      getValue('notes'),
      id
    ).run();

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error updating product launch:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to update product launch',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// 発売予定商品削除
export const DELETE: APIRoute = async ({ params, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;

    await db.prepare('DELETE FROM product_launches WHERE id = ?').bind(id).run();

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error deleting product launch:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to delete product launch',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

