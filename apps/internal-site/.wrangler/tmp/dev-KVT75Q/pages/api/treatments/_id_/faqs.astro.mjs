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
    const treatmentId = params.id;
    if (!treatmentId) {
      return new Response(JSON.stringify({ error: "Treatment ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const faqs = await queryDB(
      db,
      "SELECT * FROM treatment_faqs WHERE treatment_id = ? ORDER BY sort_order",
      [treatmentId]
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
    console.error("Error fetching treatment FAQs:", error);
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
  try {
    const db = getDB(locals.runtime.env);
    const treatmentId = params.id;
    const data = await request.json();
    if (!treatmentId) {
      return new Response(JSON.stringify({ error: "Treatment ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const faqs = Array.isArray(data.faqs) ? data.faqs : [];
    await executeDB(
      db,
      "DELETE FROM treatment_faqs WHERE treatment_id = ?",
      [treatmentId]
    );
    for (const faq of faqs) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_faqs (
            treatment_id, question, answer, sort_order, is_published
          ) VALUES (?, ?, ?, ?, ?)
        `,
        [
          treatmentId,
          faq.question,
          faq.answer,
          faq.sort_order || 0,
          faq.is_published ? 1 : 0
        ]
      );
    }
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error saving treatment FAQs:", error);
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
