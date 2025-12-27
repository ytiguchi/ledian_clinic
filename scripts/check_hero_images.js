/**
 * 本番サイトからヒーロー画像の有無を正確に確認するスクリプト
 * .firstview__image または .product__img クラスを持つ要素内の画像のみを対象とする
 */
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // サービス一覧ページから全てのサービスURLとslugを取得
  await page.goto('https://ledianclinic.jp/service/');
  const serviceLinks = await page.evaluate(() => {
    const links = Array.from(document.querySelectorAll('a[href*="/service/"]'));
    const serviceUrls = [];
    const seen = new Set();

    links.forEach(link => {
      const url = link.href;
      if (url.includes('/service/') && !url.endsWith('/service/') && !seen.has(url)) {
        seen.add(url);
        const match = url.match(/\/service\/([^\/]+)\/?$/);
        if (match) {
          serviceUrls.push({
            url: url,
            slug: decodeURIComponent(match[1])
          });
        }
      }
    });
    return serviceUrls;
  });

  console.log(`Found ${serviceLinks.length} services\n`);
  
  const heroImages = [];
  const noHeroImages = [];
  
  for (const service of serviceLinks) {
    await page.goto(service.url, { waitUntil: 'domcontentloaded' });
    
    const heroImage = await page.evaluate(() => {
      // 1. .firstview__image クラスを持つ要素を探す（最優先）
      const firstviewImgDiv = document.querySelector('.firstview__image');
      if (firstviewImgDiv) {
        const img = firstviewImgDiv.querySelector('img');
        if (img) return { src: img.src, type: 'firstview__image' };
      }

      // 2. .product__img クラスを持つ要素を探す
      const productImgDiv = document.querySelector('.product__img');
      if (productImgDiv) {
        const img = productImgDiv.querySelector('img');
        if (img) return { src: img.src, type: 'product__img' };
      }

      // ヒーロー画像なし
      return null;
    });
    
    if (heroImage) {
      heroImages.push({ 
        slug: service.slug, 
        url: heroImage.src,
        type: heroImage.type 
      });
      console.log(`✓ ${service.slug}: ${heroImage.src}`);
    } else {
      noHeroImages.push(service.slug);
      console.log(`✗ ${service.slug}: NO HERO IMAGE`);
    }
  }

  console.log('\n========================================');
  console.log(`Services WITH hero images: ${heroImages.length}`);
  console.log(`Services WITHOUT hero images: ${noHeroImages.length}`);
  console.log('========================================\n');

  if (noHeroImages.length > 0) {
    console.log('Services without hero images:');
    noHeroImages.forEach(slug => console.log(`  - ${slug}`));
  }

  console.log('\n-- SQL: Update hero_image_url for services WITH images --\n');
  heroImages.forEach(item => {
    console.log(`UPDATE service_contents SET hero_image_url = '${item.url}' WHERE slug = '${item.slug}';`);
  });

  console.log('\n-- SQL: Clear hero_image_url for services WITHOUT images --\n');
  noHeroImages.forEach(slug => {
    console.log(`UPDATE service_contents SET hero_image_url = NULL WHERE slug = '${slug}';`);
  });

  await browser.close();
})();

