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
    const treatmentId = params.id;
    if (!treatmentId) {
      return new Response(JSON.stringify({ error: "Treatment ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const flows = await queryDB(
      db,
      "SELECT * FROM treatment_flows WHERE treatment_id = ? ORDER BY step_number",
      [treatmentId]
    );
    return new Response(JSON.stringify({ flows }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching treatment flows:", error);
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
    const flows = Array.isArray(data.flows) ? data.flows : [];
    await executeDB(
      db,
      "DELETE FROM treatment_flows WHERE treatment_id = ?",
      [treatmentId]
    );
    for (const flow of flows) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_flows (
            treatment_id, step_number, title, description, duration_minutes, icon
          ) VALUES (?, ?, ?, ?, ?, ?)
        `,
        [
          treatmentId,
          flow.step_number,
          flow.title,
          flow.description || null,
          flow.duration_minutes || null,
          flow.icon || null
        ]
      );
    }
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error saving treatment flows:", error);
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
