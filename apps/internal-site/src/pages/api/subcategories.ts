import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../lib/db';

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ subcategories: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const categoryId = url.searchParams.get('category_id');
    
    if (!categoryId) {
      return new Response(JSON.stringify({ error: 'category_id is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const subcategories = await queryDB<{
      id: string;
      name: string;
      slug: string;
      category_id: string;
      sort_order: number;
      is_active: number;
    }>(
      db,
      'SELECT * FROM subcategories WHERE category_id = ? ORDER BY sort_order',
      [categoryId]
    );
    
    return new Response(JSON.stringify({
      subcategories: subcategories.map(sub => ({
        ...sub,
        is_active: sub.is_active === 1,
      })),
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching subcategories:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
