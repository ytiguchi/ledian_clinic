globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ cautions: [] }), {
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
    const cautions = await queryDB(
      db,
      "SELECT * FROM treatment_cautions WHERE treatment_id = ? ORDER BY sort_order, caution_type",
      [treatmentId]
    );
    return new Response(JSON.stringify({ cautions }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching treatment cautions:", error);
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
    const cautions = Array.isArray(data.cautions) ? data.cautions : [];
    await executeDB(
      db,
      "DELETE FROM treatment_cautions WHERE treatment_id = ?",
      [treatmentId]
    );
    for (const caution of cautions) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_cautions (
            treatment_id, caution_type, content, sort_order
          ) VALUES (?, ?, ?, ?)
        `,
        [
          treatmentId,
          caution.caution_type,
          caution.content,
          caution.sort_order || 0
        ]
      );
    }
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error saving treatment cautions:", error);
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
