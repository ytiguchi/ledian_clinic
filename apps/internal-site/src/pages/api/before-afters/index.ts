import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../lib/db';

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ before_afters: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    
    const treatmentId = url.searchParams.get('treatment_id');
    const isPublished = url.searchParams.get('is_published');
    
    let query = `
      SELECT 
        ba.id,
        ba.treatment_id,
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
        t.name AS treatment_name
      FROM treatment_before_afters ba
      JOIN treatments t ON ba.treatment_id = t.id
      WHERE 1=1
    `;
    
    const params: unknown[] = [];
    
    if (treatmentId) {
      query += ' AND ba.treatment_id = ?';
      params.push(treatmentId);
    }
    
    if (isPublished !== null) {
      query += ' AND ba.is_published = ?';
      params.push(isPublished === '1' ? 1 : 0);
    }
    
    query += ' ORDER BY ba.sort_order, ba.created_at DESC';
    
    const beforeAfters = await queryDB<{
      id: string;
      treatment_id: string;
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
      treatment_name: string;
    }>(db, query, params);
    
    return new Response(JSON.stringify({ before_afters: beforeAfters }), {
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
  try {
    const db = getDB(locals.runtime.env);
    const data = await request.json();
    
    // TODO: バリデーション
    // - treatment_id が存在するか
    // - before_image_url, after_image_url が必須
    
    const result = await executeDB(
      db,
      `
        INSERT INTO treatment_before_afters (
          treatment_id, before_image_url, after_image_url, caption,
          patient_age, patient_gender, treatment_count, treatment_period,
          is_published, sort_order
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        data.treatment_id,
        data.before_image_url,
        data.after_image_url,
        data.caption || null,
        data.patient_age || null,
        data.patient_gender || null,
        data.treatment_count || null,
        data.treatment_period || null,
        data.is_published ? 1 : 0,
        data.sort_order || 0
      ]
    );
    
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


