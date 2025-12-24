import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../../lib/db';

export const prerender = false;

// 注意事項の取得
export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ cautions: [] }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const treatmentId = params.id;
    
    if (!treatmentId) {
      return new Response(JSON.stringify({ error: 'Treatment ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const cautions = await queryDB<{
      id: string;
      treatment_id: string;
      caution_type: string;
      content: string;
      sort_order: number;
      created_at: string;
    }>(
      db,
      'SELECT * FROM treatment_cautions WHERE treatment_id = ? ORDER BY sort_order, caution_type',
      [treatmentId]
    );
    
    return new Response(JSON.stringify({ cautions }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching treatment cautions:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// 注意事項の一括保存
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
    
    const cautions = Array.isArray(data.cautions) ? data.cautions : [];
    
    // 既存の注意事項を削除
    await executeDB(
      db,
      'DELETE FROM treatment_cautions WHERE treatment_id = ?',
      [treatmentId]
    );
    
    // 新しい注意事項を追加
    for (const caution of cautions) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_cautions (
            treatment_id, caution_type, content, sort_order
          ) VALUES (?, ?, ?, ?)
        `,
        [
          treatmentId,
          caution.caution_type,
          caution.content,
          caution.sort_order || 0,
        ]
      );
    }
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error saving treatment cautions:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

