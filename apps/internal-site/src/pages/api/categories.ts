import type { APIRoute } from 'astro';
import { getDB, queryDB } from '../../lib/db';
import type { CategoriesResponse } from '../../types/api';

export const GET: APIRoute = async ({ locals }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ categories: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  }
  try {
    const db = getDB(locals.runtime.env);
    
    const categories = await queryDB<{
      id: string;
      name: string;
      slug: string;
      sort_order: number;
      is_active: number;
      created_at: string;
      updated_at: string;
    }>(
      db,
      'SELECT * FROM categories ORDER BY sort_order'
    );

    const response: CategoriesResponse = {
      categories: categories.map(cat => ({
        ...cat,
        is_active: cat.is_active === 1,
      })),
    };
    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  } catch (error) {
    console.error('Error fetching categories:', error);
    return new Response(JSON.stringify({
      error: 'Internal Server Error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  }
};

function normalizeSlug(input: string): string {
  // - keep JP slugs (they are used in existing seed data)
  // - make URL-friendly for latin input
  return input
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^a-z0-9\-ぁ-んァ-ン一-龠ー・]+/g, '')
    .replace(/\-+/g, '-')
    .replace(/^\-+|\-+$/g, '');
}

// カテゴリ新規作成
export const POST: APIRoute = async ({ locals, request }) => {
  if (!locals?.runtime?.env) {
    return new Response(JSON.stringify({ error: 'Database not available' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const db = getDB(locals.runtime.env);
    const body = await request.json().catch(() => ({}));
    const rawName = typeof body?.name === 'string' ? body.name : '';
    const rawSlug = typeof body?.slug === 'string' ? body.slug : '';

    const name = rawName.trim();
    if (!name) {
      return new Response(JSON.stringify({ error: 'カテゴリ名は必須です' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // 同名は不可（UNIQUE）。slugは重複時に自動でサフィックス付与。
    const baseSlug = normalizeSlug(rawSlug || name) || normalizeSlug(name) || name;

    const { results: maxRows } = await db
      .prepare(`SELECT COALESCE(MAX(sort_order), 0) + 1 AS next_order FROM categories`)
      .all<{ next_order: number }>();
    const nextOrder = maxRows?.[0]?.next_order ?? 1;

    let createdRowId: number | null = null;
    let finalSlug = baseSlug;

    // Try a few slug variants if UNIQUE(slug) collision happens
    for (let attempt = 0; attempt < 25; attempt++) {
      finalSlug = attempt === 0 ? baseSlug : `${baseSlug}-${attempt + 1}`;
      const insert = await db
        .prepare(
          `INSERT INTO categories (name, slug, sort_order, is_active)
           VALUES (?, ?, ?, 1)`
        )
        .bind(name, finalSlug, nextOrder)
        .run();

      if (insert.success) {
        createdRowId = insert.meta.last_row_id;
        break;
      }

      const err = insert.error || '';
      // name UNIQUE violation
      if (err.toLowerCase().includes('categories.name') || err.toLowerCase().includes('unique') && err.toLowerCase().includes('name')) {
        return new Response(JSON.stringify({ error: '同名のカテゴリが既に存在します' }), {
          status: 409,
          headers: { 'Content-Type': 'application/json' },
        });
      }

      // slug UNIQUE violation -> try next
      if (err.toLowerCase().includes('categories.slug') || (err.toLowerCase().includes('unique') && err.toLowerCase().includes('slug'))) {
        continue;
      }

      // unknown insert failure
      throw new Error(err || 'Failed to insert category');
    }

    if (!createdRowId) {
      return new Response(JSON.stringify({ error: 'カテゴリ作成に失敗しました（slug重複）' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // rowid から取得（id型がINTEGERでもTEXTでも対応できる）
    const created = await db
      .prepare(
        `SELECT id, name, slug, sort_order, is_active, created_at, updated_at
         FROM categories
         WHERE rowid = ?`
      )
      .bind(createdRowId)
      .first<{
        id: string;
        name: string;
        slug: string;
        sort_order: number;
        is_active: number;
        created_at: string;
        updated_at: string;
      }>();

    return new Response(
      JSON.stringify({
        success: true,
        category: created
          ? { ...created, is_active: created.is_active === 1 }
          : { id: String(createdRowId), name, slug: finalSlug, sort_order: nextOrder, is_active: true },
      }),
      {
        status: 201,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  } catch (error) {
    console.error('Error creating category:', error);
    return new Response(
      JSON.stringify({
        error: 'Internal Server Error',
        message: error instanceof Error ? error.message : 'Unknown error',
      }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
};

export const prerender = false;
