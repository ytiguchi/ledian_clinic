import type { APIRoute } from 'astro';
import { getDB, queryFirst, executeDB, queryDB } from '../../../lib/db';

type CampaignInput = {
  title?: unknown;
  slug?: unknown;
  description?: unknown;
  image_url?: unknown;
  start_date?: unknown;
  end_date?: unknown;
  campaign_type?: unknown;
  priority?: unknown;
  is_published?: unknown;
  sort_order?: unknown;
  plans?: unknown;
};

const jsonResponse = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

const normalizeString = (value: unknown) => (typeof value === 'string' ? value.trim() : '');

const parseNumber = (value: unknown, fallback: number) => {
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '' && !Number.isNaN(Number(value))) {
    return Number(value);
  }
  return fallback;
};

const validateCampaignInput = (data: CampaignInput) => {
  const title = normalizeString(data.title);
  const slug = normalizeString(data.slug);
  if (!title) return { ok: false, error: 'Title is required' };
  if (!slug) return { ok: false, error: 'Slug is required' };
  return { ok: true, title, slug };
};

export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return jsonResponse(200, { campaign: null });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return jsonResponse(400, { error: 'ID is required' });
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
      return jsonResponse(404, { error: 'Campaign not found' });
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
    
    return jsonResponse(200, {
      campaign: {
        ...campaign,
        is_published: campaign.is_published === 1,
      },
      plans
    });
  } catch (error) {
    console.error('Error fetching campaign:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};

export const PUT: APIRoute = async ({ locals, params, request }) => {
  try {
    if (!locals?.runtime?.env) {
      return jsonResponse(500, { error: 'Database not available' });
    }
    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data: CampaignInput = await request.json();
    
    if (!id) {
      return jsonResponse(400, { error: 'ID is required' });
    }
    
    const validation = validateCampaignInput(data);
    if (!validation.ok) {
      return jsonResponse(400, { error: validation.error });
    }
    
    const existing = await queryFirst<{ id: string }>(
      db,
      'SELECT id FROM campaigns WHERE slug = ? AND id != ? LIMIT 1',
      [validation.slug, id]
    );
    if (existing) {
      return jsonResponse(409, { error: 'Slug already exists' });
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
        validation.title,
        validation.slug,
        normalizeString(data.description) || null,
        normalizeString(data.image_url) || null,
        normalizeString(data.start_date) || null,
        normalizeString(data.end_date) || null,
        normalizeString(data.campaign_type) || 'discount',
        parseNumber(data.priority, 0),
        Boolean(data.is_published) ? 1 : 0,
        parseNumber(data.sort_order, 0),
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
    
    return jsonResponse(200, { success: true, id });
  } catch (error) {
    console.error('Error updating campaign:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};

export const DELETE: APIRoute = async ({ locals, params }) => {
  try {
    if (!locals?.runtime?.env) {
      return jsonResponse(500, { error: 'Database not available' });
    }
    const db = getDB(locals.runtime.env);
    const id = params.id;
    
    if (!id) {
      return jsonResponse(400, { error: 'ID is required' });
    }
    
    // campaign_plans は CASCADE で削除される想定
    const result = await executeDB(
      db,
      'DELETE FROM campaigns WHERE id = ?',
      [id]
    );
    
    return jsonResponse(200, { success: true });
  } catch (error) {
    console.error('Error deleting campaign:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};
export const prerender = false;
