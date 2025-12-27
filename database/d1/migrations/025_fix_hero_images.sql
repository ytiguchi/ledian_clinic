-- 本番サイトから正確に抽出したヒーロー画像情報でDBを更新
-- 実際にヒーロー画像があるサービス: potenza, onda-pro, eve-v-muse の3つのみ

-- ヒーロー画像があるサービス - ローカルパスに更新
UPDATE service_contents SET hero_image_url = '/images/service/potenza-hero.jpg' WHERE slug = 'potenza';
UPDATE service_contents SET hero_image_url = '/images/service/onda-pro-hero.png' WHERE slug = 'onda-pro';
UPDATE service_contents SET hero_image_url = '/images/service/eve-v-muse-hero.png' WHERE slug = 'eve-v-muse';

-- ヒーロー画像がないサービス - NULLに設定
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'ellisys-sense';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'trifill-pro';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'subcision';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'オリジオkiss';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'high-intensity-focused-ultrasound';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'thread-lift';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'ショッピングリフト';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'hydra-gentle';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'massage-peel';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'milano-repeel';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'manuka-peel';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'lhala-doctor';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'jalupro-glowpeel';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'v-carbon-peel';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'stella-m22';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'pico-laser';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'lipodissolve-injection';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'botox';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'hyaluronic-acid-2';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'carecys';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'lhala-10-ldm';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'roma-pink';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'permanent-makeup';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'soprano-ice-platinum';
UPDATE service_contents SET hero_image_url = NULL WHERE slug = 'skin-boosting-injection';

