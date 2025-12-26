import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../lib/db';
import { jsonResponse, requireRuntimeEnv, withErrorHandling } from '../../lib/api';

export const GET: APIRoute = async ({ locals, url }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { treatments: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const subcategoryId = url.searchParams.get('subcategory_id');
    const categoryId = url.searchParams.get('category_id');
    const search = url.searchParams.get('search');
    
    let query = `
      SELECT 
        t.id,
        t.name,
        t.slug,
        t.sort_order,
        t.is_active,
        sc.id AS subcategory_id,
        sc.name AS subcategory_name,
        c.id AS category_id,
        c.name AS category_name
      FROM treatments t
      JOIN subcategories sc ON t.subcategory_id = sc.id
      JOIN categories c ON sc.category_id = c.id
      WHERE 1=1
    `;
    
    const params: unknown[] = [];
    
    if (categoryId) {
      query += ' AND c.id = ?';
      params.push(categoryId);
    }
    
    if (subcategoryId) {
      query += ' AND sc.id = ?';
      params.push(subcategoryId);
    }
    
    if (search) {
      query += ' AND t.name LIKE ?';
      params.push(`%${search}%`);
    }
    
    query += ' ORDER BY c.sort_order, sc.sort_order, t.sort_order';
    
    const treatments = await queryDB<{
      id: string;
      name: string;
      slug: string;
      sort_order: number;
      is_active: number;
      subcategory_id: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
    }>(db, query, params);
    
    return jsonResponse(200, {
      treatments: treatments.map(t => ({
        ...t,
        is_active: t.is_active === 1,
      })),
    });
  });
};
export const prerender = false;

