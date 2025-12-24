import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB, queryFirst } from '../../lib/db';

export const prerender = false;

// タグ一覧の取得
export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ tags: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const tagType = url.searchParams.get('tag_type');
    
    let query = 'SELECT * FROM tags WHERE is_active = 1';
    const params: unknown[] = [];
    
    if (tagType) {
      query += ' AND tag_type = ?';
      params.push(tagType);
    }
    
    query += ' ORDER BY tag_type, sort_order, name';
    
    const tags = await queryDB<{
      id: string;
      tag_type: string;
      name: string;
      slug: string;
      icon: string | null;
      description: string | null;
      sort_order: number;
      is_active: number;
      created_at: string;
    }>(db, query, params);
    
    return new Response(JSON.stringify({ 
      tags: tags.map(t => ({
        ...t,
        is_active: t.is_active === 1,
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

// タグの作成
export const POST: APIRoute = async ({ locals, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const data = await request.json();
    
    if (!data.tag_type || !data.name || !data.slug) {
      return new Response(JSON.stringify({ error: 'tag_type, name, and slug are required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await executeDB(
      db,
      `
        INSERT INTO tags (
          tag_type, name, slug, icon, description, sort_order, is_active
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [
        data.tag_type,
        data.name,
        data.slug,
        data.icon || null,
        data.description || null,
        data.sort_order || 0,
        data.is_active !== false ? 1 : 0,
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
    console.error('Error creating tag:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

