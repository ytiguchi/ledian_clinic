/**
 * 各サービスページからヒーロー画像URLを取得してSQLを生成するスクリプト
 * 
 * Usage: node scripts/fetch_hero_images.js
 */

const services = [
  { slug: 'potenza', url: 'https://ledianclinic.jp/service/potenza/' },
  { slug: 'ellisys-sense', url: 'https://ledianclinic.jp/service/ellisys-sense/' },
  { slug: 'trifill-pro', url: 'https://ledianclinic.jp/service/trifill-pro/' },
  { slug: 'subcision', url: 'https://ledianclinic.jp/service/subcision/' },
  { slug: 'onda-pro', url: 'https://ledianclinic.jp/service/onda-pro/' },
  { slug: '%e3%82%aa%e3%83%aa%e3%82%b8%e3%82%aakiss', url: 'https://ledianclinic.jp/service/%e3%82%aa%e3%83%aa%e3%82%b8%e3%82%aakiss/' },
  { slug: 'high-intensity-focused-ultrasound', url: 'https://ledianclinic.jp/service/high-intensity-focused-ultrasound/' },
  { slug: 'thread-lift', url: 'https://ledianclinic.jp/service/thread-lift/' },
  { slug: '%e3%82%b7%e3%83%a7%e3%83%83%e3%83%94%e3%83%b3%e3%82%b0%e3%83%aa%e3%83%95%e3%83%88', url: 'https://ledianclinic.jp/service/%e3%82%b7%e3%83%a7%e3%83%83%e3%83%94%e3%83%b3%e3%82%b0%e3%83%aa%e3%83%95%e3%83%88/' },
  { slug: 'hydra-gentle', url: 'https://ledianclinic.jp/service/hydra-gentle/' },
  { slug: 'massage-peel', url: 'https://ledianclinic.jp/service/massage-peel/' },
  { slug: 'milano-repeel', url: 'https://ledianclinic.jp/service/milano-repeel/' },
  { slug: 'manuka-peel', url: 'https://ledianclinic.jp/service/manuka-peel/' },
  { slug: 'lhala-doctor', url: 'https://ledianclinic.jp/service/lhala-doctor/' },
  { slug: 'jalupro-glowpeel', url: 'https://ledianclinic.jp/service/jalupro-glowpeel/' },
  { slug: 'v-carbon-peel', url: 'https://ledianclinic.jp/service/v-carbon-peel/' },
  { slug: 'stella-m22', url: 'https://ledianclinic.jp/service/stella-m22/' },
  { slug: 'pico-laser', url: 'https://ledianclinic.jp/service/pico-laser/' },
  { slug: 'lipodissolve-injection', url: 'https://ledianclinic.jp/service/lipodissolve-injection/' },
  { slug: 'botox', url: 'https://ledianclinic.jp/service/botox/' },
  { slug: 'hyaluronic-acid-2', url: 'https://ledianclinic.jp/service/hyaluronic-acid-2/' },
  { slug: 'carecys', url: 'https://ledianclinic.jp/service/carecys/' },
  { slug: 'lhala-10-ldm', url: 'https://ledianclinic.jp/service/lhala-10-ldm/' },
  { slug: 'roma-pink', url: 'https://ledianclinic.jp/service/roma-pink/' },
  { slug: 'permanent-makeup', url: 'https://ledianclinic.jp/service/permanent-makeup/' },
  { slug: 'soprano-ice-platinum', url: 'https://ledianclinic.jp/service/soprano-ice-platinum/' },
  { slug: 'skin-boosting-injection', url: 'https://ledianclinic.jp/service/skin-boosting-injection/' },
  { slug: 'eve-v-muse', url: 'https://ledianclinic.jp/service/eve-v-muse/' },
];

async function fetchHeroImage(url) {
  try {
    const response = await fetch(url);
    const html = await response.text();
    
    // firstviewセクション内の画像を探す（SVGアイコンを除外）
    // パターン1: section class="firstview"内の最初の製品画像
    const firstviewMatch = html.match(/<section[^>]*class="[^"]*firstview[^"]*"[^>]*>([\s\S]*?)<\/section>/i);
    
    if (firstviewMatch) {
      const firstviewHtml = firstviewMatch[1];
      // アイコン系のSVGを除外し、jpg/png/webp画像を取得
      const imgMatches = firstviewHtml.matchAll(/<img[^>]+src="([^"]+\.(jpg|jpeg|png|webp)[^"]*)"/gi);
      for (const match of imgMatches) {
        const imgUrl = match[1];
        // 明らかにアイコンでないものを返す
        if (!imgUrl.includes('arrow') && !imgUrl.includes('icon') && !imgUrl.includes('logo')) {
          return imgUrl;
        }
      }
    }
    
    // パターン2: product__img内の画像
    const productImgMatch = html.match(/<div[^>]*class="[^"]*product__img[^"]*"[^>]*>\s*<img[^>]+src="([^"]+)"/i);
    if (productImgMatch && !productImgMatch[1].includes('.svg')) {
      return productImgMatch[1];
    }
    
    // パターン3: wp-content/uploadsにある任意の製品画像（main領域内）
    const mainMatch = html.match(/<main[^>]*>([\s\S]*?)<\/main>/i);
    if (mainMatch) {
      const mainHtml = mainMatch[1];
      const uploadImgMatch = mainHtml.match(/<img[^>]+src="(https:\/\/ledianclinic\.jp\/wp-content\/uploads\/[^"]+\.(jpg|jpeg|png|webp)[^"]*)"/i);
      if (uploadImgMatch) {
        return uploadImgMatch[1];
      }
    }
    
    return null;
  } catch (error) {
    console.error(`Error fetching ${url}:`, error.message);
    return null;
  }
}

async function main() {
  const results = [];
  
  for (const service of services) {
    const imageUrl = await fetchHeroImage(service.url);
    results.push({
      slug: service.slug,
      heroImageUrl: imageUrl
    });
    console.log(`${service.slug}: ${imageUrl || 'NO HERO IMAGE'}`);
  }
  
  // SQLを生成
  console.log('\n\n-- SQL Updates (only for services with hero images) --\n');
  for (const result of results) {
    if (result.heroImageUrl) {
      // シングルクォートをエスケープ
      const escapedUrl = result.heroImageUrl.replace(/'/g, "''");
      console.log(`UPDATE service_contents SET hero_image_url = '${escapedUrl}' WHERE slug = '${result.slug}';`);
    }
  }
}

main().catch(console.error);
