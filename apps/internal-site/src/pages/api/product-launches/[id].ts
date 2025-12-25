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

    return new Response(JSON.stringify({
      launch,
      tasks: tasks.results || []
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

// 発売予定商品更新
export const PUT: APIRoute = async ({ params, request, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    const {
      name,
      description,
      status,
      target_category_id,
      target_subcategory_name,
      planned_price,
      planned_price_taxed,
      price_notes,
      protocol_document_url,
      protocol_notes,
      training_document_url,
      training_video_url,
      training_notes,
      target_launch_date,
      owner_name,
      priority,
      notes
    } = body;

    // ステータス変更時に完了日を更新
    let pricingCompletedAt = body.pricing_completed_at;
    let protocolCompletedAt = body.protocol_completed_at;
    let trainingCompletedAt = body.training_completed_at;

    const currentLaunch = await db.prepare('SELECT status FROM product_launches WHERE id = ?').bind(id).first() as any;
    
    if (currentLaunch && status !== currentLaunch.status) {
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
      name,
      description || null,
      status,
      target_category_id || null,
      target_subcategory_name || null,
      planned_price || null,
      planned_price_taxed || null,
      price_notes || null,
      pricingCompletedAt || null,
      protocol_document_url || null,
      protocol_notes || null,
      protocolCompletedAt || null,
      training_document_url || null,
      training_video_url || null,
      training_notes || null,
      trainingCompletedAt || null,
      target_launch_date || null,
      owner_name || null,
      priority || 0,
      notes || null,
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

