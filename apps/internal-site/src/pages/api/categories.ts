import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../lib/db';
import type { CategoriesResponse } from '../../types/api';

export const GET: APIRoute = async ({ locals }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ categories: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  }
  try {
    const db = getDB(locals.runtime.env);
    
    const categories = await queryDB<{
      id: string;
      name: string;
      slug: string;
      sort_order: number;
      is_active: number;
      created_at: string;
      updated_at: string;
    }>(
      db,
      'SELECT * FROM categories ORDER BY sort_order'
    );

    const response: CategoriesResponse = {
      categories: categories.map(cat => ({
        ...cat,
        is_active: cat.is_active === 1,
      })),
    };
    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  } catch (error) {
    console.error('Error fetching categories:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  }
};

export const prerender = false;
