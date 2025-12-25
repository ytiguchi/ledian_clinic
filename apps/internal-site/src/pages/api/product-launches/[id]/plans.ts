import type { APIRoute } from 'astro';
import { getDB } from '../../../../lib/db';

// 料金プラン一覧取得
export const GET: APIRoute = async ({ params, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;

    const { results: plans } = await db.prepare(`
      SELECT * FROM launch_plans 
      WHERE launch_id = ? 
      ORDER BY sort_order, id
    `).bind(id).all();

    return new Response(JSON.stringify({ plans }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error fetching plans:', error);
    return new Response(JSON.stringify({ 
      error: 'プラン取得に失敗しました',
      plans: []
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// 料金プラン追加
export const POST: APIRoute = async ({ params, request, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    const {
      plan_name,
      plan_type = 'single',
      sessions = 1,
      quantity,
      price,
      price_taxed
    } = body;

    if (!plan_name || !price || !price_taxed) {
      return new Response(JSON.stringify({ 
        error: 'プラン名、税抜価格、税込価格は必須です' 
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    // Get next sort order
    const maxSort = await db.prepare(`
      SELECT COALESCE(MAX(sort_order), 0) + 1 as next_order 
      FROM launch_plans WHERE launch_id = ?
    `).bind(id).first() as any;

    await db.prepare(`
      INSERT INTO launch_plans (
        launch_id, plan_name, plan_type, sessions, quantity,
        price, price_taxed, sort_order
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      id,
      plan_name,
      plan_type,
      sessions,
      quantity || null,
      price,
      price_taxed,
      maxSort?.next_order || 1
    ).run();

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error adding plan:', error);
    return new Response(JSON.stringify({ 
      error: 'プラン追加に失敗しました',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// 料金プラン削除
export const DELETE: APIRoute = async ({ params, url, locals }) => {
  try {
    const db = getDB(locals.runtime.env);
    const planId = url.searchParams.get('plan_id');

    if (!planId) {
      return new Response(JSON.stringify({ error: 'plan_id is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    await db.prepare(`
      DELETE FROM launch_plans WHERE id = ? AND launch_id = ?
    `).bind(planId, params.id).run();

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error deleting plan:', error);
    return new Response(JSON.stringify({ 
      error: 'プラン削除に失敗しました'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

