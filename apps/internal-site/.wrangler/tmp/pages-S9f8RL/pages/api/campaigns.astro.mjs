globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ campaigns: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const isPublished = url.searchParams.get("is_published");
    let query = `
      SELECT 
        c.id,
        c.title,
        c.slug,
        c.description,
        c.image_url,
        c.start_date,
        c.end_date,
        c.campaign_type,
        c.priority,
        c.is_published,
        c.sort_order,
        c.created_at,
        c.updated_at,
        COUNT(cp.id) AS plan_count
      FROM campaigns c
      LEFT JOIN campaign_plans cp ON c.id = cp.campaign_id
      WHERE 1=1
    `;
    const params = [];
    if (isPublished !== null) {
      query += " AND c.is_published = ?";
      params.push(isPublished === "1" ? 1 : 0);
    }
    query += " GROUP BY c.id ORDER BY c.sort_order, c.created_at DESC";
    const campaigns = await queryDB(db, query, params);
    return new Response(JSON.stringify({
      campaigns: campaigns.map((c) => ({
        ...c,
        is_published: c.is_published === 1
      }))
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching campaigns:", error);
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
const POST = async ({ locals, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const data = await request.json();
    const result = await executeDB(
      db,
      `
        INSERT INTO campaigns (
          title, slug, description, image_url,
          start_date, end_date, campaign_type, priority,
          is_published, sort_order
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        data.title,
        data.slug,
        data.description || null,
        data.image_url || null,
        data.start_date || null,
        data.end_date || null,
        data.campaign_type || "discount",
        data.priority || 0,
        data.is_published ? 1 : 0,
        data.sort_order || 0
      ]
    );
    return new Response(JSON.stringify({
      id: result.meta.last_row_id,
      success: true
    }), {
      status: 201,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error creating campaign:", error);
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
  POST
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
