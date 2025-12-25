import type { APIRoute } from 'astro';
import { getDB } from '../../../lib/db';

export const prerender = false;

export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ before_after: null }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await db.prepare(`
      SELECT 
        ba.*,
        sc.name AS subcategory_name,
        c.id AS category_id,
        c.name AS category_name
      FROM treatment_before_afters ba
      JOIN subcategories sc ON ba.subcategory_id = sc.id
      JOIN categories c ON sc.category_id = c.id
      WHERE ba.id = ?
    `).bind(id).first<{
      id: string;
      subcategory_id: string;
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
      updated_at: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
    }>();
    
    if (!result) {
      return new Response(JSON.stringify({ error: 'Before/After not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    return new Response(JSON.stringify({ before_after: result }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching before-after:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

export const PUT: APIRoute = async ({ locals, params, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Environment not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data = await request.json();
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    // バリデーション
    if (!data.subcategory_id) {
      return new Response(JSON.stringify({ error: 'subcategory_id is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    if (!data.before_image_url || !data.after_image_url) {
      return new Response(JSON.stringify({ error: 'before_image_url and after_image_url are required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await db.prepare(`
      UPDATE treatment_before_afters SET
        subcategory_id = ?,
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
      data.subcategory_id,
      data.before_image_url,
      data.after_image_url,
      data.caption || null,
      data.treatment_content || null,
      data.treatment_duration || null,
      data.treatment_cost || null,
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
    
    return new Response(JSON.stringify({ success: true, id }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error updating before-after:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

export const DELETE: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Environment not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await db.prepare('DELETE FROM treatment_before_afters WHERE id = ?').bind(id).run();
    
    if (!result.success) {
      throw new Error(result.error || 'Failed to delete before-after');
    }
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error deleting before-after:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};


