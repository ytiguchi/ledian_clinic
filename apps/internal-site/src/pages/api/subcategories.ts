import type { APIRoute } from 'astro';
import { getDB } from '../../lib/db';
import type { SubcategoriesResponse } from '../../types/api';

export const prerender = false;

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ subcategories: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const categoryId = url.searchParams.get('category_id')?.trim();
    
    const params: unknown[] = [];
    let query = `
      SELECT 
        sc.id,
        sc.name,
        sc.slug,
        sc.category_id,
        sc.sort_order,
        sc.is_active,
        c.name AS category_name
      FROM subcategories sc
      JOIN categories c ON sc.category_id = c.id
      WHERE sc.is_active = 1
    `;
    
    if (categoryId && categoryId !== '' && categoryId !== 'undefined' && categoryId !== 'null') {
      query += ' AND sc.category_id = ?';
      params.push(categoryId);
    }
    
    query += ' ORDER BY sc.sort_order';
    
    console.log('Subcategories query:', query);
    console.log('Subcategories params:', params);
    console.log('Subcategories params length:', params.length);
    console.log('Subcategories categoryId:', categoryId);
    
    // クエリとパラメータをログ出力
    const questionMarks = (query.match(/\?/g) || []).length;
    console.log('Final query question marks:', questionMarks);
    console.log('Final params length:', params.length);
    console.log('Query:', query);
    console.log('Params:', JSON.stringify(params));
    
    // queryDBの代わりに直接prepareとbindを使用
    let stmt = db.prepare(query);
    if (params.length > 0) {
      stmt = stmt.bind(...params);
    }
    const result = await stmt.all<{
      id: string;
      name: string;
      slug: string;
      category_id: string;
      sort_order: number;
      is_active: number;
      category_name: string;
    }>();
    
    if (!result.success) {
      throw new Error(result.error || 'Database query failed');
    }
    
    const subcategories = result.results || [];
    
    const response: SubcategoriesResponse = {
      subcategories: subcategories.map(sub => ({
        ...sub,
        is_active: sub.is_active === 1,
      })),
    };
    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching subcategories:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    const errorStack = error instanceof Error ? error.stack : undefined;
    console.error('Error details:', { errorMessage, errorStack });
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: errorMessage,
      stack: errorStack
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

