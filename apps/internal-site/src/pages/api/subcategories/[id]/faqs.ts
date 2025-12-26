import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../../lib/db';
import { parseIsPublishedParam } from '../../../../lib/api';

export const prerender = false;

// サブカテゴリのFAQ取得
export const GET: APIRoute = async ({ locals, params, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ faqs: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    const isPublished = parseIsPublishedParam(url.searchParams.get('is_published'));
    
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: 'Subcategory ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const queryParams: Array<string | number> = [subcategoryId];
    let query = 'SELECT * FROM treatment_faqs WHERE subcategory_id = ?';
    if (isPublished !== null) {
      query += ' AND is_published = ?';
      queryParams.push(isPublished);
    }
    query += ' ORDER BY sort_order';

    const faqs = await queryDB<{
      id: string;
      subcategory_id: string;
      question: string;
      answer: string;
      sort_order: number;
      is_published: number;
      created_at: string;
      updated_at: string;
    }>(db, query, queryParams);
    
    return new Response(JSON.stringify({ 
      faqs: faqs.map(f => ({
        ...f,
        is_published: f.is_published === 1,
      }))
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching FAQs:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// FAQの作成
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
        INSERT INTO treatment_faqs (subcategory_id, question, answer, sort_order, is_published)
        VALUES (?, ?, ?, ?, ?)
      `,
      [
        subcategoryId,
        data.question,
        data.answer,
        data.sort_order || 0,
        data.is_published !== false ? 1 : 0,
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
    console.error('Error creating FAQ:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
