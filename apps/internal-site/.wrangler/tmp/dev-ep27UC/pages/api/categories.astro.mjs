globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const GET = async ({ locals }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ categories: [] }), { status: 200, headers: { "Content-Type": "application/json" } });
  }
  try {
    const db = getDB(locals.runtime.env);
    const categories = await queryDB(
      db,
      "SELECT * FROM categories ORDER BY sort_order"
    );
    return new Response(JSON.stringify({
      categories: categories.map((cat) => ({
        ...cat,
        is_active: cat.is_active === 1
      }))
    }), {
      status: 200,
      headers: {
        "Content-Type": "application/json"
      }
    });
  } catch (error) {
    console.error("Error fetching categories:", error);
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
const prerender = false;

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  GET,
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
