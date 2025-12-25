import type { APIRoute } from 'astro';
import { getDB } from '../../../lib/db';

export const prerender = false;

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ before_afters: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    
    const subcategoryId = url.searchParams.get('subcategory_id');
    const categoryId = url.searchParams.get('category_id');
    const isPublished = url.searchParams.get('is_published');
    
    let query = `
      SELECT 
        ba.id,
        ba.subcategory_id,
        ba.before_image_url,
        ba.after_image_url,
        ba.caption,
        ba.patient_age,
        ba.patient_gender,
        ba.treatment_count,
        ba.treatment_period,
        ba.is_published,
        ba.sort_order,
        ba.created_at,
        sc.name AS subcategory_name,
        c.id AS category_id,
        c.name AS category_name
      FROM treatment_before_afters ba
      JOIN subcategories sc ON ba.subcategory_id = sc.id
      JOIN categories c ON sc.category_id = c.id
      WHERE 1=1
    `;
    
    const params: unknown[] = [];
    
    if (categoryId) {
      query += ' AND c.id = ?';
      params.push(categoryId);
    }

    if (subcategoryId) {
      query += ' AND ba.subcategory_id = ?';
      params.push(subcategoryId);
    }
    
    if (isPublished !== null && isPublished !== undefined) {
      query += ' AND ba.is_published = ?';
      params.push(isPublished === '1' ? 1 : 0);
    }
    
    query += ' ORDER BY ba.sort_order, ba.created_at DESC';
    
    let stmt = db.prepare(query);
    if (params.length > 0) {
      stmt = stmt.bind(...params);
    }
    const result = await stmt.all<{
      id: string;
      subcategory_id: string;
      before_image_url: string;
      after_image_url: string;
      caption: string | null;
      patient_age: number | null;
      patient_gender: string | null;
      treatment_count: number | null;
      treatment_period: string | null;
      is_published: number;
      sort_order: number;
      created_at: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
    }>();
    
    if (!result.success) {
      throw new Error(result.error || 'Database query failed');
    }
    
    return new Response(JSON.stringify({ before_afters: result.results || [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching before-afters:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

export const POST: APIRoute = async ({ locals, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Environment not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const data = await request.json();
    
    // バリデーション
    if (!data.subcategory_id) {
      return new Response(JSON.stringify({ error: 'subcategory_id is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    if (!data.after_image_url) {
      return new Response(JSON.stringify({ error: 'after_image_url is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await db.prepare(`
      INSERT INTO treatment_before_afters (
        subcategory_id, before_image_url, after_image_url, caption,
        patient_age, patient_gender, treatment_count, treatment_period,
        is_published, sort_order
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      data.subcategory_id,
      data.before_image_url || '',
      data.after_image_url,
      data.caption || null,
      data.patient_age || null,
      data.patient_gender || null,
      data.treatment_count || null,
      data.treatment_period || null,
      data.is_published ? 1 : 0,
      data.sort_order || 0
    ).run();
    
    if (!result.success) {
      throw new Error(result.error || 'Failed to create before-after');
    }
    
    return new Response(JSON.stringify({
      id: result.meta.last_row_id,
      success: true
    }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error creating before-after:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
