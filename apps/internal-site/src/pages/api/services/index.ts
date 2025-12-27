import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../../lib/db';

export const prerender = false;

interface ServiceContent {
  id: string;
  name_ja: string;
  name_en: string | null;
  slug: string;
  hero_image_url: string | null;
  is_published: number;
  category_name: string | null;
  subcategory_name: string | null;
}

interface Category {
  id: string;
  name: string;
}

export const GET: APIRoute = async ({ locals }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const db = getDB(locals.runtime.env);

    // Get all service contents with category info and counts
    const services = await queryDB<ServiceContent & {
      features_count: number;
      recommendations_count: number;
      faqs_count: number;
    }>(db, `
      SELECT 
        sc.id,
        sc.name_ja,
        sc.name_en,
        sc.slug,
        sc.hero_image_url,
        sc.is_published,
        c.name as category_name,
        sub.name as subcategory_name,
        (SELECT COUNT(*) FROM service_features WHERE service_content_id = sc.id) as features_count,
        (SELECT COUNT(*) FROM service_recommendations WHERE service_content_id = sc.id) as recommendations_count,
        (SELECT COUNT(*) FROM service_faqs WHERE service_content_id = sc.id) as faqs_count
      FROM service_contents sc
      LEFT JOIN subcategories sub ON sc.subcategory_id = sub.id
      LEFT JOIN categories c ON sub.category_id = c.id
      ORDER BY c.sort_order, sub.sort_order, sc.name_ja
    `);

    // Get categories for filter
    const categories = await queryDB<Category>(db, `
      SELECT id, name FROM categories ORDER BY sort_order
    `);

    return new Response(JSON.stringify({ services, categories }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });

  } catch (error) {
    console.error('Error fetching services:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

