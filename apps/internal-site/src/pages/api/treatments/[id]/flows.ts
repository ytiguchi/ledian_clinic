import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB } from '../../../../lib/db';

export const prerender = false;

// 施術フローの取得
export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ flows: [] }), {
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
    
    const flows = await queryDB<{
      id: string;
      treatment_id: string;
      step_number: number;
      title: string;
      description: string | null;
      duration_minutes: number | null;
      icon: string | null;
      created_at: string;
    }>(
      db,
      'SELECT * FROM treatment_flows WHERE treatment_id = ? ORDER BY step_number',
      [treatmentId]
    );
    
    return new Response(JSON.stringify({ flows }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching treatment flows:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// 施術フローの一括保存（既存を削除して再作成）
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
    
    const flows = Array.isArray(data.flows) ? data.flows : [];
    
    // 既存のフローを削除
    await executeDB(
      db,
      'DELETE FROM treatment_flows WHERE treatment_id = ?',
      [treatmentId]
    );
    
    // 新しいフローを追加
    for (const flow of flows) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_flows (
            treatment_id, step_number, title, description, duration_minutes, icon
          ) VALUES (?, ?, ?, ?, ?, ?)
        `,
        [
          treatmentId,
          flow.step_number,
          flow.title,
          flow.description || null,
          flow.duration_minutes || null,
          flow.icon || null,
        ]
      );
    }
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error saving treatment flows:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

