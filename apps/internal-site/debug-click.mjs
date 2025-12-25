import { chromium } from 'playwright';
(async () => {
  const browser = await chromium.launch({ headless: false, slowMo: 300 });
  const page = await browser.newPage();
  
  page.on('console', msg => console.log('CONSOLE:', msg.text()));
  
  await page.goto('http://localhost:4321/before-afters/new');
  await page.waitForSelector('.category-card');
  
  // カテゴリをクリック
  console.log('カテゴリクリック...');
  await page.click('.category-card:nth-child(10)'); // 麻酔を選択
  
  await page.waitForSelector('.subcategory-card');
  console.log('サブカテゴリ表示完了');
  
  // サブカテゴリのHTML確認
  const html = await page.$eval('.subcategory-grid', el => el.innerHTML);
  console.log('HTML:', html.substring(0, 300));
  
  // サブカテゴリをクリック
  console.log('サブカテゴリクリック...');
  const card = await page.$('.subcategory-card:first-child');
  const box = await card.boundingBox();
  console.log('カード位置:', box);
  
  await page.click('.subcategory-card:first-child');
  await page.waitForTimeout(500);
  
  const selected = await page.$$eval('.subcategory-card.selected', c => c.length);
  console.log('選択数:', selected);
  
  await page.waitForTimeout(5000);
  await browser.close();
})();
