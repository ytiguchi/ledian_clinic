import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../../lib/db';
import { parseIsPublishedParam } from '../../../lib/api';

export const prerender = false;

const jsonResponse = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return jsonResponse(200, { protocols: [] });
  }

  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = url.searchParams.get('subcategory_id');
    const isPublished = parseIsPublishedParam(url.searchParams.get('is_published'));

    if (!subcategoryId) {
      return jsonResponse(400, { error: 'Subcategory ID is required' });
    }

    const params: Array<string | number> = [subcategoryId];
    let query = `
      SELECT id, subcategory_id, title, description, version, file_url, file_type,
             sort_order, is_published, created_at, updated_at
      FROM treatment_protocols
      WHERE subcategory_id = ?
    `;
    if (isPublished !== null) {
      query += ' AND is_published = ?';
      params.push(isPublished);
    }
    query += ' ORDER BY sort_order';

    const protocols = await queryDB(db, query, params);
    return jsonResponse(200, { protocols });
  } catch (error) {
    console.error('Error fetching treatment protocols:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};

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
      version,
      file_url, 
      file_type, 
      sort_order = 0
    } = body;

    if (!subcategory_id || !title) {
      return jsonResponse(400, { error: 'Subcategory ID and title are required' });
    }

    const id = crypto.randomUUID().replace(/-/g, '');

    await db.prepare(
      `INSERT INTO treatment_protocols (
        id, subcategory_id, title, description, version, file_url, file_type, 
        sort_order, is_published
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)`
    ).bind(
      id, subcategory_id, title, description || null, version || '1.0', file_url || null, file_type || null,
      sort_order
    ).run();

    return jsonResponse(201, { 
      success: true, 
      id,
      message: 'Treatment protocol created successfully' 
    });
  } catch (error) {
    console.error('Error creating treatment protocol:', error);
    return jsonResponse(500, { 
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};
