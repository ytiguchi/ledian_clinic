globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ subcategories: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const categoryId = url.searchParams.get("category_id")?.trim();
    const params = [];
    let query = `
      SELECT 
        sc.id,
        sc.name,
        sc.slug,
        sc.category_id,
        sc.sort_order,
        sc.is_active,
        c.name AS category_name
      FROM subcategories sc
      JOIN categories c ON sc.category_id = c.id
      WHERE sc.is_active = 1
    `;
    if (categoryId && categoryId !== "" && categoryId !== "undefined" && categoryId !== "null") {
      query += " AND sc.category_id = ?";
      params.push(categoryId);
    }
    query += " ORDER BY sc.sort_order";
    console.log("Subcategories query:", query);
    console.log("Subcategories params:", params);
    console.log("Subcategories params length:", params.length);
    console.log("Subcategories categoryId:", categoryId);
    const questionMarks = (query.match(/\?/g) || []).length;
    console.log("Final query question marks:", questionMarks);
    console.log("Final params length:", params.length);
    console.log("Query:", query);
    console.log("Params:", JSON.stringify(params));
    let stmt = db.prepare(query);
    if (params.length > 0) {
      stmt = stmt.bind(...params);
    }
    const result = await stmt.all();
    if (!result.success) {
      throw new Error(result.error || "Database query failed");
    }
    const subcategories = result.results || [];
    return new Response(JSON.stringify({
      subcategories: subcategories.map((sub) => ({
        ...sub,
        is_active: sub.is_active === 1
      }))
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching subcategories:", error);
    const errorMessage = error instanceof Error ? error.message : "Unknown error";
    const errorStack = error instanceof Error ? error.stack : void 0;
    console.error("Error details:", { errorMessage, errorStack });
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: errorMessage,
      stack: errorStack
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
