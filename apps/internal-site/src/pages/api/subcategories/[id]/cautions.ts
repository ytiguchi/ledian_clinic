import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../../lib/db';

export const prerender = false;

// サブカテゴリの注意事項取得
export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ cautions: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: 'Subcategory ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const cautions = await queryDB<{
      id: string;
      subcategory_id: string;
      caution_type: string;
      content: string;
      sort_order: number;
      created_at: string;
    }>(
      db,
      'SELECT * FROM treatment_cautions WHERE subcategory_id = ? ORDER BY sort_order, caution_type',
      [subcategoryId]
    );
    
    return new Response(JSON.stringify({ cautions }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching cautions:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// 注意事項の作成
export const POST: APIRoute = async ({ locals, params, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    const data = await request.json();
    
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: 'Subcategory ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await executeDB(
      db,
      `
        INSERT INTO treatment_cautions (subcategory_id, caution_type, content, sort_order)
        VALUES (?, ?, ?, ?)
      `,
      [
        subcategoryId,
        data.caution_type,
        data.content,
        data.sort_order || 0,
      ]
    );
    
    return new Response(JSON.stringify({ 
      success: true, 
      id: result.meta.last_row_id 
    }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error creating caution:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

