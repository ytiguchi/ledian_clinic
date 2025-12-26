import type { APIRoute } from 'astro';
import { getDB, queryFirst } from '../../../lib/db';
import {
  jsonResponse,
  requireParam,
  requireRuntimeEnv,
  withErrorHandling,
} from '../../../lib/api';

export const prerender = false;

// 施術情報の取得（カテゴリ・サブカテゴリ情報も含む）
export const GET: APIRoute = async ({ locals, params }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { treatment: null },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    const idResponse = requireParam(id, 'Treatment ID');
    if (idResponse) return idResponse;
    
    const treatment = await queryFirst<{
      id: string;
      name: string;
      slug: string;
      description: string | null;
      subcategory_id: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
      sort_order: number;
      is_active: number;
    }>(
      db,
      `
        SELECT 
          t.id,
          t.name,
          t.slug,
          t.description,
          t.sort_order,
          t.is_active,
          sc.id AS subcategory_id,
          sc.name AS subcategory_name,
          c.id AS category_id,
          c.name AS category_name
        FROM treatments t
        JOIN subcategories sc ON t.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE t.id = ?
      `,
      [id]
    );
    
    if (!treatment) {
      return jsonResponse(404, { error: 'Treatment not found' });
    }
    
    return jsonResponse(200, { 
      treatment: {
        ...treatment,
        is_active: treatment.is_active === 1,
      }
    });
  });
};
