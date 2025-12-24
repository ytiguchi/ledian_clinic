import type { APIRoute } from 'astro';
import { getDB, queryDB, executeDB, queryFirst } from '../../../lib/db';

type CampaignInput = {
  title?: unknown;
  slug?: unknown;
  description?: unknown;
  start_date?: unknown;
  end_date?: unknown;
  discount_type?: unknown;
  discount_value?: unknown;
  is_published?: unknown;
  is_featured?: unknown;
};

const jsonResponse = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

const normalizeString = (value: unknown) => (typeof value === 'string' ? value.trim() : '');

const parseDiscountValue = (value: unknown) => {
  if (value === null || value === undefined || value === '') return null;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '' && !Number.isNaN(Number(value))) {
    return Number(value);
  }
  return null;
};

const validateCampaignInput = (data: CampaignInput) => {
  const title = normalizeString(data.title);
  const slug = normalizeString(data.slug);
  if (!title) return { ok: false, error: 'Title is required' };
  if (!slug) return { ok: false, error: 'Slug is required' };
  return { ok: true, title, slug };
};

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return jsonResponse(200, { campaigns: [] });
  }
  try {
    const db = getDB(locals.runtime.env);
    
    const isPublished = url.searchParams.get('is_published');
    
    let query = `
      SELECT 
        c.id,
        c.title,
        c.slug,
        c.description,
        c.start_date,
        c.end_date,
        c.is_published,
        c.is_featured,
        c.discount_type,
        c.discount_value,
        c.created_at,
        c.updated_at,
        COUNT(ci.id) AS item_count
      FROM campaigns c
      LEFT JOIN campaign_items ci ON c.id = ci.campaign_id
      WHERE 1=1
    `;
    
    const params: unknown[] = [];
    
    if (isPublished !== null) {
      query += ' AND c.is_published = ?';
      params.push(isPublished === '1' ? 1 : 0);
    }
    
    query += ' GROUP BY c.id ORDER BY c.start_date DESC, c.created_at DESC';
    
    const campaigns = await queryDB<{
      id: string;
      title: string;
      slug: string;
      description: string | null;
      start_date: string | null;
      end_date: string | null;
      is_published: number;
      is_featured: number;
      discount_type: string | null;
      discount_value: number | null;
      created_at: string;
      updated_at: string;
      item_count: number;
    }>(db, query, params);
    
    return jsonResponse(200, { 
      campaigns: campaigns.map(c => ({
        ...c,
        is_published: c.is_published === 1,
        is_featured: c.is_featured === 1,
      }))
    });
  } catch (error) {
    console.error('Error fetching campaigns:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    const errorStack = error instanceof Error ? error.stack : undefined;
    console.error('Error details:', { errorMessage, errorStack });
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: errorMessage,
      stack: errorStack
    });
  }
};

export const POST: APIRoute = async ({ locals, request }) => {
  try {
    if (!locals?.runtime?.env) {
      return jsonResponse(500, { error: 'Database not available' });
    }
    const db = getDB(locals.runtime.env);
    const data: CampaignInput = await request.json();
    const validation = validateCampaignInput(data);
    if (!validation.ok) {
      return jsonResponse(400, { error: validation.error });
    }
    
    const existing = await queryFirst<{ id: string }>(
      db,
      'SELECT id FROM campaigns WHERE slug = ? LIMIT 1',
      [validation.slug]
    );
    if (existing) {
      return jsonResponse(409, { error: 'Slug already exists' });
    }

    const discountValue = parseDiscountValue(data.discount_value);
    const campaignId = crypto.randomUUID();
    
    const result = await executeDB(
      db,
      `
        INSERT INTO campaigns (
          id, title, slug, description,
          start_date, end_date, discount_type, discount_value,
          is_published, is_featured
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        campaignId,
        validation.title,
        validation.slug,
        normalizeString(data.description) || null,
        normalizeString(data.start_date) || null,
        normalizeString(data.end_date) || null,
        normalizeString(data.discount_type) || 'fixed',
        discountValue,
        Boolean(data.is_published) ? 1 : 0,
        Boolean(data.is_featured) ? 1 : 0
      ]
    );
    
    return jsonResponse(201, {
      id: campaignId,
      success: true
    });
  } catch (error) {
    console.error('Error creating campaign:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};
