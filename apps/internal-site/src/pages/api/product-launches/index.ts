import type { APIRoute } from 'astro';
import { getDB } from '../../../lib/db';
import {
  jsonResponse,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
  type ValidationFieldError,
} from '../../../lib/api';

const parseNullableNumber = (value: unknown) => {
  if (value === null || value === undefined || value === '') return null;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '' && !Number.isNaN(Number(value))) {
    return Number(value);
  }
  return null;
};

// 発売予定商品一覧取得
export const GET: APIRoute = async ({ request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { launches: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const url = new URL(request.url);
    const status = url.searchParams.get('status');

    let query = `
      SELECT 
        pl.*,
        c.name as category_name,
        (SELECT COUNT(*) FROM launch_tasks lt WHERE lt.launch_id = pl.id) as total_tasks,
        (SELECT COUNT(*) FROM launch_tasks lt WHERE lt.launch_id = pl.id AND lt.is_completed = 1) as completed_tasks
      FROM product_launches pl
      LEFT JOIN categories c ON pl.target_category_id = c.id
    `;
    
    const params: string[] = [];
    if (status) {
      query += ' WHERE pl.status = ?';
      params.push(status);
    }
    
    query += ' ORDER BY pl.priority DESC, pl.target_launch_date ASC';

    const result = await db.prepare(query).bind(...params).all();

    return jsonResponse(200, {
      launches: result.results || [],
    });
  });
};

// 新規発売予定商品作成
export const POST: APIRoute = async ({ request, locals }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Database not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const body = await request.json();

    const {
      name,
      description,
      target_category_id,
      target_subcategory_name,
      planned_price,
      planned_price_taxed,
      price_notes,
      target_launch_date,
      owner_name,
      priority = 0,
      notes
    } = body;

    if (!name) {
      const fields: ValidationFieldError[] = [
        { field: 'name', message: '商品名は必須です' },
      ];
      return validationError('商品名は必須です', fields);
    }

    const plannedPrice = parseNullableNumber(planned_price);
    const plannedPriceTaxed = parseNullableNumber(planned_price_taxed);
    const parsedPriority = parseNullableNumber(priority) ?? 0;

    const result = await db.prepare(`
      INSERT INTO product_launches (
        name, description, target_category_id, target_subcategory_name,
        planned_price, planned_price_taxed, price_notes,
        target_launch_date, owner_name, priority, notes, status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'planning')
    `).bind(
      name,
      description || null,
      target_category_id || null,
      target_subcategory_name || null,
      plannedPrice,
      plannedPriceTaxed,
      price_notes || null,
      target_launch_date || null,
      owner_name || null,
      parsedPriority,
      notes || null
    ).run();

    const launchId = result.meta.last_row_id;

    // デフォルトタスクを作成
    const defaultTasks = [
      { task_type: 'pricing', title: '料金設定・原価計算', sort_order: 1 },
      { task_type: 'protocol', title: 'プロトコル策定', sort_order: 2 },
      { task_type: 'training_material', title: '研修資料作成', sort_order: 3 },
      { task_type: 'training_session', title: '研修実施', sort_order: 4 },
      { task_type: 'web_register', title: 'WEBサイト登録', sort_order: 5 },
      { task_type: 'smaregi_register', title: 'スマレジ商品登録', sort_order: 6 },
      { task_type: 'medical_force_register', title: 'メディカルフォース登録', sort_order: 7 },
    ];

    for (const task of defaultTasks) {
      await db.prepare(`
        INSERT INTO launch_tasks (launch_id, task_type, title, sort_order)
        VALUES (?, ?, ?, ?)
      `).bind(launchId, task.task_type, task.title, task.sort_order).run();
    }

    return jsonResponse(201, { 
      success: true, 
      id: launchId, 
    });
  });
};
