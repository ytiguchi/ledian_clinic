import type { APIRoute } from 'astro';
import { getDB } from '../../lib/db';
import { jsonResponse, validationError } from '../../lib/api';
import {
  getTaxRate,
  normalizePricingInput,
  parseNullableNumber,
  type PricingInput,
} from '../../lib/pricing';
import type { PricePlan, PricingResponse } from '../../types/api';

export const prerender = false;

type PricingInputWithSort = PricingInput & { sort_order?: unknown };

const getSearchParam = (url: URL, key: string) => {
  const raw = url.searchParams.get(key);
  if (!raw) return null;
  const trimmed = raw.trim();
  if (!trimmed || trimmed === 'undefined' || trimmed === 'null') return null;
  return trimmed;
};

const getSelectColumns = (hasTreatmentId: boolean) =>
  [
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

const getFromClause = (hasTreatmentId: boolean) =>
  hasTreatmentId
    ? `FROM treatment_plans tp
        JOIN treatments t ON tp.treatment_id = t.id
        JOIN subcategories sc ON t.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id`
    : `FROM treatment_plans tp
        JOIN subcategories sc ON tp.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id`;

const SEARCH_FIELDS_WITH_TREATMENT = [
  't.name',
  'sc.name',
  'tp.plan_name',
  'c.name',
] as const;
const SEARCH_FIELDS_WITHOUT_TREATMENT = [
  'sc.name',
  'tp.plan_name',
  'c.name',
] as const;

const getSearchFields = (hasTreatmentId: boolean) =>
  hasTreatmentId ? SEARCH_FIELDS_WITH_TREATMENT : SEARCH_FIELDS_WITHOUT_TREATMENT;

const getOrderBy = (hasTreatmentId: boolean) =>
  hasTreatmentId
    ? ' ORDER BY c.sort_order, sc.sort_order, t.sort_order, tp.sort_order'
    : ' ORDER BY c.sort_order, sc.sort_order, tp.sort_order';

const buildPricingQuery = (hasTreatmentId: boolean) => {
  const selectColumns = getSelectColumns(hasTreatmentId);
  const fromClause = getFromClause(hasTreatmentId);
  const searchFields = getSearchFields(hasTreatmentId);
  const orderBy = getOrderBy(hasTreatmentId);

  const query = `
        SELECT 
          ${selectColumns}
        ${fromClause}
        WHERE tp.is_active = 1
      `;

  return { query, searchFields, orderBy };
};

const appendCondition = (
  query: string,
  params: unknown[],
  condition: string,
  values: unknown[]
) => {
  params.push(...values);
  return `${query} ${condition}`;
};

const applyCategoryFilter = (
  query: string,
  params: unknown[],
  categoryId: string | null
) => {
  if (!categoryId) return query;
  return appendCondition(query, params, 'AND c.id = ?', [categoryId]);
};

const applySubcategoryFilter = (
  query: string,
  params: unknown[],
  subcategoryId: string | null
) => {
  if (!subcategoryId) return query;
  return appendCondition(query, params, 'AND sc.id = ?', [subcategoryId]);
};

const applySearchFilter = (
  query: string,
  params: unknown[],
  search: string | null,
  searchFields: readonly string[]
) => {
  if (!search) return query;
  const searchPattern = `%${search}%`;
  const searchConditions = searchFields.map(field => `${field} LIKE ?`).join(' OR ');
  return appendCondition(
    query,
    params,
    `AND (${searchConditions})`,
    searchFields.map(() => searchPattern)
  );
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

    query = applyCategoryFilter(query, params, categoryId);
    query = applySubcategoryFilter(query, params, subcategoryId);
    query = applySearchFilter(query, params, search, built.searchFields);

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
    const data: PricingInputWithSort = await request.json();

    const taxRate = getTaxRate(locals?.runtime);
    const normalized = normalizePricingInput(data, taxRate);
    if (normalized.errors.length > 0) {
      return validationError(normalized.errors[0].message, normalized.errors);
    }
    if (!normalized.values) {
      return jsonResponse(400, { error: 'Invalid input' });
    }

    const sortOrder = parseNullableNumber(data.sort_order) ?? 0;
    
    const result = await db.prepare(`
      INSERT INTO treatment_plans (
        id, subcategory_id, plan_name, plan_type, sessions, quantity,
        price, price_taxed, price_per_session, price_per_session_taxed,
        cost_rate, supply_cost, staff_cost, total_cost,
        sort_order, is_active
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
    `).bind(
      crypto.randomUUID(),
      normalized.values.subcategoryId,
      normalized.values.planName,
      normalized.values.planType,
      normalized.values.sessions,
      normalized.values.quantity,
      normalized.values.price,
      normalized.values.priceTaxed,
      normalized.values.pricePerSession,
      normalized.values.pricePerSessionTaxed,
      normalized.values.costRate,
      normalized.values.supplyCost,
      normalized.values.staffCost,
      normalized.values.totalCost,
      sortOrder
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
