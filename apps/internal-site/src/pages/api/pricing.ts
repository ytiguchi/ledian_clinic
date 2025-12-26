import type { APIRoute } from 'astro';
import { getDB } from '../../lib/db';
import { getTaxRate, toTaxedPrice } from '../../lib/pricing';
import type { PricePlan, PricingResponse } from '../../types/api';

export const prerender = false;

type PricingInput = {
  subcategory_id?: unknown;
  plan_name?: unknown;
  plan_type?: unknown;
  sessions?: unknown;
  quantity?: unknown;
  price?: unknown;
  price_taxed?: unknown;
  price_per_session?: unknown;
  price_per_session_taxed?: unknown;
  cost_rate?: unknown;
  supply_cost?: unknown;
  staff_cost?: unknown;
  total_cost?: unknown;
  sort_order?: unknown;
};

const jsonResponse = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

const normalizeString = (value: unknown) => (typeof value === 'string' ? value.trim() : '');

const parseNullableNumber = (value: unknown) => {
  if (value === null || value === undefined || value === '') return null;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '' && !Number.isNaN(Number(value))) {
    return Number(value);
  }
  return null;
};

const getSearchParam = (url: URL, key: string) => {
  const raw = url.searchParams.get(key);
  if (!raw) return null;
  const trimmed = raw.trim();
  if (!trimmed || trimmed === 'undefined' || trimmed === 'null') return null;
  return trimmed;
};

const buildPricingQuery = (hasTreatmentId: boolean) => {
  const selectColumns = [
    'tp.id',
    'tp.plan_name',
    'tp.plan_type',
    'tp.sessions',
    'tp.quantity',
    'tp.price',
    'tp.price_taxed',
    'tp.price_per_session',
    'tp.price_per_session_taxed',
    'tp.cost_rate',
    'tp.supply_cost',
    'tp.staff_cost',
    'tp.total_cost',
    'tp.notes',
    hasTreatmentId ? 't.id AS treatment_id' : 'sc.id AS treatment_id',
    hasTreatmentId ? 't.name AS treatment_name' : 'sc.name AS treatment_name',
    hasTreatmentId ? 't.slug AS treatment_slug' : 'sc.slug AS treatment_slug',
    hasTreatmentId ? 't.description AS treatment_description' : 'NULL AS treatment_description',
    'sc.id AS subcategory_id',
    'sc.name AS subcategory_name',
    'c.id AS category_id',
    'c.name AS category_name',
  ].join(',\n          ');

  const fromClause = hasTreatmentId
    ? `FROM treatment_plans tp
        JOIN treatments t ON tp.treatment_id = t.id
        JOIN subcategories sc ON t.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id`
    : `FROM treatment_plans tp
        JOIN subcategories sc ON tp.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id`;

  const searchFields = hasTreatmentId
    ? ['t.name', 'sc.name', 'tp.plan_name', 'c.name']
    : ['sc.name', 'tp.plan_name', 'c.name'];

  const orderBy = hasTreatmentId
    ? ' ORDER BY c.sort_order, sc.sort_order, t.sort_order, tp.sort_order'
    : ' ORDER BY c.sort_order, sc.sort_order, tp.sort_order';

  const query = `
        SELECT 
          ${selectColumns}
        ${fromClause}
        WHERE tp.is_active = 1
      `;

  return { query, searchFields, orderBy };
};

const hasTreatmentIdColumn = async (db: ReturnType<typeof getDB>) => {
  try {
    const checkResult = await db.prepare(`
      PRAGMA table_info(treatment_plans)
    `).all<{ name: string }>();
    if (checkResult.success && checkResult.results) {
      return checkResult.results.some(col => col.name === 'treatment_id');
    }
  } catch (error) {
    console.warn('Could not check table structure, assuming 3-tier structure:', error);
  }
  return false;
};

export const GET: APIRoute = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    // 開発環境（npm run dev）では空配列を返す
    console.warn('D1 database is not available in development mode. Use "wrangler pages dev" for API testing.');
    return jsonResponse(200, { plans: [] });
  }
  let query = '';
  let params: unknown[] = [];
  try {
    const db = getDB(locals.runtime.env);
    
    const categoryId = getSearchParam(url, 'category_id');
    const subcategoryId = getSearchParam(url, 'subcategory_id');
    const search = getSearchParam(url, 'search');
    const hasTreatmentId = await hasTreatmentIdColumn(db);
    const built = buildPricingQuery(hasTreatmentId);

    query = built.query;
    params = [];

    if (categoryId) {
      query += ' AND c.id = ?';
      params.push(categoryId);
    }

    if (subcategoryId) {
      query += ' AND sc.id = ?';
      params.push(subcategoryId);
    }

    if (search) {
      query += ` AND (${built.searchFields.map(field => `${field} LIKE ?`).join(' OR ')})`;
      const searchPattern = `%${search}%`;
      params.push(...built.searchFields.map(() => searchPattern));
    }

    query += built.orderBy;
    
    let stmt = db.prepare(query);
    if (params.length > 0) {
      stmt = stmt.bind(...params);
    }
    const result = await stmt.all<PricePlan>();
    
    if (!result.success) {
      throw new Error(result.error || 'Database query failed');
    }
    
    const plans = result.results || [];
    
    // プラン名を追加（編集フォーム用）
    const plansWithName = plans.map(p => ({
      ...p,
      name: p.plan_name
    }));
    
    const response: PricingResponse = { plans: plansWithName };
    return jsonResponse(200, response);
  } catch (error) {
    console.error('Error fetching pricing:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    const errorStack = error instanceof Error ? error.stack : undefined;
    console.error('Error details:', { errorMessage, errorStack, query, params });
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
    const data: PricingInput = await request.json();

    const subcategoryId = normalizeString(data.subcategory_id);
    const planName = normalizeString(data.plan_name);
    const price = parseNullableNumber(data.price);

    if (!subcategoryId) {
      return jsonResponse(400, { error: 'subcategory_id is required' });
    }
    if (!planName) {
      return jsonResponse(400, { error: 'plan_name is required' });
    }
    if (price === null) {
      return jsonResponse(400, { error: 'price is required' });
    }

    const taxRate = getTaxRate(locals?.runtime);
    const priceTaxed = toTaxedPrice(price, taxRate);
    const pricePerSession = parseNullableNumber(data.price_per_session);
    const pricePerSessionTaxed =
      pricePerSession === null ? null : toTaxedPrice(pricePerSession, taxRate);
    
    const result = await db.prepare(`
      INSERT INTO treatment_plans (
        id, subcategory_id, plan_name, plan_type, sessions, quantity,
        price, price_taxed, price_per_session, price_per_session_taxed,
        cost_rate, supply_cost, staff_cost, total_cost,
        sort_order, is_active
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
    `).bind(
      crypto.randomUUID(),
      subcategoryId,
      planName,
      normalizeString(data.plan_type) || 'single',
      parseNullableNumber(data.sessions),
      normalizeString(data.quantity) || null,
      price,
      priceTaxed,
      pricePerSession,
      pricePerSessionTaxed,
      parseNullableNumber(data.cost_rate),
      parseNullableNumber(data.supply_cost),
      parseNullableNumber(data.staff_cost),
      parseNullableNumber(data.total_cost),
      parseNullableNumber(data.sort_order) ?? 0
    ).run();
    
    if (!result.success) {
      throw new Error(result.error || 'Failed to create plan');
    }
    
    return jsonResponse(201, {
      id: result.meta.last_row_id,
      success: true
    });
  } catch (error) {
    console.error('Error creating plan:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};
