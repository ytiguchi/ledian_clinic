globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ flows: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: "Subcategory ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const flows = await queryDB(
      db,
      "SELECT * FROM treatment_flows WHERE subcategory_id = ? ORDER BY step_number",
      [subcategoryId]
    );
    return new Response(JSON.stringify({ flows }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching flows:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const POST = async ({ locals, params, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: "Database not available" }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    const data = await request.json();
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: "Subcategory ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const result = await executeDB(
      db,
      `
        INSERT INTO treatment_flows (subcategory_id, step_number, title, description, duration_minutes, icon)
        VALUES (?, ?, ?, ?, ?, ?)
      `,
      [
        subcategoryId,
        data.step_number,
        data.title,
        data.description || null,
        data.duration_minutes || null,
        data.icon || null
      ]
    );
    return new Response(JSON.stringify({
      success: true,
      id: result.meta.last_row_id
    }), {
      status: 201,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error creating flow:", error);
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
  POST,
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
