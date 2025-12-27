import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../../lib/db';

export const prerender = false;

interface ServiceContent {
  id: string;
  subcategory_id: string | null;
  name_ja: string;
  name_en: string | null;
  slug: string;
  source_url: string | null;
  about_subtitle: string | null;
  about_description: string | null;
  hero_image_url: string | null;
  is_published: number;
  scraped_at: string | null;
}

interface ServiceFeature {
  id: string;
  title: string;
  description: string | null;
  icon_url: string | null;
  sort_order: number;
}

interface ServiceRecommendation {
  id: string;
  text: string;
  sort_order: number;
}

interface ServiceOverview {
  id: string;
  duration: string | null;
  downtime: string | null;
  frequency: string | null;
  makeup: string | null;
  bathing: string | null;
  contraindications: string | null;
}

interface ServiceFaq {
  id: string;
  question: string;
  answer: string | null;
  sort_order: number;
}

// GET: Fetch service content by slug
export const GET: APIRoute = async ({ locals, params }) => {
  const { slug } = params;

  if (!slug) {
    return new Response(JSON.stringify({ error: 'Slug is required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const db = getDB(locals.runtime.env);

    // Get service content by slug
    const contents = await queryDB<ServiceContent>(db, 
      `SELECT * FROM service_contents WHERE slug = ?`, 
      [slug]
    );

    if (contents.length === 0) {
      return new Response(JSON.stringify({ error: 'Service content not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const content = contents[0];

    // Get features
    const features = await queryDB<ServiceFeature>(db,
      `SELECT id, title, description, icon_url, sort_order 
       FROM service_features 
       WHERE service_content_id = ? 
       ORDER BY sort_order`,
      [content.id]
    );

    // Get recommendations
    const recommendations = await queryDB<ServiceRecommendation>(db,
      `SELECT id, text, sort_order 
       FROM service_recommendations 
       WHERE service_content_id = ? 
       ORDER BY sort_order`,
      [content.id]
    );

    // Get overview
    const overviews = await queryDB<ServiceOverview>(db,
      `SELECT id, duration, downtime, frequency, makeup, bathing, contraindications 
       FROM service_overviews 
       WHERE service_content_id = ?`,
      [content.id]
    );

    // Get FAQs
    const faqs = await queryDB<ServiceFaq>(db,
      `SELECT id, question, answer, sort_order 
       FROM service_faqs 
       WHERE service_content_id = ? 
       ORDER BY sort_order`,
      [content.id]
    );

    return new Response(JSON.stringify({
      content: {
        id: content.id,
        subcategoryId: content.subcategory_id,
        nameJa: content.name_ja,
        nameEn: content.name_en,
        slug: content.slug,
        sourceUrl: content.source_url,
        aboutSubtitle: content.about_subtitle,
        aboutDescription: content.about_description,
        heroImageUrl: content.hero_image_url,
        isPublished: content.is_published === 1,
        scrapedAt: content.scraped_at,
      },
      features,
      recommendations,
      overview: overviews.length > 0 ? overviews[0] : null,
      faqs,
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });

  } catch (error) {
    console.error('Error fetching service content:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// PUT: Update service content
export const PUT: APIRoute = async ({ locals, params, request }) => {
  const { slug } = params;

  if (!slug) {
    return new Response(JSON.stringify({ error: 'Slug is required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const db = getDB(locals.runtime.env);
    const body = await request.json();

    // Get existing service content
    const contents = await queryDB<ServiceContent>(db, 
      `SELECT * FROM service_contents WHERE slug = ?`, 
      [slug]
    );

    if (contents.length === 0) {
      return new Response(JSON.stringify({ error: 'Service content not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const serviceId = contents[0].id;

    // Update main content
    if (body.content) {
      await db.prepare(`
        UPDATE service_contents 
        SET name_ja = ?, 
            name_en = ?, 
            hero_image_url = ?, 
            is_published = ?, 
            about_subtitle = ?, 
            about_description = ?
        WHERE id = ?
      `).bind(
        body.content.name_ja,
        body.content.name_en,
        body.content.hero_image_url,
        body.content.is_published,
        body.content.about_subtitle,
        body.content.about_description,
        serviceId
      ).run();
    }

    // Update features (delete and re-insert)
    if (body.features !== undefined) {
      await db.prepare(`DELETE FROM service_features WHERE service_content_id = ?`).bind(serviceId).run();
      
      for (const feature of body.features) {
        if (feature.title) {
          await db.prepare(`
            INSERT INTO service_features (id, service_content_id, title, description, icon_url, sort_order)
            VALUES (?, ?, ?, ?, ?, ?)
          `).bind(
            crypto.randomUUID(),
            serviceId,
            feature.title,
            feature.description || null,
            feature.icon_url || null,
            feature.sort_order || 0
          ).run();
        }
      }
    }

    // Update recommendations (delete and re-insert)
    if (body.recommendations !== undefined) {
      await db.prepare(`DELETE FROM service_recommendations WHERE service_content_id = ?`).bind(serviceId).run();
      
      for (const rec of body.recommendations) {
        if (rec.text) {
          await db.prepare(`
            INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
            VALUES (?, ?, ?, ?)
          `).bind(
            crypto.randomUUID(),
            serviceId,
            rec.text,
            rec.sort_order || 0
          ).run();
        }
      }
    }

    // Update overview (upsert)
    if (body.overview !== undefined) {
      const existingOverview = await queryDB<{ id: string }>(db,
        `SELECT id FROM service_overviews WHERE service_content_id = ?`,
        [serviceId]
      );

      if (existingOverview.length > 0) {
        await db.prepare(`
          UPDATE service_overviews 
          SET duration = ?, downtime = ?, frequency = ?, makeup = ?, bathing = ?, contraindications = ?
          WHERE service_content_id = ?
        `).bind(
          body.overview.duration,
          body.overview.downtime,
          body.overview.frequency,
          body.overview.makeup,
          body.overview.bathing,
          body.overview.contraindications,
          serviceId
        ).run();
      } else {
        await db.prepare(`
          INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
          crypto.randomUUID(),
          serviceId,
          body.overview.duration,
          body.overview.downtime,
          body.overview.frequency,
          body.overview.makeup,
          body.overview.bathing,
          body.overview.contraindications
        ).run();
      }
    }

    // Update FAQs (delete and re-insert)
    if (body.faqs !== undefined) {
      await db.prepare(`DELETE FROM service_faqs WHERE service_content_id = ?`).bind(serviceId).run();
      
      for (const faq of body.faqs) {
        if (faq.question) {
          await db.prepare(`
            INSERT INTO service_faqs (id, service_content_id, question, answer, sort_order)
            VALUES (?, ?, ?, ?, ?)
          `).bind(
            crypto.randomUUID(),
            serviceId,
            faq.question,
            faq.answer || null,
            faq.sort_order || 0
          ).run();
        }
      }
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });

  } catch (error) {
    console.error('Error updating service content:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

