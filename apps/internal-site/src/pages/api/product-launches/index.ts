import type { APIRoute } from 'astro';
import { getDb } from '../../../lib/db';

// 発売予定商品一覧取得
export const GET: APIRoute = async ({ request, locals }) => {
  try {
    const db = getDb(locals);
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

    return new Response(JSON.stringify({
      launches: result.results || []
    }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error fetching product launches:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to fetch product launches',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// 新規発売予定商品作成
export const POST: APIRoute = async ({ request, locals }) => {
  try {
    const db = getDb(locals);
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
      return new Response(JSON.stringify({ error: '商品名は必須です' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

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
      planned_price || null,
      planned_price_taxed || null,
      price_notes || null,
      target_launch_date || null,
      owner_name || null,
      priority,
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

    return new Response(JSON.stringify({ 
      success: true, 
      id: launchId 
    }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error creating product launch:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to create product launch',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

