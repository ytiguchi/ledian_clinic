import type { APIRoute } from 'astro';
import { getDB } from '../../../../lib/db';
import {
  jsonResponse,
  requireParam,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
  type ValidationFieldError,
} from '../../../../lib/api';

// タスク一覧取得
export const GET: APIRoute = async ({ params, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { tasks: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;

    const idResponse = requireParam(id, '発売予定商品ID');
    if (idResponse) return idResponse;

    const tasks = await db.prepare(`
      SELECT * FROM launch_tasks WHERE launch_id = ? ORDER BY sort_order ASC
    `).bind(id).all();

    return jsonResponse(200, { tasks: tasks.results || [] });
  });
};

// タスク追加
export const POST: APIRoute = async ({ params, request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const { id } = params;
    const body = await request.json();

    const idResponse = requireParam(id, '発売予定商品ID');
    if (idResponse) return idResponse;

    const { task_type, title, description, due_date, assignee } = body;

    if (!task_type || !title) {
      const fields: ValidationFieldError[] = [];
      if (!task_type) {
        fields.push({ field: 'task_type', message: 'タスク種別は必須です' });
      }
      if (!title) {
        fields.push({ field: 'title', message: 'タイトルは必須です' });
      }
      return validationError('タスク種別とタイトルは必須です', fields);
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

    return jsonResponse(201, { 
      success: true,
      id: result.meta.last_row_id
    });
  });
};

// タスク更新（完了/未完了切り替え等）
export const PUT: APIRoute = async ({ request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const body = await request.json();

    const { task_id, is_completed, completed_by, title, description, due_date, assignee } = body;

    if (!task_id) {
      return validationError('タスクIDは必須です', [
        { field: 'task_id', message: 'タスクIDは必須です' },
      ]);
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

    return jsonResponse(200, { success: true });
  });
};

// タスク削除
export const DELETE: APIRoute = async ({ request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const url = new URL(request.url);
    const taskId = url.searchParams.get('task_id');

    if (!taskId) {
      return validationError('タスクIDは必須です', [
        { field: 'task_id', message: 'タスクIDは必須です' },
      ]);
    }

    await db.prepare('DELETE FROM launch_tasks WHERE id = ?').bind(taskId).run();

    return jsonResponse(200, { success: true });
  });
};
