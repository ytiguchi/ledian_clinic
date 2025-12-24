globalThis.process ??= {}; globalThis.process.env ??= {};
import { g as getDB, q as queryFirst, a as queryDB, e as executeDB } from '../../../chunks/db_CsOQ555j.mjs';
export { renderers } from '../../../renderers.mjs';

const GET = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ campaign: null }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    if (!id) {
      return new Response(JSON.stringify({ error: "ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const campaign = await queryFirst(
      db,
      "SELECT * FROM campaigns WHERE id = ?",
      [id]
    );
    if (!campaign) {
      return new Response(JSON.stringify({ error: "Campaign not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" }
      });
    }
    const plans = await queryDB(
      db,
      "SELECT * FROM campaign_plans WHERE campaign_id = ? ORDER BY sort_order",
      [id]
    );
    return new Response(JSON.stringify({
      campaign: {
        ...campaign,
        is_published: campaign.is_published === 1
      },
      plans
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error fetching campaign:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const PUT = async ({ locals, params, request }) => {
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    const data = await request.json();
    if (!id) {
      return new Response(JSON.stringify({ error: "ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const result = await executeDB(
      db,
      `
        UPDATE campaigns SET
          title = ?,
          slug = ?,
          description = ?,
          image_url = ?,
          start_date = ?,
          end_date = ?,
          campaign_type = ?,
          priority = ?,
          is_published = ?,
          sort_order = ?,
          updated_at = datetime('now')
        WHERE id = ?
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
        data.sort_order || 0,
        id
      ]
    );
    if (data.plans && Array.isArray(data.plans)) {
      await executeDB(
        db,
        "DELETE FROM campaign_plans WHERE campaign_id = ?",
        [id]
      );
      for (const plan of data.plans) {
        await executeDB(
          db,
          `
            INSERT INTO campaign_plans (
              campaign_id, treatment_plan_id, discount_type,
              discount_value, special_price, special_price_taxed, sort_order
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
          `,
          [
            id,
            plan.treatment_plan_id,
            plan.discount_type || "percentage",
            plan.discount_value || null,
            plan.special_price || null,
            plan.special_price_taxed || null,
            plan.sort_order || 0
          ]
        );
      }
    }
    return new Response(JSON.stringify({ success: true, id }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error updating campaign:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const DELETE = async ({ locals, params }) => {
  try {
    const db = getDB(locals.runtime.env);
    const id = params.id;
    if (!id) {
      return new Response(JSON.stringify({ error: "ID is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }
    const result = await executeDB(
      db,
      "DELETE FROM campaigns WHERE id = ?",
      [id]
    );
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    console.error("Error deleting campaign:", error);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: error instanceof Error ? error.message : "Unknown error"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};
const prerender = false;

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  DELETE,
  GET,
  PUT,
  prerender
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
