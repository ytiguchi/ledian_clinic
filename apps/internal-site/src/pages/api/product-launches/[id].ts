import type { APIRoute } from 'astro';
import { getDB } from '../../../lib/db';
import {
  jsonResponse,
  requireParam,
  requireRuntimeEnv,
  withErrorHandling,
} from '../../../lib/api';

// 発売予定商品詳細取得
export const GET: APIRoute = async ({ params, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { launch: null, tasks: [], plans: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;

    const idResponse = requireParam(id, 'Launch ID');
    if (idResponse) return idResponse;

    const launch = await db.prepare(`
      SELECT 
        pl.*,
        c.name as category_name
      FROM product_launches pl
      LEFT JOIN categories c ON pl.target_category_id = c.id
      WHERE pl.id = ?
    `).bind(id).first();

    if (!launch) {
      return jsonResponse(404, { error: 'Not found' });
    }

    const tasks = await db.prepare(`
      SELECT * FROM launch_tasks WHERE launch_id = ? ORDER BY sort_order ASC
    `).bind(id).all();

    const plans = await db.prepare(`
      SELECT * FROM launch_plans WHERE launch_id = ? ORDER BY sort_order, id
    `).bind(id).all();

    return jsonResponse(200, {
      launch,
      tasks: tasks.results || [],
      plans: plans.results || []
    });
  });
};

// 発売予定商品更新（部分更新対応）
export const PUT: APIRoute = async ({ params, request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    const idResponse = requireParam(id, 'Launch ID');
    if (idResponse) return idResponse;

    // 現在のデータを取得
    const currentLaunch = await db.prepare('SELECT * FROM product_launches WHERE id = ?').bind(id).first() as any;
    
    if (!currentLaunch) {
      return jsonResponse(404, { error: 'Not found' });
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

    return jsonResponse(200, { success: true });
  });
};

// 発売予定商品削除
export const DELETE: APIRoute = async ({ params, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;

    const idResponse = requireParam(id, 'Launch ID');
    if (idResponse) return idResponse;

    await db.prepare('DELETE FROM product_launches WHERE id = ?').bind(id).run();

    return jsonResponse(200, { success: true });
  });
};
