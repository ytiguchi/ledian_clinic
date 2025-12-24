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

interface ServiceBeforeAfter {
  id: string;
  before_image_url: string;
  after_image_url: string;
  before_description: string | null;
  after_description: string | null;
  treatment_info: string | null;
}

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
    const contents = await queryDB<ServiceContent>(
      db,
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
    const features = await queryDB<ServiceFeature>(
      db,
      `SELECT id, title, description, icon_url, sort_order 
       FROM service_features 
       WHERE service_content_id = ? 
       ORDER BY sort_order`,
      [content.id]
    );

    // Get recommendations
    const recommendations = await queryDB<ServiceRecommendation>(
      db,
      `SELECT id, text, sort_order 
       FROM service_recommendations 
       WHERE service_content_id = ? 
       ORDER BY sort_order`,
      [content.id]
    );

    // Get overview
    const overviews = await queryDB<ServiceOverview>(
      db,
      `SELECT id, duration, downtime, frequency, makeup, bathing, contraindications 
       FROM service_overviews 
       WHERE service_content_id = ?`,
      [content.id]
    );

    // Get FAQs
    const faqs = await queryDB<ServiceFaq>(
      db,
      `SELECT id, question, answer, sort_order 
       FROM service_faqs 
       WHERE service_content_id = ? 
       ORDER BY sort_order`,
      [content.id]
    );

    // Get before/afters (scraped ones)
    let beforeAfters: ServiceBeforeAfter[] = [];
    try {
      beforeAfters = await queryDB<ServiceBeforeAfter>(
        db,
        `SELECT id, before_image_url, after_image_url, before_description, after_description, treatment_info 
         FROM service_before_afters 
         WHERE service_content_id = ? 
         ORDER BY sort_order`,
        [content.id]
      );
    } catch {
      // Table might not exist
    }

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
      beforeAfters,
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

