import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../lib/db';
import {
  jsonResponse,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
  type ValidationFieldError,
} from '../../lib/api';

export const prerender = false;

// タグ一覧の取得
export const GET: APIRoute = async ({ locals, url }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { tags: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

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
    
    return jsonResponse(200, { 
      tags: tags.map(t => ({
        ...t,
        is_active: t.is_active === 1,
      }))
    });
  });
};

// タグの作成
export const POST: APIRoute = async ({ locals, request }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const data = await request.json();
    
    if (!data.tag_type || !data.name || !data.slug) {
      const fields: ValidationFieldError[] = [];
      if (!data.tag_type) {
        fields.push({ field: 'tag_type', message: 'tag_type is required' });
      }
      if (!data.name) {
        fields.push({ field: 'name', message: 'name is required' });
      }
      if (!data.slug) {
        fields.push({ field: 'slug', message: 'slug is required' });
      }
      return validationError('tag_type, name, and slug are required', fields);
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
    
    return jsonResponse(201, { 
      success: true, 
      id: result.meta.last_row_id 
    });
  });
};
