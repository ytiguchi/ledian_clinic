import type { APIRoute } from 'astro';
import { getDB, queryFirst, executeDB } from '../../../../lib/db';

export const prerender = false;

// サブカテゴリの詳細情報の取得
export const GET: APIRoute = async ({ locals, params }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ details: null }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: 'Subcategory ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    const details = await queryFirst<{
      id: string;
      subcategory_id: string;
      tagline: string | null;
      tagline_en: string | null;
      summary: string | null;
      description: string | null;
      duration_min: number | null;
      duration_max: number | null;
      duration_text: string | null;
      downtime_days: number;
      downtime_text: string | null;
      pain_level: number | null;
      effect_duration_months: number | null;
      effect_duration_text: string | null;
      recommended_sessions: number | null;
      session_interval_weeks: number | null;
      session_interval_text: string | null;
      popularity_rank: number | null;
      is_featured: number;
      is_new: number;
      hero_image_url: string | null;
      thumbnail_url: string | null;
      video_url: string | null;
      meta_title: string | null;
      meta_description: string | null;
      created_at: string;
      updated_at: string;
    }>(
      db,
      'SELECT * FROM treatment_details WHERE subcategory_id = ?',
      [subcategoryId]
    );
    
    return new Response(JSON.stringify({ 
      details: details ? {
        ...details,
        is_featured: details.is_featured === 1,
        is_new: details.is_new === 1,
      } : null
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching subcategory details:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

// サブカテゴリ詳細情報の作成・更新（PUTで作成、既存なら更新）
export const PUT: APIRoute = async ({ locals, params, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  try {
    const db = getDB(locals.runtime.env);
    const subcategoryId = params.id;
    const data = await request.json();
    
    if (!subcategoryId) {
      return new Response(JSON.stringify({ error: 'Subcategory ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    // 既存レコードをチェック
    const existing = await queryFirst<{ id: string }>(
      db,
      'SELECT id FROM treatment_details WHERE subcategory_id = ?',
      [subcategoryId]
    );
    
    if (existing) {
      // 更新
      await executeDB(
        db,
        `
          UPDATE treatment_details SET
            tagline = ?,
            tagline_en = ?,
            summary = ?,
            description = ?,
            duration_min = ?,
            duration_max = ?,
            duration_text = ?,
            downtime_days = ?,
            downtime_text = ?,
            pain_level = ?,
            effect_duration_months = ?,
            effect_duration_text = ?,
            recommended_sessions = ?,
            session_interval_weeks = ?,
            session_interval_text = ?,
            popularity_rank = ?,
            is_featured = ?,
            is_new = ?,
            hero_image_url = ?,
            thumbnail_url = ?,
            video_url = ?,
            meta_title = ?,
            meta_description = ?,
            updated_at = datetime('now')
          WHERE subcategory_id = ?
        `,
        [
          data.tagline || null,
          data.tagline_en || null,
          data.summary || null,
          data.description || null,
          data.duration_min || null,
          data.duration_max || null,
          data.duration_text || null,
          data.downtime_days ?? 0,
          data.downtime_text || null,
          data.pain_level || null,
          data.effect_duration_months || null,
          data.effect_duration_text || null,
          data.recommended_sessions || null,
          data.session_interval_weeks || null,
          data.session_interval_text || null,
          data.popularity_rank || null,
          data.is_featured ? 1 : 0,
          data.is_new ? 1 : 0,
          data.hero_image_url || null,
          data.thumbnail_url || null,
          data.video_url || null,
          data.meta_title || null,
          data.meta_description || null,
          subcategoryId
        ]
      );
      
      return new Response(JSON.stringify({ success: true, id: existing.id }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    } else {
      // 新規作成
      const result = await executeDB(
        db,
        `
          INSERT INTO treatment_details (
            subcategory_id, tagline, tagline_en, summary, description,
            duration_min, duration_max, duration_text,
            downtime_days, downtime_text, pain_level,
            effect_duration_months, effect_duration_text,
            recommended_sessions, session_interval_weeks, session_interval_text,
            popularity_rank, is_featured, is_new,
            hero_image_url, thumbnail_url, video_url,
            meta_title, meta_description
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `,
        [
          subcategoryId,
          data.tagline || null,
          data.tagline_en || null,
          data.summary || null,
          data.description || null,
          data.duration_min || null,
          data.duration_max || null,
          data.duration_text || null,
          data.downtime_days ?? 0,
          data.downtime_text || null,
          data.pain_level || null,
          data.effect_duration_months || null,
          data.effect_duration_text || null,
          data.recommended_sessions || null,
          data.session_interval_weeks || null,
          data.session_interval_text || null,
          data.popularity_rank || null,
          data.is_featured ? 1 : 0,
          data.is_new ? 1 : 0,
          data.hero_image_url || null,
          data.thumbnail_url || null,
          data.video_url || null,
          data.meta_title || null,
          data.meta_description || null,
        ]
      );
      
      return new Response(JSON.stringify({ 
        success: true, 
        id: result.meta.last_row_id 
      }), {
        status: 201,
        headers: { 'Content-Type': 'application/json' },
      });
    }
  } catch (error) {
    console.error('Error saving subcategory details:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

