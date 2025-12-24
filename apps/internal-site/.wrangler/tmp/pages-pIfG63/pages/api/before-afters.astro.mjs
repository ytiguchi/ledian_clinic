globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, a as queryDB, e as executeDB } from '../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../renderers.mjs';

const GET = async ({ locals, url }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ before_afters: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const treatmentId = url.searchParams.get("treatment_id");
    const isPublished = url.searchParams.get("is_published");
    let query = `
      SELECT 
        ba.id,
        ba.treatment_id,
        ba.before_image_url,
        ba.after_image_url,
        ba.caption,
        ba.patient_age,
        ba.patient_gender,
        ba.treatment_count,
        ba.treatment_period,
        ba.is_published,
        ba.sort_order,
        ba.created_at,
        t.name AS treatment_name
      FROM treatment_before_afters ba
      JOIN treatments t ON ba.treatment_id = t.id
      WHERE 1=1
    `;
    const params = [];
    if (treatmentId) {
      query += " AND ba.treatment_id = ?";
      params.push(treatmentId);
    }
    if (isPublished !== null) {
      query += " AND ba.is_published = ?";
      params.push(isPublished === "1" ? 1 : 0);
    }
    query += " ORDER BY ba.sort_order, ba.created_at DESC";
    const beforeAfters = await queryDB(db, query, params);
    return new Response(JSON.stringify({ before_afters: beforeAfters }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching before-afters:", error);
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
    const result = await executeDB(
      db,
      `
        INSERT INTO treatment_before_afters (
          treatment_id, before_image_url, after_image_url, caption,
          patient_age, patient_gender, treatment_count, treatment_period,
          is_published, sort_order
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        data.treatment_id,
        data.before_image_url,
        data.after_image_url,
        data.caption || null,
        data.patient_age || null,
        data.patient_gender || null,
        data.treatment_count || null,
        data.treatment_period || null,
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
    console.error("Error creating before-after:", error);
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
