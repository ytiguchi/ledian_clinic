globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB } from '../../chunks/db_CsOQ555j.mjs';
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
  let query = "";
  let params = [];
  try {
    const db = getDB(locals.runtime.env);
    const categoryId = url.searchParams.get("category_id")?.trim();
    const subcategoryId = url.searchParams.get("subcategory_id")?.trim();
    const search = url.searchParams.get("search")?.trim();
    const checkColumn = await db.prepare(`
      SELECT COUNT(*) as count 
      FROM pragma_table_info('treatment_plans') 
      WHERE name = 'treatment_id'
    `).first();
    const hasTreatmentId = checkColumn && checkColumn.count > 0;
    if (hasTreatmentId) {
      query = `
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
          t.slug AS treatment_slug,
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
    } else {
      query = `
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
          sc.id AS treatment_id,
          sc.name AS treatment_name,
          sc.slug AS treatment_slug,
          sc.id AS subcategory_id,
          sc.name AS subcategory_name,
          c.id AS category_id,
          c.name AS category_name
        FROM treatment_plans tp
        JOIN subcategories sc ON tp.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE tp.is_active = 1
      `;
    }
    params = [];
    if (categoryId && categoryId !== "" && categoryId !== "undefined" && categoryId !== "null") {
      query += " AND c.id = ?";
      params.push(categoryId);
    }
    if (subcategoryId && subcategoryId !== "" && subcategoryId !== "undefined" && subcategoryId !== "null") {
      query += " AND sc.id = ?";
      params.push(subcategoryId);
    }
    if (search && search !== "" && search !== "undefined" && search !== "null") {
      if (hasTreatmentId) {
        query += " AND (t.name LIKE ? OR sc.name LIKE ? OR tp.plan_name LIKE ? OR c.name LIKE ?)";
      } else {
        query += " AND (sc.name LIKE ? OR tp.plan_name LIKE ? OR c.name LIKE ?)";
      }
      const searchPattern = `%${search}%`;
      if (hasTreatmentId) {
        params.push(searchPattern, searchPattern, searchPattern, searchPattern);
      } else {
        params.push(searchPattern, searchPattern, searchPattern);
      }
    }
    if (hasTreatmentId) {
      query += " ORDER BY c.sort_order, sc.sort_order, t.sort_order, tp.sort_order";
    } else {
      query += " ORDER BY c.sort_order, sc.sort_order, tp.sort_order";
    }
    const questionMarks = (query.match(/\?/g) || []).length;
    console.log("Pricing query question marks:", questionMarks);
    console.log("Pricing params length:", params.length);
    console.log("Pricing query:", query);
    console.log("Pricing params:", JSON.stringify(params));
    let stmt = db.prepare(query);
    if (params.length > 0) {
      stmt = stmt.bind(...params);
    }
    const result = await stmt.all();
    if (!result.success) {
      throw new Error(result.error || "Database query failed");
    }
    const plans = result.results || [];
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
    const errorMessage = error instanceof Error ? error.message : "Unknown error";
    const errorStack = error instanceof Error ? error.stack : void 0;
    console.error("Error details:", { errorMessage, errorStack, query, params });
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: errorMessage,
      stack: errorStack
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
