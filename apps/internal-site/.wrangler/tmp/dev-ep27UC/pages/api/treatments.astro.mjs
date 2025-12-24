globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ treatments: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = url.searchParams.get("subcategory_id");
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: "subcategory_id is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const treatments = await queryDB(
      db,
      "SELECT * FROM treatments WHERE subcategory_id = ? ORDER BY sort_order",
      [subcategoryId]
    );
    return new Response(JSON.stringify({
      treatments: treatments.map((t) => ({
        ...t,
        is_active: t.is_active === 1
      }))
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching treatments:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  GET
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
