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

// 料金プラン一覧取得
export const GET: APIRoute = async ({ params, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { plans: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;

    const idResponse = requireParam(id, 'Launch ID');
    if (idResponse) return idResponse;

    const { results: plans } = await db.prepare(`
      SELECT * FROM launch_plans 
      WHERE launch_id = ? 
      ORDER BY sort_order, id
    `).bind(id).all();

    return jsonResponse(200, { plans });
  });
};

// 料金プラン追加
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

    const idResponse = requireParam(id, 'Launch ID');
    if (idResponse) return idResponse;

    const {
      plan_name,
      plan_type = 'single',
      sessions = 1,
      quantity,
      price,
      price_taxed
    } = body;

    if (!plan_name || !price || !price_taxed) {
      const fields: ValidationFieldError[] = [];
      if (!plan_name) {
        fields.push({ field: 'plan_name', message: 'plan_name is required' });
      }
      if (!price) {
        fields.push({ field: 'price', message: 'price is required' });
      }
      if (!price_taxed) {
        fields.push({ field: 'price_taxed', message: 'price_taxed is required' });
      }
      return validationError('プラン名、税抜価格、税込価格は必須です', fields);
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

    return jsonResponse(200, { success: true });
  });
};

// 料金プラン削除
export const DELETE: APIRoute = async ({ params, url, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const planId = url.searchParams.get('plan_id');

    if (!planId) {
      return validationError('plan_id is required', [
        { field: 'plan_id', message: 'plan_id is required' },
      ]);
    }

    const idResponse = requireParam(params.id, 'Launch ID');
    if (idResponse) return idResponse;

    await db.prepare(`
      DELETE FROM launch_plans WHERE id = ? AND launch_id = ?
    `).bind(planId, params.id).run();

    return jsonResponse(200, { success: true });
  });
};
