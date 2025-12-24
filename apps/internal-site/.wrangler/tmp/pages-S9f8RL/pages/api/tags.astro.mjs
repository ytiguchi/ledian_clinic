globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const prerender = false;
const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ tags: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const tagType = url.searchParams.get("tag_type");
    let query = "SELECT * FROM tags WHERE is_active = 1";
    const params = [];
    if (tagType) {
      query += " AND tag_type = ?";
      params.push(tagType);
    }
    query += " ORDER BY tag_type, sort_order, name";
    const tags = await queryDB(db, query, params);
    return new Response(JSON.stringify({
      tags: tags.map((t) => ({
        ...t,
        is_active: t.is_active === 1
      }))
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching tags:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const POST = async ({ locals, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const data = await request.json();
    if (!data.tag_type || !data.name || !data.slug) {
      return new Response(JSON.stringify({ error: "tag_type, name, and slug are required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const result = await executeDB(
      db,
      `
        INSERT INTO tags (
          tag_type, name, slug, icon, description, sort_order, is_active
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [
        data.tag_type,
        data.name,
        data.slug,
        data.icon || null,
        data.description || null,
        data.sort_order || 0,
        data.is_active !== false ? 1 : 0
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
    console.error("Error creating tag:", error);
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
