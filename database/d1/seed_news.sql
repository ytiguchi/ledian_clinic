-- Seed news/campaigns data from production site
-- Each item is categorized as: 'campaign', 'new_service', or 'news'

INSERT OR REPLACE INTO campaigns (id, title, slug, description, start_date, is_published, campaign_type) VALUES
-- 新サービス (new_service)
('news-001', '肌診断機Eve V MUSE', 'eve-v-muse', '最新の肌診断機を導入しました', '2025-12-25', 1, 'new_service'),
('news-002', 'アートメイク発売しました', 'artmake', 'アートメイクサービスを開始', '2025-12-01', 1, 'new_service'),
('news-003', '【美容医療院だからできる！】ララドクター', 'lhala-doctor', 'ララドクターサービスのご案内', '2025-08-21', 1, 'new_service'),
('news-004', '糸リフト', 'ito', '糸リフト施術を開始しました', '2025-07-22', 1, 'new_service'),
('news-005', '脂肪溶解注射', 'shibouyoukai', '脂肪溶解注射のご案内', '2025-06-07', 1, 'new_service'),
('news-006', 'ヒアルロン酸注入', 'hyaluronicacid', 'ヒアルロン酸注入を開始', '2025-05-29', 1, 'new_service'),
('news-007', 'ピコトーニングスタートしました♡', 'picotoning', 'ピコトーニングのご案内', '2025-05-08', 1, 'new_service'),
('news-008', 'ボトックス始動！', 'botox', 'ボトックス注射を開始', '2025-05-01', 1, 'new_service'),
('news-009', 'ポテンツァの進化版！！エリシスセンス', 'ellisyssense', 'エリシスセンスのご案内', '2025-04-25', 1, 'new_service'),
('news-010', 'リベルサスとマンジャロの提供をはじめました', 'medicaldiet', 'メディカルダイエット薬のご案内', '2024-12-23', 1, 'new_service'),
('news-011', 'リベルサスのご紹介', 'rybelsus', 'リベルサスについて', '2024-10-01', 1, 'new_service'),

-- キャンペーン (campaign)
('news-012', '友だち紹介キャンペーン', 'friend', 'お友達をご紹介いただくとお得な特典', '2025-12-12', 1, 'campaign'),
('news-013', 'HolidayCampaign', 'holidaycampaign', '年末年始の特別キャンペーン', '2025-12-10', 1, 'campaign'),

-- お知らせ (news)
('news-014', 'トリビューの掲載', 'tribyu', 'トリビューに掲載されました', '2025-11-17', 1, 'news'),
('news-015', '[重要]キャンセルポリシーの改定と予約キャンセルに関するお願い', 'cancel', 'キャンセルポリシー改定のお知らせ', '2025-05-19', 1, 'news');

