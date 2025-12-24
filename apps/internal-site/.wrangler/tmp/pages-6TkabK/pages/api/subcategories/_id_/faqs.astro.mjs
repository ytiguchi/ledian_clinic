globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ faqs: [] }), {
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
    const faqs = await queryDB(
      db,
      "SELECT * FROM treatment_faqs WHERE subcategory_id = ? ORDER BY sort_order",
      [subcategoryId]
    );
    return new Response(JSON.stringify({
      faqs: faqs.map((f) => ({
        ...f,
        is_published: f.is_published === 1
      }))
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching FAQs:", error);
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
        INSERT INTO treatment_faqs (subcategory_id, question, answer, sort_order, is_published)
        VALUES (?, ?, ?, ?, ?)
      `,
      [
        subcategoryId,
        data.question,
        data.answer,
        data.sort_order || 0,
        data.is_published !== false ? 1 : 0
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
    console.error("Error creating FAQ:", error);
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
