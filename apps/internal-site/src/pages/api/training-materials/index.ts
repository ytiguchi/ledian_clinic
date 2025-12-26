import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../../lib/db';

export const prerender = false;

const jsonResponse = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

export const POST: APIRoute = async ({ locals, request }) => {
  if (!locals?.runtime?.env) {
    return jsonResponse(500, { error: 'Database not available' });
  }

  try {
    const db = getDB(locals.runtime.env);
    const body = await request.json();
    const { 
      subcategory_id, 
      title, 
      description, 
      file_url, 
      file_type, 
      difficulty_level, 
      estimated_minutes,
      sort_order = 0
    } = body;

    if (!subcategory_id || !title) {
      return jsonResponse(400, { error: 'Subcategory ID and title are required' });
    }

    const id = crypto.randomUUID().replace(/-/g, '');

    await db.prepare(
      `INSERT INTO counseling_materials (
        id, subcategory_id, title, description, file_url, file_type, 
        difficulty_level, estimated_minutes, sort_order, is_published
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`
    ).bind(
      id, subcategory_id, title, description || null, file_url || null, file_type || null,
      difficulty_level || 'basic', estimated_minutes || null, sort_order
    ).run();

    return jsonResponse(201, { 
      success: true, 
      id,
      message: 'Counseling material created successfully' 
    });
  } catch (error) {
    console.error('Error creating training material:', error);
    return jsonResponse(500, { 
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};

