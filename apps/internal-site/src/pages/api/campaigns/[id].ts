import type { APIRoute } from 'astro';
import { getDB, queryFirst, executeDB, queryDB } from '../../../lib/db';

export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ campaign: null }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    // キャンペーン基本情報取得
    const campaign = await queryFirst<{
      id: string;
      title: string;
      slug: string;
      description: string | null;
      image_url: string | null;
      start_date: string | null;
      end_date: string | null;
      campaign_type: string;
      priority: number;
      is_published: number;
      sort_order: number;
      created_at: string;
      updated_at: string;
    }>(
      db,
      'SELECT * FROM campaigns WHERE id = ?',
      [id]
    );
    
    if (!campaign) {
      return new Response(JSON.stringify({ error: 'Campaign not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    // 関連プラン取得
    const plans = await queryDB<{
      id: string;
      campaign_id: string;
      treatment_plan_id: string;
      discount_type: string;
      discount_value: number | null;
      special_price: number | null;
      special_price_taxed: number | null;
      sort_order: number;
    }>(
      db,
      'SELECT * FROM campaign_plans WHERE campaign_id = ? ORDER BY sort_order',
      [id]
    );
    
    return new Response(JSON.stringify({
      campaign: {
        ...campaign,
        is_published: campaign.is_published === 1,
      },
      plans
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching campaign:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

export const PUT: APIRoute = async ({ locals, params, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data = await request.json();
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const result = await executeDB(
      db,
      `
        UPDATE campaigns SET
          title = ?,
          slug = ?,
          description = ?,
          image_url = ?,
          start_date = ?,
          end_date = ?,
          campaign_type = ?,
          priority = ?,
          is_published = ?,
          sort_order = ?,
          updated_at = datetime('now')
        WHERE id = ?
      `,
      [
        data.title,
        data.slug,
        data.description || null,
        data.image_url || null,
        data.start_date || null,
        data.end_date || null,
        data.campaign_type || 'discount',
        data.priority || 0,
        data.is_published ? 1 : 0,
        data.sort_order || 0,
        id
      ]
    );
    
    // 関連プランの更新（必要に応じて）
    if (data.plans && Array.isArray(data.plans)) {
      // 既存のプランを削除
      await executeDB(
        db,
        'DELETE FROM campaign_plans WHERE campaign_id = ?',
        [id]
      );
      
      // 新しいプランを追加
      for (const plan of data.plans) {
        await executeDB(
          db,
          `
            INSERT INTO campaign_plans (
              campaign_id, treatment_plan_id, discount_type,
              discount_value, special_price, special_price_taxed, sort_order
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
          `,
          [
            id,
            plan.treatment_plan_id,
            plan.discount_type || 'percentage',
            plan.discount_value || null,
            plan.special_price || null,
            plan.special_price_taxed || null,
            plan.sort_order || 0
          ]
        );
      }
    }
    
    return new Response(JSON.stringify({ success: true, id }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error updating campaign:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

export const DELETE: APIRoute = async ({ locals, params }) => {
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return new Response(JSON.stringify({ error: 'ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    // campaign_plans は CASCADE で削除される想定
    const result = await executeDB(
      db,
      'DELETE FROM campaigns WHERE id = ?',
      [id]
    );
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error deleting campaign:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
export const prerender = false;


