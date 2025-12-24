globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ plans: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const search = url.searchParams.get("search")?.trim();
    let query = `
      SELECT 
        mp.id,
        mp.quantity,
        mp.sessions,
        mp.price,
        mp.price_taxed,
        mp.campaign_price,
        mp.cost_rate,
        mp.supply_cost,
        mp.staff_cost,
        mp.total_cost,
        mp.sort_order,
        m.id AS medication_id,
        m.name AS medication_name,
        m.slug AS medication_slug,
        m.unit AS medication_unit
      FROM medication_plans mp
      JOIN medications m ON mp.medication_id = m.id
      WHERE mp.is_active = 1 AND m.is_active = 1
    `;
    const params = [];
    if (search && search !== "") {
      query += " AND (m.name LIKE ? OR mp.quantity LIKE ?)";
      const searchPattern = `%${search}%`;
      params.push(searchPattern, searchPattern);
    }
    query += " ORDER BY m.name, mp.sort_order, mp.quantity";
    const plans = await queryDB(db, query, params);
    return new Response(JSON.stringify({ plans }), {
      status: 200,
      headers: {
        "Content-Type": "application/json"
      }
    });
  } catch (error) {
    console.error("Error fetching medication plans:", error);
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
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
