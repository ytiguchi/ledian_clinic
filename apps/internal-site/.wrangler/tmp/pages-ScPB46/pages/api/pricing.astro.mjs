globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    console.warn('D1 database is not available in development mode. Use "wrangler pages dev" for API testing.');
    return new Response(JSON.stringify({ plans: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const categoryId = url.searchParams.get("category_id");
    const search = url.searchParams.get("search");
    let query = `
      SELECT 
        tp.id,
        tp.plan_name,
        tp.plan_type,
        tp.sessions,
        tp.price,
        tp.price_taxed,
        tp.campaign_price,
        tp.campaign_price_taxed,
        tp.cost_rate,
        tp.supply_cost,
        tp.staff_cost,
        tp.total_cost,
        t.id AS treatment_id,
        t.name AS treatment_name,
        sc.id AS subcategory_id,
        sc.name AS subcategory_name,
        c.id AS category_id,
        c.name AS category_name
      FROM treatment_plans tp
      JOIN treatments t ON tp.treatment_id = t.id
      JOIN subcategories sc ON t.subcategory_id = sc.id
      JOIN categories c ON sc.category_id = c.id
      WHERE tp.is_active = 1
    `;
    const params = [];
    if (categoryId) {
      query += " AND c.id = ?";
      params.push(categoryId);
    }
    if (search) {
      query += " AND (t.name LIKE ? OR tp.plan_name LIKE ?)";
      params.push(`%${search}%`, `%${search}%`);
    }
    query += " ORDER BY c.sort_order, sc.sort_order, t.sort_order, tp.sort_order";
    const plans = await queryDB(db, query, params);
    const plansWithName = plans.map((p) => ({
      ...p,
      name: p.plan_name
    }));
    return new Response(JSON.stringify({ plans: plansWithName }), {
      status: 200,
      headers: {
        "Content-Type": "application/json"
      }
    });
  } catch (error) {
    console.error("Error fetching pricing:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
};
const POST = async ({ locals, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const data = await request.json();
    const result = await db.prepare(`
      INSERT INTO treatment_plans (
        treatment_id, plan_name, plan_type, sessions, quantity,
        price, price_taxed, price_per_session, price_per_session_taxed,
        cost_rate, supply_cost, staff_cost, total_cost,
        sort_order, is_active
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
    `).bind(
      data.treatment_id,
      data.plan_name,
      data.plan_type || "single",
      data.sessions || null,
      data.quantity || null,
      data.price,
      data.price_taxed || Math.round(data.price * 1.1),
      data.price_per_session || null,
      data.price_per_session_taxed || null,
      data.cost_rate || null,
      data.supply_cost || null,
      data.staff_cost || null,
      data.total_cost || null,
      data.sort_order || 0
    ).run();
    if (!result.success) {
      throw new Error(result.error || "Failed to create plan");
    }
    return new Response(JSON.stringify({
      id: result.meta.last_row_id,
      success: true
    }), {
      status: 201,
      headers: {
        "Content-Type": "application/json"
      }
    });
  } catch (error) {
    console.error("Error creating plan:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
};

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  GET,
  POST,
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
