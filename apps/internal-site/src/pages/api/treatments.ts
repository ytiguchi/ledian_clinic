import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../lib/db';

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ treatments: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = url.searchParams.get('subcategory_id');
    
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: 'subcategory_id is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const treatments = await queryDB<{
      id: string;
      name: string;
      slug: string;
      subcategory_id: string;
      sort_order: number;
      is_active: number;
    }>(
      db,
      'SELECT * FROM treatments WHERE subcategory_id = ? ORDER BY sort_order',
      [subcategoryId]
    );
    
    return new Response(JSON.stringify({
      treatments: treatments.map(t => ({
        ...t,
        is_active: t.is_active === 1,
      })),
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching treatments:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
