import type { APIRoute } from 'astro';

const SITE_URL = 'https://ledianclinic.jp';

// ステージング環境かどうかを判定
const isStaging = (url: URL) => {
  return url.hostname.includes('pages.dev') || 
         url.hostname.includes('localhost') ||
         url.hostname.includes('127.0.0.1');
};

export const GET: APIRoute = async ({ url }) => {
  // ステージング環境では全てdisallow
  if (isStaging(url)) {
    const robotsTxt = `User-agent: *
Disallow: /

# Staging environment - no indexing
`;
    return new Response(robotsTxt, {
      headers: { 'Content-Type': 'text/plain' },
    });
  }
  
  // 本番環境用
  const robotsTxt = `User-agent: *
Allow: /

# Sitemap
Sitemap: ${SITE_URL}/sitemap.xml

# Disallow internal/admin paths
Disallow: /api/
Disallow: /_astro/

# Crawl-delay for politeness
Crawl-delay: 1
`;

  return new Response(robotsTxt, {
    headers: { 
      'Content-Type': 'text/plain',
      'Cache-Control': 'public, max-age=86400',
    },
  });
};

