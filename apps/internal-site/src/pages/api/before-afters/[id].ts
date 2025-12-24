import type { APIRoute } from 'astro';
import { getDB, queryFirst, executeDB } from '../../../lib/db';

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
    
    const beforeAfter = await queryFirst<{
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
    }>(
      db,
      'SELECT * FROM treatment_before_afters WHERE id = ?',
      [id]
    );
    
    if (!beforeAfter) {
      return new Response(JSON.stringify({ error: 'Before/After not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    return new Response(JSON.stringify({ before_after: beforeAfter }), {
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
    
    // TODO: バリデーション
    
    const result = await executeDB(
      db,
      `
        UPDATE treatment_before_afters SET
          treatment_id = ?,
          before_image_url = ?,
          after_image_url = ?,
          caption = ?,
          patient_age = ?,
          patient_gender = ?,
          treatment_count = ?,
          treatment_period = ?,
          is_published = ?,
          sort_order = ?
        WHERE id = ?
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
        data.sort_order || 0,
        id
      ]
    );
    
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
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await executeDB(
      db,
      'DELETE FROM treatment_before_afters WHERE id = ?',
      [id]
    );
    
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
export const prerender = false;


