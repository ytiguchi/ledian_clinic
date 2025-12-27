-- Update hero_image_url for service_contents from production site
-- Created: 2025-12-27

UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/06/sample.jpg' WHERE slug = 'potenza';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/曽我様エリシスセンス1と3回目-scaled.jpg' WHERE slug = 'ellisys-sense';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/星野様トライフィル2回-scaled.jpg' WHERE slug = 'trifill-pro';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/今村様サブシジョン横版-1-scaled.jpg' WHERE slug = 'subcision';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/07/onda.png' WHERE slug = 'onda-pro';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.27.08-e1751967216775.png' WHERE slug = '%e3%82%aa%e3%83%aa%e3%82%b8%e3%82%aakiss';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/コさんフォトフェイシャル-scaled.jpg' WHERE slug = 'high-intensity-focused-ultrasound';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/ももちゃん糸リフト-1.jpg' WHERE slug = 'thread-lift';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/11/ショッピングリフト吉田さん.jpg' WHERE slug = '%e3%82%b7%e3%83%a7%e3%83%83%e3%83%94%e3%83%b3%e3%82%b0%e3%83%aa%e3%83%95%e3%83%88';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.38.56-e1751967630590.png' WHERE slug = 'hydra-gentle';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/11/下玉梨さん脂肪溶解.jpg' WHERE slug = 'lipodissolve-injection';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/さきさんエラボト-scaled.jpg' WHERE slug = 'botox';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/小山さん唇ヒアル-scaled.jpg' WHERE slug = 'hyaluronic-acid-2';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/10/ローマピンク唇-scaled.jpg' WHERE slug = 'roma-pink';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/11/肌育ジュベリック.jpg' WHERE slug = 'skin-boosting-injection';
UPDATE service_contents SET hero_image_url = 'https://ledianclinic.jp/wp-content/uploads/2025/11/正面四十五度.png' WHERE slug = 'eve-v-muse';

-- Clear the incorrect header-logo.svg URL for services without hero images
UPDATE service_contents SET hero_image_url = NULL WHERE hero_image_url = 'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg';

