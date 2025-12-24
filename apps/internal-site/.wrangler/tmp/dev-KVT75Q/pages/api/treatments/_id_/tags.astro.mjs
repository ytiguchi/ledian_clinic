globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ tags: [] }), {
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
    const tags = await queryDB(
      db,
      `
        SELECT 
          tt.id,
          tt.treatment_id,
          tt.tag_id,
          t.name AS tag_name,
          t.tag_type,
          tt.is_primary,
          tt.sort_order,
          tt.created_at
        FROM treatment_tags tt
        JOIN tags t ON tt.tag_id = t.id
        WHERE tt.treatment_id = ?
        ORDER BY tt.sort_order, t.tag_type, t.name
      `,
      [treatmentId]
    );
    return new Response(JSON.stringify({
      tags: tags.map((t) => ({
        ...t,
        is_primary: t.is_primary === 1
      }))
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching treatment tags:", error);
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
    const tags = Array.isArray(data.tags) ? data.tags : [];
    await executeDB(
      db,
      "DELETE FROM treatment_tags WHERE treatment_id = ?",
      [treatmentId]
    );
    for (const tag of tags) {
      await executeDB(
        db,
        `
          INSERT INTO treatment_tags (
            treatment_id, tag_id, is_primary, sort_order
          ) VALUES (?, ?, ?, ?)
        `,
        [
          treatmentId,
          tag.tag_id,
          tag.is_primary ? 1 : 0,
          tag.sort_order || 0
        ]
      );
    }
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error saving treatment tags:", error);
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
