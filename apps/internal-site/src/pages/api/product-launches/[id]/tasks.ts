import type { APIRoute } from 'astro';
import { getDb } from '../../../../lib/db';

// タスク一覧取得
export const GET: APIRoute = async ({ params, locals }) => {
  try {
    const db = getDb(locals);
    const { id } = params;

    const tasks = await db.prepare(`
      SELECT * FROM launch_tasks WHERE launch_id = ? ORDER BY sort_order ASC
    `).bind(id).all();

    return new Response(JSON.stringify({
      tasks: tasks.results || []
    }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error fetching tasks:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to fetch tasks',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// タスク追加
export const POST: APIRoute = async ({ params, request, locals }) => {
  try {
    const db = getDb(locals);
    const { id } = params;
    const body = await request.json();

    const { task_type, title, description, due_date, assignee } = body;

    if (!task_type || !title) {
      return new Response(JSON.stringify({ error: 'タスク種別とタイトルは必須です' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    const maxSortOrder = await db.prepare(`
      SELECT COALESCE(MAX(sort_order), 0) + 1 as next_order 
      FROM launch_tasks WHERE launch_id = ?
    `).bind(id).first() as any;

    const result = await db.prepare(`
      INSERT INTO launch_tasks (launch_id, task_type, title, description, due_date, assignee, sort_order)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `).bind(
      id,
      task_type,
      title,
      description || null,
      due_date || null,
      assignee || null,
      maxSortOrder?.next_order || 1
    ).run();

    return new Response(JSON.stringify({ 
      success: true,
      id: result.meta.last_row_id
    }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error creating task:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to create task',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// タスク更新（完了/未完了切り替え等）
export const PUT: APIRoute = async ({ request, locals }) => {
  try {
    const db = getDb(locals);
    const body = await request.json();

    const { task_id, is_completed, completed_by, title, description, due_date, assignee } = body;

    if (!task_id) {
      return new Response(JSON.stringify({ error: 'タスクIDは必須です' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    if (is_completed !== undefined) {
      // 完了状態の更新
      await db.prepare(`
        UPDATE launch_tasks SET
          is_completed = ?,
          completed_at = ?,
          completed_by = ?,
          updated_at = datetime('now')
        WHERE id = ?
      `).bind(
        is_completed ? 1 : 0,
        is_completed ? new Date().toISOString() : null,
        is_completed ? (completed_by || null) : null,
        task_id
      ).run();
    } else {
      // タスク情報の更新
      await db.prepare(`
        UPDATE launch_tasks SET
          title = COALESCE(?, title),
          description = ?,
          due_date = ?,
          assignee = ?,
          updated_at = datetime('now')
        WHERE id = ?
      `).bind(
        title || null,
        description || null,
        due_date || null,
        assignee || null,
        task_id
      ).run();
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error updating task:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to update task',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// タスク削除
export const DELETE: APIRoute = async ({ request, locals }) => {
  try {
    const db = getDb(locals);
    const url = new URL(request.url);
    const taskId = url.searchParams.get('task_id');

    if (!taskId) {
      return new Response(JSON.stringify({ error: 'タスクIDは必須です' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    await db.prepare('DELETE FROM launch_tasks WHERE id = ?').bind(taskId).run();

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error deleting task:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to delete task',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

