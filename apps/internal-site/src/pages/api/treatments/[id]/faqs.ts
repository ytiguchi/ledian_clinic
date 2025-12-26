import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../../lib/db';
import { parseIsPublishedParam } from '../../../../lib/api';

export const prerender = false;

// FAQの取得
export const GET: APIRoute = async ({ locals, params, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ faqs: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const treatmentId = params.id;
    const isPublished = parseIsPublishedParam(url.searchParams.get('is_published'));
    
    if (!treatmentId) {
      return new Response(JSON.stringify({ error: 'Treatment ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const queryParams: Array<string | number> = [treatmentId];
    let query = 'SELECT * FROM treatment_faqs WHERE treatment_id = ?';
    if (isPublished !== null) {
      query += ' AND is_published = ?';
      queryParams.push(isPublished);
    }
    query += ' ORDER BY sort_order';

    const faqs = await queryDB<{
      id: string;
      treatment_id: string;
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
    console.error('Error fetching treatment FAQs:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// FAQの一括保存
export const POST: APIRoute = async ({ locals, params, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const treatmentId = params.id;
    const data = await request.json();
    
    if (!treatmentId) {
      return new Response(JSON.stringify({ error: 'Treatment ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const faqs = Array.isArray(data.faqs) ? data.faqs : [];
    
    // 既存のFAQを削除
    await executeDB(
      db,
      'DELETE FROM treatment_faqs WHERE treatment_id = ?',
      [treatmentId]
    );
    
    // 新しいFAQを追加
    for (const faq of faqs) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_faqs (
            treatment_id, question, answer, sort_order, is_published
          ) VALUES (?, ?, ?, ?, ?)
        `,
        [
          treatmentId,
          faq.question,
          faq.answer,
          faq.sort_order || 0,
          faq.is_published ? 1 : 0,
        ]
      );
    }
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error saving treatment FAQs:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
