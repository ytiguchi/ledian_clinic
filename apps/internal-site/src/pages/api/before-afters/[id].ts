import type { APIRoute } from 'astro';
import { getDB } from '../../../lib/db';
import {
  jsonResponse,
  requireParam,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
} from '../../../lib/api';

export const prerender = false;

export const GET: APIRoute = async ({ locals, params }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { before_after: null },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    const idResponse = requireParam(id, 'Before/After ID');
    if (idResponse) return idResponse;
    
    const result = await db.prepare(`
      SELECT 
        ba.*,
        t.name AS treatment_name,
        t.slug AS treatment_slug,
        sc.id AS subcategory_id,
        sc.name AS subcategory_name,
        c.id AS category_id,
        c.name AS category_name
      FROM treatment_before_afters ba
      JOIN treatments t ON ba.treatment_id = t.id
      JOIN subcategories sc ON t.subcategory_id = sc.id
      JOIN categories c ON sc.category_id = c.id
      WHERE ba.id = ?
    `).bind(id).first<{
      id: string;
      treatment_id: string;
      before_image_url: string;
      after_image_url: string;
      caption: string | null;
      treatment_content: string | null;
      treatment_duration: string | null;
      treatment_cost: number | null;
      treatment_cost_text: string | null;
      risks: string | null;
      patient_age: number | null;
      patient_gender: string | null;
      treatment_count: number | null;
      treatment_period: string | null;
      is_published: number;
      sort_order: number;
      created_at: string;
      treatment_name: string;
      treatment_slug: string;
      subcategory_id: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
    }>();
    
    if (!result) {
      return jsonResponse(404, { error: 'Before/After not found' });
    }
    
    return jsonResponse(200, { before_after: result });
  });
};

export const PUT: APIRoute = async ({ locals, params, request }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Environment not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data = await request.json();
    
    const idResponse = requireParam(id, 'Before/After ID');
    if (idResponse) return idResponse;
    
    // バリデーション
    if (!data.treatment_id) {
      return validationError('treatment_id is required', [
        { field: 'treatment_id', message: 'treatment_id is required' },
      ]);
    }
    if (!data.after_image_url) {
      return validationError('after_image_url is required', [
        { field: 'after_image_url', message: 'after_image_url is required' },
      ]);
    }
    
    const result = await db.prepare(`
      UPDATE treatment_before_afters SET
        treatment_id = ?,
        before_image_url = ?,
        after_image_url = ?,
        caption = ?,
        treatment_content = ?,
        treatment_duration = ?,
        treatment_cost = ?,
        treatment_cost_text = ?,
        risks = ?,
        patient_age = ?,
        patient_gender = ?,
        treatment_count = ?,
        treatment_period = ?,
        is_published = ?,
        sort_order = ?,
        updated_at = datetime('now')
      WHERE id = ?
    `).bind(
      data.treatment_id,
      data.before_image_url || '',
      data.after_image_url,
      data.caption || null,
      data.treatment_content || null,
      data.treatment_duration || null,
      data.treatment_cost ?? null,
      data.treatment_cost_text || null,
      data.risks || null,
      data.patient_age || null,
      data.patient_gender || null,
      data.treatment_count || null,
      data.treatment_period || null,
      data.is_published ? 1 : 0,
      data.sort_order || 0,
      id
    ).run();
    
    if (!result.success) {
      throw new Error(result.error || 'Failed to update before-after');
    }
    
    return jsonResponse(200, { success: true, id });
  });
};

export const DELETE: APIRoute = async ({ locals, params }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Environment not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    const idResponse = requireParam(id, 'Before/After ID');
    if (idResponse) return idResponse;
    
    const result = await db.prepare('DELETE FROM treatment_before_afters WHERE id = ?').bind(id).run();
    
    if (!result.success) {
      throw new Error(result.error || 'Failed to delete before-after');
    }
    
    return jsonResponse(200, { success: true });
  });
};
