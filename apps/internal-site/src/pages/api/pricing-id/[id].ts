import type { APIRoute } from 'astro';
import { getDB, queryFirst, executeDB } from '../../../lib/db';
import {
  jsonResponse,
  requireParam,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
} from '../../../lib/api';
import { getTaxRate, normalizePricingInput, type PricingInput } from '../../../lib/pricing';

export const GET: APIRoute = async ({ locals, params }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { plan: null },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;

    const idResponse = requireParam(id, 'Plan ID');
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
      notes: string | null;
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
        JOIN treatments t ON tp.treatment_id = t.id
        JOIN subcategories sc ON t.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE tp.id = ?
      `,
      [id]
    );

    if (!plan) {
      return jsonResponse(404, { error: 'Plan not found' });
    }

    return jsonResponse(200, { plan });
  });
};

export const PUT: APIRoute = async ({ locals, params, request }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime);
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data: PricingInput = await request.json();

    const idResponse = requireParam(id, 'Plan ID');
    if (idResponse) return idResponse;

    const taxRate = getTaxRate(locals?.runtime);
    const normalized = normalizePricingInput(data, taxRate);
    if (normalized.errors.length > 0) {
      return validationError(normalized.errors[0].message, normalized.errors);
    }
    if (!normalized.values) {
      return jsonResponse(400, { error: 'Invalid input' });
    }

    await executeDB(
      db,
      `
        UPDATE treatment_plans SET
          treatment_id = ?,
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
        normalized.values.treatmentId,
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
        normalized.values.notes,
        id
      ]
    );

    return jsonResponse(200, { success: true, id });
  });
};

export const DELETE: APIRoute = async ({ locals, params }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime);
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const id = params.id;

    const idResponse = requireParam(id, 'Plan ID');
    if (idResponse) return idResponse;

    // ソフトデリート（is_active = 0）にする
    await executeDB(
      db,
      'UPDATE treatment_plans SET is_active = 0, updated_at = datetime(\'now\') WHERE id = ?',
      [id]
    );

    return jsonResponse(200, { success: true });
  });
};
export const prerender = false;
