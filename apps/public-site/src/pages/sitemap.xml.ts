import type { APIRoute } from 'astro';

// 静的ページの一覧
const staticPages = [
  { url: '/', priority: 1.0, changefreq: 'weekly' },
  { url: '/service/', priority: 0.9, changefreq: 'weekly' },
  { url: '/price/', priority: 0.9, changefreq: 'weekly' },
  { url: '/news/', priority: 0.8, changefreq: 'daily' },
  { url: '/doctor/', priority: 0.7, changefreq: 'monthly' },
  { url: '/subscription/', priority: 0.7, changefreq: 'monthly' },
  { url: '/contact/', priority: 0.6, changefreq: 'monthly' },
  { url: '/terms', priority: 0.3, changefreq: 'yearly' },
  { url: '/privacy-policy', priority: 0.3, changefreq: 'yearly' },
  { url: '/legal', priority: 0.3, changefreq: 'yearly' },
  { url: '/use-terms', priority: 0.3, changefreq: 'yearly' },
  { url: '/cancel', priority: 0.3, changefreq: 'yearly' },
];

const SITE_URL = 'https://ledianclinic.jp';

export const GET: APIRoute = async ({ locals }) => {
  const db = locals.runtime.env.DB;
  
  // 動的ページを取得
  const dynamicPages: { url: string; priority: number; changefreq: string; lastmod?: string }[] = [];
  
  try {
    // サービス詳細ページ
    const services = await db.prepare(`
      SELECT slug, updated_at FROM service_contents WHERE is_published = 1
    `).all();
    
    for (const service of services.results as { slug: string; updated_at: string }[]) {
      dynamicPages.push({
        url: `/service/${service.slug}/`,
        priority: 0.8,
        changefreq: 'weekly',
        lastmod: service.updated_at?.split('T')[0],
      });
    }
    
    // ニュース詳細ページ
    const news = await db.prepare(`
      SELECT slug, updated_at FROM campaigns WHERE is_published = 1
    `).all();
    
    for (const item of news.results as { slug: string; updated_at: string }[]) {
      dynamicPages.push({
        url: `/news/${item.slug}/`,
        priority: 0.6,
        changefreq: 'monthly',
        lastmod: item.updated_at?.split('T')[0],
      });
    }
  } catch (e) {
    console.error('Error fetching dynamic pages for sitemap:', e);
  }
  
  const allPages = [...staticPages, ...dynamicPages];
  const today = new Date().toISOString().split('T')[0];
  
  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${allPages.map(page => `  <url>
    <loc>${SITE_URL}${page.url}</loc>
    <lastmod>${page.lastmod || today}</lastmod>
    <changefreq>${page.changefreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>`).join('\n')}
</urlset>`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml',
      'Cache-Control': 'public, max-age=3600',
    },
  });
};

