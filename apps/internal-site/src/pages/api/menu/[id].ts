import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../../lib/db';

export const prerender = false;

const jsonResponse = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

const buildInClause = (ids: string[]) => ({
  placeholders: ids.map(() => '?').join(','),
  params: ids,
});

export const GET: APIRoute = async ({ locals, params }) => {
  const { id } = params;
  
  if (!id) {
    return jsonResponse(400, { error: 'Subcategory ID is required' });
  }

  if (!locals?.runtime?.env) {
    return jsonResponse(500, { error: 'Database not available' });
  }

  try {
    const db = getDB(locals.runtime.env);

    // Get subcategory with category info
    const subcategories = await queryDB<{
      id: string;
      name: string;
      slug: string;
      description: string | null;
      device_name: string | null;
      category_id: string;
      category_name: string;
      category_slug: string;
    }>(
      db,
      `SELECT 
        sc.id,
        sc.name,
        sc.slug,
        sc.description,
        sc.device_name,
        c.id AS category_id,
        c.name AS category_name,
        c.slug AS category_slug
      FROM subcategories sc
      JOIN categories c ON sc.category_id = c.id
      WHERE sc.id = ?`,
      [id]
    );

    if (subcategories.length === 0) {
      return jsonResponse(404, { error: 'Subcategory not found' });
    }

    const subcategory = subcategories[0];

    // Get treatments for this subcategory
    const treatments = await queryDB<{
      id: string;
      name: string;
      slug: string;
      description: string | null;
      sort_order: number;
    }>(
      db,
      `SELECT id, name, slug, description, sort_order
       FROM treatments
       WHERE subcategory_id = ? AND is_active = 1
       ORDER BY sort_order`,
      [id]
    );

    // Get treatment plans for all treatments in this subcategory
    const treatmentIds = treatments.map(t => t.id);
    let plans: any[] = [];
    
    if (treatmentIds.length > 0) {
      const { placeholders, params } = buildInClause(treatmentIds);
      plans = await queryDB<{
        id: string;
        treatment_id: string;
        plan_name: string;
        plan_type: string | null;
        sessions: number | null;
        quantity: string | null;
        price: number | null;
        price_taxed: number | null;
        notes: string | null;
        sort_order: number;
      }>(
        db,
        `SELECT id, treatment_id, plan_name, plan_type, sessions, quantity, price, price_taxed, notes, sort_order
         FROM treatment_plans
         WHERE treatment_id IN (${placeholders}) AND is_active = 1
         ORDER BY sort_order`,
        params
      );
    }

    // Get before-after photos linked to this subcategory (via treatments)
    let beforeAfters: any[] = [];
    if (treatmentIds.length > 0) {
      try {
        const tableInfo = await db.prepare(`PRAGMA table_info(treatment_before_afters)`).all<{ name: string }>();
        const hasTreatmentId =
          tableInfo.success && tableInfo.results?.some((col) => col.name === 'treatment_id');
        const hasSubcategoryId =
          tableInfo.success && tableInfo.results?.some((col) => col.name === 'subcategory_id');

        if (hasTreatmentId) {
          const { placeholders, params } = buildInClause(treatmentIds);
          beforeAfters = await queryDB<{
            id: string;
            treatment_id: string;
            title: string | null;
            before_image_url: string | null;
            after_image_url: string | null;
            description: string | null;
            patient_age: number | null;
            patient_gender: string | null;
            treatment_count: number | null;
            created_at: string | null;
          }>(
            db,
            `SELECT id, treatment_id,
                    caption AS title,
                    before_image_url, after_image_url,
                    treatment_content AS description,
                    patient_age, patient_gender, treatment_count, created_at
             FROM treatment_before_afters
             WHERE treatment_id IN (${placeholders})
             ORDER BY created_at DESC
             LIMIT 10`,
            params
          );
        } else if (hasSubcategoryId) {
          beforeAfters = await queryDB<{
            id: string;
            title: string | null;
            before_image_url: string | null;
            after_image_url: string | null;
            description: string | null;
            patient_age: number | null;
            patient_gender: string | null;
            treatment_count: number | null;
            created_at: string | null;
          }>(
            db,
            `SELECT id,
                    caption AS title,
                    before_image_url, after_image_url,
                    treatment_content AS description,
                    patient_age, patient_gender, treatment_count, created_at
             FROM treatment_before_afters
             WHERE subcategory_id = ?
             ORDER BY created_at DESC
             LIMIT 10`,
            [id]
          );
        }

        if (beforeAfters.length === 0) {
          const { placeholders, params } = buildInClause(treatmentIds);
          beforeAfters = await queryDB<{
            id: string;
            treatment_id: string;
            title: string | null;
            before_image_url: string | null;
            after_image_url: string | null;
            description: string | null;
            patient_age: number | null;
            patient_gender: string | null;
            treatment_count: number | null;
            created_at: string | null;
          }>(
            db,
            `SELECT id, treatment_id, title, before_image_url, after_image_url, description,
                    patient_age, patient_gender, treatment_count, created_at
             FROM before_afters
             WHERE treatment_id IN (${placeholders})
             ORDER BY created_at DESC
             LIMIT 10`,
            params
          );
        }
      } catch (e) {
        // Table might not exist
        console.warn('before_afters query failed:', e);
      }
    }

    // Get counseling materials linked to this subcategory
    let trainingModules: any[] = [];
    try {
      trainingModules = await queryDB<{
        id: string;
        title: string;
        description: string | null;
        file_url: string | null;
        file_type: string | null;
        difficulty_level: string | null;
        estimated_minutes: number | null;
        sort_order: number;
      }>(
        db,
        `SELECT id, title, description, file_url, file_type, difficulty_level, estimated_minutes, sort_order
         FROM counseling_materials
         WHERE subcategory_id = ? AND is_published = 1
         ORDER BY sort_order`,
        [id]
      );
    } catch (e) {
      console.warn('counseling_materials query failed:', e);
    }

    // Get protocols linked to this subcategory
    let protocols: any[] = [];
    try {
      protocols = await queryDB<{
        id: string;
        subcategory_id: string;
        title: string;
        description: string | null;
        version: string | null;
        file_url: string | null;
        file_type: string | null;
        created_at: string | null;
      }>(
        db,
        `SELECT id, subcategory_id, title, description, version, file_url, file_type, created_at
         FROM treatment_protocols
         WHERE subcategory_id = ? AND is_published = 1
         ORDER BY created_at DESC`,
        [id]
      );
    } catch (e) {
      console.warn('treatment_protocols query failed:', e);
    }

    // Build response with treatments + plans nested
    const plansByTreatmentId = new Map<string, typeof plans>();
    for (const plan of plans) {
      const list = plansByTreatmentId.get(plan.treatment_id);
      if (list) {
        list.push(plan);
      } else {
        plansByTreatmentId.set(plan.treatment_id, [plan]);
      }
    }
    const treatmentsWithPlans = treatments.map(t => ({
      ...t,
      plans: plansByTreatmentId.get(t.id) ?? []
    }));

    // Get service content linked to this subcategory via subcategory_id FK
    // Include unpublished content for admin editing purposes
    let serviceContent: any = null;
    try {
      const results = await queryDB<{
        id: string;
        name_ja: string;
        name_en: string | null;
        slug: string;
        source_url: string | null;
        about_subtitle: string | null;
        about_description: string | null;
        hero_image_url: string | null;
        is_published: number;
      }>(
        db,
        `SELECT id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published
         FROM service_contents
         WHERE subcategory_id = ?
         LIMIT 1`,
        [id]
      );
      
      if (results.length > 0) {
        const sc = results[0];
        
        // Get features
        const features = await queryDB<{
          title: string;
          description: string | null;
          sort_order: number;
        }>(
          db,
          `SELECT title, description, sort_order FROM service_features WHERE service_content_id = ? ORDER BY sort_order`,
          [sc.id]
        );

        // Get recommendations
        const recommendations = await queryDB<{
          text: string;
          sort_order: number;
        }>(
          db,
          `SELECT text, sort_order FROM service_recommendations WHERE service_content_id = ? ORDER BY sort_order`,
          [sc.id]
        );

        // Get overview
        const overviews = await queryDB<{
          duration: string | null;
          downtime: string | null;
          frequency: string | null;
          makeup: string | null;
          bathing: string | null;
          contraindications: string | null;
        }>(
          db,
          `SELECT duration, downtime, frequency, makeup, bathing, contraindications FROM service_overviews WHERE service_content_id = ?`,
          [sc.id]
        );

        // Get FAQs
        const faqs = await queryDB<{
          question: string;
          answer: string | null;
          sort_order: number;
        }>(
          db,
          `SELECT question, answer, sort_order FROM service_faqs WHERE service_content_id = ? ORDER BY sort_order`,
          [sc.id]
        );

        serviceContent = {
          id: sc.id,
          nameJa: sc.name_ja,
          nameEn: sc.name_en,
          slug: sc.slug,
          sourceUrl: sc.source_url,
          aboutSubtitle: sc.about_subtitle,
          aboutDescription: sc.about_description,
          heroImageUrl: sc.hero_image_url,
          isPublished: sc.is_published === 1,
          features,
          recommendations,
          overview: overviews.length > 0 ? overviews[0] : null,
          faqs,
        };
      }
    } catch (e) {
      console.warn('service_contents query failed:', e);
    }

    return jsonResponse(200, {
      subcategory: {
        id: subcategory.id,
        name: subcategory.name,
        slug: subcategory.slug,
        description: subcategory.description,
        device_name: subcategory.device_name,
        category: {
          id: subcategory.category_id,
          name: subcategory.category_name,
          slug: subcategory.category_slug
        }
      },
      treatments: treatmentsWithPlans,
      beforeAfters,
      trainingModules,
      protocols,
      serviceContent
    });

  } catch (error) {
    console.error('Error fetching menu detail:', error);
    return jsonResponse(500, {
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
};

