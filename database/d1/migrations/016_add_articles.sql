-- ============================================
-- 記事コンテンツ（articles）追加
-- ============================================

CREATE TABLE IF NOT EXISTS articles (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  excerpt TEXT,
  body TEXT,
  hero_image_url TEXT,
  author_name TEXT,
  is_published INTEGER NOT NULL DEFAULT 0,
  published_at DATETIME,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS article_blocks (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  article_id TEXT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  block_type TEXT NOT NULL
    CHECK (block_type IN ('text','image','quote','list','embed')),
  content TEXT,
  media_url TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS article_tags (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS article_tag_links (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  article_id TEXT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  tag_id TEXT NOT NULL REFERENCES article_tags(id) ON DELETE CASCADE,
  UNIQUE(article_id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_article_blocks_article ON article_blocks(article_id);
CREATE INDEX IF NOT EXISTS idx_article_tags_slug ON article_tags(slug);
