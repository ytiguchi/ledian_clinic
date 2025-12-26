import type { APIRoute } from 'astro';
import { getDB, getRepresentativeTreatmentId } from '../../../lib/db';
import {
  jsonResponse,
  parseIsPublishedParam,
  requireRuntimeEnv,
  validationError,
  withErrorHandling,
} from '../../../lib/api';

export const prerender = false;

export const GET: APIRoute = async ({ locals, url }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { before_afters: [] },
      status: 200,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const tableInfo = await db.prepare(`PRAGMA table_info(treatment_before_afters)`).all<{ name: string }>();
    const hasTreatmentId =
      tableInfo.success && tableInfo.results?.some((col) => col.name === 'treatment_id');
    
    const subcategoryId = url.searchParams.get('subcategory_id');
    const treatmentId = url.searchParams.get('treatment_id');
    const categoryId = url.searchParams.get('category_id');
    const isPublished = parseIsPublishedParam(url.searchParams.get('is_published'));
    
    let query = '';
    if (hasTreatmentId) {
      query = `
        SELECT 
          ba.id,
          ba.treatment_id,
          t.subcategory_id,
          ba.before_image_url,
          ba.after_image_url,
          ba.caption,
          ba.treatment_content,
          ba.treatment_duration,
          ba.treatment_cost,
          ba.treatment_cost_text,
          ba.risks,
          ba.patient_age,
          ba.patient_gender,
          ba.treatment_count,
          ba.treatment_period,
          ba.is_published,
          ba.sort_order,
          ba.created_at,
          sc.name AS subcategory_name,
          c.id AS category_id,
          c.name AS category_name
        FROM treatment_before_afters ba
        JOIN treatments t ON ba.treatment_id = t.id
        JOIN subcategories sc ON t.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE 1=1
      `;
    } else {
      query = `
        SELECT 
          ba.id,
          ba.subcategory_id,
          ba.before_image_url,
          ba.after_image_url,
          ba.caption,
          ba.treatment_content,
          ba.treatment_duration,
          ba.treatment_cost,
          ba.treatment_cost_text,
          ba.risks,
          ba.patient_age,
          ba.patient_gender,
          ba.treatment_count,
          ba.treatment_period,
          ba.is_published,
          ba.sort_order,
          ba.created_at,
          sc.name AS subcategory_name,
          c.id AS category_id,
          c.name AS category_name
        FROM treatment_before_afters ba
        JOIN subcategories sc ON ba.subcategory_id = sc.id
        JOIN categories c ON sc.category_id = c.id
        WHERE 1=1
      `;
    }
    
    const params: unknown[] = [];
    
    if (categoryId) {
      query += ' AND c.id = ?';
      params.push(categoryId);
    }

    if (subcategoryId) {
      query += ' AND sc.id = ?';
      params.push(subcategoryId);
    }

    if (treatmentId) {
      if (hasTreatmentId) {
        query += ' AND ba.treatment_id = ?';
        params.push(treatmentId);
      } else {
        query += ' AND ba.subcategory_id = ?';
        params.push(treatmentId);
      }
    }
    
    if (isPublished !== null) {
      query += ' AND ba.is_published = ?';
      params.push(isPublished);
    }
    
    query += ' ORDER BY ba.sort_order, ba.created_at DESC';
    
    let stmt = db.prepare(query);
    if (params.length > 0) {
      stmt = stmt.bind(...params);
    }
    const result = await stmt.all<{
      id: string;
      treatment_id?: string;
      subcategory_id: string;
      before_image_url: string;
      after_image_url: string;
      caption: string | null;
      treatment_content: string | null;
      treatment_duration: string | null;
      treatment_cost: number | null;
      treatment_cost_text: string | null;
      risks: string | null;
      patient_age: number | null;
      patient_gender: string | null;
      treatment_count: number | null;
      treatment_period: string | null;
      is_published: number;
      sort_order: number;
      created_at: string;
      subcategory_name: string;
      category_id: string;
      category_name: string;
    }>();
    
    if (!result.success) {
      throw new Error(result.error || 'Database query failed');
    }
    
    return jsonResponse(200, { before_afters: result.results || [] });
  });
};

export const POST: APIRoute = async ({ locals, request }) => {
  return withErrorHandling(async () => {
    const envResponse = requireRuntimeEnv(locals?.runtime, {
      body: { error: 'Environment not available' },
      status: 500,
    });
    if (envResponse) return envResponse;

    const db = getDB(locals.runtime.env);
    const tableInfo = await db.prepare(`PRAGMA table_info(treatment_before_afters)`).all<{ name: string }>();
    const hasTreatmentId =
      tableInfo.success && tableInfo.results?.some((col) => col.name === 'treatment_id');
    const data = await request.json();
    
    const treatmentId = data.treatment_id;
    const subcategoryId = data.subcategory_id;
    let resolvedTreatmentId: string | null = null;
    let resolvedSubcategoryId: string | null = null;

    if (hasTreatmentId) {
      if (treatmentId) {
        resolvedTreatmentId = treatmentId;
      } else if (subcategoryId) {
        resolvedTreatmentId = await getRepresentativeTreatmentId(db, subcategoryId);
      }
    } else {
      if (subcategoryId) {
        resolvedSubcategoryId = subcategoryId;
      } else if (treatmentId) {
        const treatment = await db
          .prepare(`SELECT subcategory_id FROM treatments WHERE id = ?`)
          .bind(treatmentId)
          .first<{ subcategory_id: string }>();
        resolvedSubcategoryId = treatment?.subcategory_id ?? null;
      }
    }

    if (hasTreatmentId ? !resolvedTreatmentId : !resolvedSubcategoryId) {
      return validationError('treatment_id is required', [
        { field: 'treatment_id', message: 'treatment_id is required' },
      ]);
    }
    if (!data.after_image_url) {
      return validationError('after_image_url is required', [
        { field: 'after_image_url', message: 'after_image_url is required' },
      ]);
    }

    const result = await db
      .prepare(
        `
          INSERT INTO treatment_before_afters (
            ${hasTreatmentId ? 'treatment_id' : 'subcategory_id'},
            before_image_url, after_image_url, caption,
            treatment_content, treatment_duration, treatment_cost, treatment_cost_text, risks,
            patient_age, patient_gender, treatment_count, treatment_period,
            is_published, sort_order
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `
      )
      .bind(
        hasTreatmentId ? resolvedTreatmentId : resolvedSubcategoryId,
        data.before_image_url || '',
        data.after_image_url,
        data.caption || null,
        data.treatment_content || null,
        data.treatment_duration || null,
        data.treatment_cost ?? null,
        data.treatment_cost_text || null,
        data.risks || null,
        data.patient_age || null,
        data.patient_gender || null,
        data.treatment_count || null,
        data.treatment_period || null,
        data.is_published ? 1 : 0,
        data.sort_order || 0
      )
      .run();
    
    if (!result.success) {
      throw new Error(result.error || 'Failed to create before-after');
    }
    
    return jsonResponse(201, {
      id: result.meta.last_row_id,
      success: true,
    });
  });
};
