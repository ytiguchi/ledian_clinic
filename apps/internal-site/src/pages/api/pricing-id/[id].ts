import type { APIRoute } from 'astro';
import { getDB, queryFirst, executeDB } from '../../../lib/db';
import { getTaxRate, toTaxedPrice } from '../../../lib/pricing';

const JSON_HEADERS = { 'Content-Type': 'application/json' };

const jsonResponse = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: JSON_HEADERS });

const requireId = (id: string | undefined) => {
  if (!id) {
    return jsonResponse({ error: 'ID is required' }, 400);
  }
  return null;
};

const requireRuntimeEnv = (
  runtime: App.Locals['runtime'] | undefined,
  fallback: { body: unknown; status: number } = {
    body: { error: 'Runtime env not available' },
    status: 500,
  }
) => {
  if (!runtime?.env) {
    return jsonResponse(fallback.body, fallback.status);
  }
  return null;
};

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
  notes?: unknown;
};

const normalizeString = (value: unknown) =>
  typeof value === 'string' ? value.trim() : '';

const parseNullableNumber = (value: unknown) => {
  if (value === null || value === undefined || value === '') return null;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '' && !Number.isNaN(Number(value))) {
    return Number(value);
  }
  return null;
};

export const GET: APIRoute = async ({ locals, params }) => {
  const envResponse = requireRuntimeEnv(locals?.runtime, {
    body: { plan: null },
    status: 200,
  });
  if (envResponse) return envResponse;
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;

    const idResponse = requireId(id);
    if (idResponse) return idResponse;

    const plan = await queryFirst<{
      id: string;
      plan_name: string;
      plan_type: string;
      sessions: number | null;
      quantity: string | null;
      price: number;
      price_taxed: number;
      price_per_session: number | null;
      price_per_session_taxed: number | null;
      campaign_price: number | null;
      campaign_price_taxed: number | null;
      cost_rate: number | null;
      supply_cost: number | null;
      staff_cost: number | null;
      total_cost: number | null;
      subcategory_id: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
    }>(
      db,
      `
        SELECT 
          tp.*,
          sc.id AS subcategory_id,
          sc.name AS subcategory_name,
          c.id AS category_id,
          c.name AS category_name
        FROM treatment_plans tp
        JOIN subcategories sc ON tp.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE tp.id = ?
      `,
      [id]
    );

    if (!plan) {
      return jsonResponse({ error: 'Plan not found' }, 404);
    }

    return jsonResponse({ plan });
  } catch (error) {
    console.error('Error fetching plan:', error);
    return jsonResponse(
      {
        error: 'Internal Server Error',
        message: error instanceof Error ? error.message : 'Unknown error',
      },
      500
    );
  }
};

export const PUT: APIRoute = async ({ locals, params, request }) => {
  try {
    const envResponse = requireRuntimeEnv(locals?.runtime);
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data: PricingInput = await request.json();

    const idResponse = requireId(id);
    if (idResponse) return idResponse;

    const taxRate = getTaxRate(locals?.runtime);
    const subcategoryId = normalizeString(data.subcategory_id);
    const planName = normalizeString(data.plan_name);
    const price = parseNullableNumber(data.price);

    if (!subcategoryId) {
      return jsonResponse({ error: 'subcategory_id is required' }, 400);
    }
    if (!planName) {
      return jsonResponse({ error: 'plan_name is required' }, 400);
    }
    if (price === null) {
      return jsonResponse({ error: 'price is required' }, 400);
    }

    const planType = normalizeString(data.plan_type) || 'single';
    const priceTaxed = toTaxedPrice(price, taxRate);
    const sessions = parseNullableNumber(data.sessions);
    const quantity = normalizeString(data.quantity) || null;
    const pricePerSession = parseNullableNumber(data.price_per_session);
    const pricePerSessionTaxed =
      pricePerSession === null ? null : toTaxedPrice(pricePerSession, taxRate);
    const costRate = parseNullableNumber(data.cost_rate);
    const supplyCost = parseNullableNumber(data.supply_cost);
    const staffCost = parseNullableNumber(data.staff_cost);
    const totalCost = parseNullableNumber(data.total_cost);
    const notes = normalizeString(data.notes) || null;

    await executeDB(
      db,
      `
        UPDATE treatment_plans SET
          subcategory_id = ?,
          plan_name = ?,
          plan_type = ?,
          sessions = ?,
          quantity = ?,
          price = ?,
          price_taxed = ?,
          price_per_session = ?,
          price_per_session_taxed = ?,
          cost_rate = ?,
          supply_cost = ?,
          staff_cost = ?,
          total_cost = ?,
          notes = ?,
          updated_at = datetime('now')
        WHERE id = ?
      `,
      [
        subcategoryId,
        planName,
        planType,
        sessions,
        quantity,
        price,
        priceTaxed,
        pricePerSession,
        pricePerSessionTaxed,
        costRate,
        supplyCost,
        staffCost,
        totalCost,
        notes,
        id
      ]
    );

    return jsonResponse({ success: true, id });
  } catch (error) {
    console.error('Error updating plan:', error);
    return jsonResponse(
      {
        error: 'Internal Server Error',
        message: error instanceof Error ? error.message : 'Unknown error',
      },
      500
    );
  }
};

export const DELETE: APIRoute = async ({ locals, params }) => {
  try {
    const envResponse = requireRuntimeEnv(locals?.runtime);
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;

    const idResponse = requireId(id);
    if (idResponse) return idResponse;

    // ソフトデリート（is_active = 0）にする
    await executeDB(
      db,
      'UPDATE treatment_plans SET is_active = 0, updated_at = datetime(\'now\') WHERE id = ?',
      [id]
    );

    return jsonResponse({ success: true });
  } catch (error) {
    console.error('Error deleting plan:', error);
    return jsonResponse(
      {
        error: 'Internal Server Error',
        message: error instanceof Error ? error.message : 'Unknown error',
      },
      500
    );
  }
};
export const prerender = false;
