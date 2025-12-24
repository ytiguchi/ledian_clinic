globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, q as queryFirst, e as executeDB } from '../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../renderers.mjs';

const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ plan: null }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    if (!id) {
      return new Response(JSON.stringify({ error: "ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const plan = await queryFirst(
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
      return new Response(JSON.stringify({ error: "Plan not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" }
      });
    }
    return new Response(JSON.stringify({ plan }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching plan:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const PUT = async ({ locals, params, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data = await request.json();
    if (!id) {
      return new Response(JSON.stringify({ error: "ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const result = await executeDB(
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
          updated_at = datetime('now')
        WHERE id = ?
      `,
      [
        data.subcategory_id,
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
        id
      ]
    );
    return new Response(JSON.stringify({ success: true, id }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error updating plan:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const DELETE = async ({ locals, params }) => {
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    if (!id) {
      return new Response(JSON.stringify({ error: "ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const result = await executeDB(
      db,
      "UPDATE treatment_plans SET is_active = 0, updated_at = datetime('now') WHERE id = ?",
      [id]
    );
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error deleting plan:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const prerender = false;

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  DELETE,
  GET,
  PUT,
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
