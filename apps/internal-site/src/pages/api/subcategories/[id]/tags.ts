import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../../lib/db';

export const prerender = false;

// サブカテゴリのタグ紐付け取得
export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ tags: [] }), {
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
    
    const tags = await queryDB<{
      id: string;
      subcategory_id: string;
      tag_id: string;
      tag_name: string;
      tag_type: string;
      is_primary: number;
      sort_order: number;
      created_at: string;
    }>(
      db,
      `
        SELECT 
          tt.id,
          tt.subcategory_id,
          tt.tag_id,
          t.name AS tag_name,
          t.tag_type,
          tt.is_primary,
          tt.sort_order,
          tt.created_at
        FROM treatment_tags tt
        JOIN tags t ON tt.tag_id = t.id
        WHERE tt.subcategory_id = ?
        ORDER BY tt.sort_order, t.tag_type, t.name
      `,
      [subcategoryId]
    );
    
    return new Response(JSON.stringify({ 
      tags: tags.map(t => ({
        ...t,
        is_primary: t.is_primary === 1,
      }))
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching tags:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// タグ紐付けの追加
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
        INSERT INTO treatment_tags (subcategory_id, tag_id, is_primary, sort_order)
        VALUES (?, ?, ?, ?)
      `,
      [
        subcategoryId,
        data.tag_id,
        data.is_primary ? 1 : 0,
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
    console.error('Error creating tag link:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// タグ紐付けの削除
export const DELETE: APIRoute = async ({ locals, params, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    const url = new URL(request.url);
    const tagId = url.searchParams.get('tag_id');
    
    if (!subcategoryId || !tagId) {
      return new Response(JSON.stringify({ error: 'Subcategory ID and Tag ID are required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    await executeDB(
      db,
      'DELETE FROM treatment_tags WHERE subcategory_id = ? AND tag_id = ?',
      [subcategoryId, tagId]
    );
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error deleting tag link:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

