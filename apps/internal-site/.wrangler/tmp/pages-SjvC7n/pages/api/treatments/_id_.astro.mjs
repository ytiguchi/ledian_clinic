globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, q as queryFirst } from '../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ treatment: null }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    if (!id) {
      return new Response(JSON.stringify({ error: "Treatment ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const treatment = await queryFirst(
      db,
      `
        SELECT 
          t.id,
          t.name,
          t.slug,
          t.description,
          t.sort_order,
          t.is_active,
          sc.id AS subcategory_id,
          sc.name AS subcategory_name,
          c.id AS category_id,
          c.name AS category_name
        FROM treatments t
        JOIN subcategories sc ON t.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE t.id = ?
      `,
      [id]
    );
    if (!treatment) {
      return new Response(JSON.stringify({ error: "Treatment not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" }
      });
    }
    return new Response(JSON.stringify({
      treatment: {
        ...treatment,
        is_active: treatment.is_active === 1
      }
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching treatment:", error);
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
  GET,
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
