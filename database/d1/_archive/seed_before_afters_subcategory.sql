-- ============================================
-- 症例写真 シードデータ（subcategory_id版）
-- ============================================

INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ポテンツァ' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.08.00-1-e1751965946647.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.08.07-1-e1751965963164.png',
    '肌の凹凸が目立ち全体的なハリ不足が目立つ',
    NULL,
    NULL,
    3,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ポテンツァ' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.07.14-1-e1751965908337.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.07.22-1-e1751965926436.png',
    '肌の凹凸が目立ち全体的なハリ不足が目立つ',
    NULL,
    NULL,
    3,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'エリシスセンス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/曽我様エリシスセンス1と3回目-scaled.jpg',
    '【医療内容】治療名：エリシスセンス極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。これによりコラーゲン生成が促進され、肌の再生を促します。使用薬剤：エクソソーム【治療期間・回数】2回',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'エリシスセンス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/河本様エリシスセンス2回-1-scaled.jpg',
    '【医療内容】治療名：エリシスセンス極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。これによりコラーゲン生成が促進され、肌の再生を促します。使用薬剤：ジュベルック【治療期間・回数】2回',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'エリシスセンス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/高山様エリシスセンス2回-scaled.jpg',
    '【医療内容】治療名：エリシスセンス極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。これによりコラーゲン生成が促進され、肌の再生を促します。使用薬剤：スキンボトックス、リジェバン【治療',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'トライフィルプロ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/星野様トライフィル2回-scaled.jpg',
    '【医療内容】治療名：トライフィルプロ極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。針から薬剤を直接注入するドラッ',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'トライフィルプロ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/中島様トライフィル3回-1-scaled.jpg',
    '【医療内容】治療名：トライフィルプロ極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。針から薬剤を直接注入するドラッ',
    NULL,
    NULL,
    3,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'トライフィルプロ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/落合様トライフィル3回-1-scaled.jpg',
    '【医療内容】治療名：トライフィルプロ極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。針から薬剤を直接注入するドラッ',
    NULL,
    NULL,
    3,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'トライフィルプロ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/田中様トライフィル2回-1-scaled.jpg',
    '【医療内容】治療名：トライフィルプロ極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。針から薬剤を直接注入するドラッ',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'サブシジョン' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/今村様サブシジョン横版-1-scaled.jpg',
    '【医療内容】治療名：サブシジョンニキビ跡などのへこんだ傷跡（瘢痕）を改善する治療。針を使って傷跡の下の組織を切り離し、皮膚を持ち上げることでへこみをなくします。頬とこめかみへのサブシジョン後、ニューラ',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'サブシジョン' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/12/今村様サブシジョン2回目.jpg',
    '【医療内容】治療名：サブシジョンニキビ跡などのへこんだ傷跡（瘢痕）を改善する治療。針を使って傷跡の下の組織を切り離し、皮膚を持ち上げることでへこみをなくします。頬とこめかみへのサブシジョン後、ニューラ',
    NULL,
    NULL,
    2,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'オンダリフト' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/オンダプロ腕-scaled.jpg',
    '【治療内容】イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解二の腕・お腹・太もも・背中など、気になる部分の部分痩せやボディラインの引き締めに効果的脂肪の減少と同時',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'オンダリフト' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/さきさんオンダプロ-scaled.jpg',
    '【治療内容】イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解顔の脂肪（フェイスライン、二重あごなど）を減らしながら、肌の引き締め・ハリ改善を同時に行う痛みやダウン',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'オリジオkiss' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.29.21-e1751967166516.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.29.49-e1751967041273.png',
    'オリジオKISS施術前',
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'オリジオkiss' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.27.08-e1751967216775.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.27.16-e1751967238295.png',
    'オリジオKISS施術前',
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ハイフ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/コさんフォトフェイシャル-scaled.jpg',
    '【医療内容】高密度焦点式超音波（HIFU）を皮膚の深部（SMAS層・真皮層）に照射し、熱エネルギーによって組織を引き締め、たるみの改善やフェイスラインの引き締めを目的とする医療機器施術です。メスを使わ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '糸リフト-麻酔込み' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ももちゃん糸リフト-1.jpg',
    '【治療内容】特殊な糸を皮下に入れ、たるみを引き上げる治療コラーゲン生成を促し、肌のハリを改善局所麻酔を使用【期間・回数】1回【費用】4本／198,000円【リスク・副作用】一時的な症状（数日～1週間で',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '糸リフト-麻酔込み' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/かもさんコラ画像-scaled.jpg',
    '【治療内容】特殊な糸を皮下に入れ、たるみを引き上げる治療コラーゲン生成を促し、肌のハリを改善局所麻酔を使用【期間・回数】1回【費用】4本／198,000円【リスク・副作用】一時的な症状（数日～1週間で',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '糸リフト-麻酔込み' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/高橋様糸リフト-scaled.jpg',
    '【治療内容】特殊な糸を皮下に入れ、たるみを引き上げる治療コラーゲン生成を促し、肌のハリを改善局所麻酔を使用【期間・回数】1回【費用】4本／198,000円【リスク・副作用】一時的な症状（数日～1週間で',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '糸リフト-麻酔込み' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/12/かぐみ様糸リフト3本ずつ.jpg',
    '【治療内容】特殊な糸を皮下に入れ、たるみを引き上げる治療コラーゲン生成を促し、肌のハリを改善局所麻酔を使用【期間・回数】1回【費用】6本／275,000円【リスク・副作用】一時的な症状（数日～1週間で',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ショッピングリフト' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/ショッピングリフト吉田さん.jpg',
    '【医療内容】美容鍼のように極細の短い糸を皮下に数十本挿入し、肌質の改善を目指す治療です。網目状に入れた糸が皮膚の土台となり、その刺激でコラーゲン生成を強力に促進。【治療期間・回数】1回【費用】1回(2',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ハイドラジェントル' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.38.56-e1751967630590.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.39.03-e1751967605960.png',
    'ハイドラジェントル施術前',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'カベリン' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/下玉梨さん脂肪溶解.jpg',
    '【医療内容】脂肪溶解注射は、メスを使わずに気になる部分の脂肪を減らす痩身術です。脂肪を溶かす成分を直接皮下脂肪に注入し、脂肪細胞を破壊・溶解。使用薬剤：カベリン【治療期間・回数】1回【費用】1回(8c',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国社製ボトックス-ボツラックス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/さきさんエラボト-scaled.jpg',
    '【医療内容】表情筋の動きを和らげて、シワの改善や小顔効果を目的とした注射治療使用製剤：韓国製ボトックス特徴：ナチュラルな仕上がりで、コスパが良く人気【治療期間・回数】1回【費用】エラ 16,500円（',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国社製ボトックス-ボツラックス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ここなちゃん肩ボト-scaled.jpg',
    '【医療内容】肩の筋肉（僧帽筋）にボトックスを注入し、肩こりの緩和や華奢な肩ライン(肩痩せ)を目指す施術使用製剤：韓国製ボトックス 両側50単位使用特徴：コスパが良く、自然な仕上がりで人気【治療期間・回',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国社製ボトックス-ボツラックス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/小森さんスキンボト.jpg',
    '【医療内容】ボトックス製剤を薄めて、皮膚の浅い層に細かく注射します。肌のハリ、小じわ、毛穴の引き締め、皮脂分泌抑制の改善が期待できます。使用薬剤：韓国社製ボトックス マイクロボトックス【治療期間・回数',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国社製ボトックス-ボツラックス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/12/ここなちゃん肩ボト1ヶ月後.jpg',
    '【医療内容】肩の筋肉（僧帽筋）にボトックスを注入し、肩こりの緩和や華奢な肩ライン(肩痩せ)を目指す施術使用製剤：韓国製ボトックス 両側50単位使用特徴：コスパが良く、自然な仕上がりで人気【治療期間・回',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/小山さん唇ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/上原さん頬ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：アラガン社製ヒアルロン酸（ジュビダームビスタ)特徴：高い安全性と持続性、なめらかな仕上がりが特長',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/下玉梨さん顎ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/だいあさん顎ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/だいあさん目ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/すがぬまさん涙袋ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/おまみさん顎ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/おまみさん頬ほうれい線ヒアル-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/山本さん顎ヒアル-1-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = '韓国製ヒアルニューラミス' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ことみさん顎ヒアルロン-1-scaled.jpg',
    '【医療内容】ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術使用製剤：ニューラミス（韓国製）特徴：リフティング効果・持続性・コスパに優れている【治療期間・回数】1回 ',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ローマピンク' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ローマピンク唇-scaled.jpg',
    '【医療内容】ローマピンクは、医療機関専用の低刺激ピーリング剤。角質の除去と美白・毛穴改善・ハリ感アップを目的とする。【治療期間・回数】1回【費用】唇 165,000円（税込）【リスク・副作用】一時的に',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'ローマピンク' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ローマピンク胸元-scaled.jpg',
    '【医療内容】ローマピンクは、医療機関専用の低刺激ピーリング剤。角質の除去と美白・毛穴改善・ハリ感アップを目的とする。【治療期間・回数】1回【費用】乳輪 220,000円（税込）【リスク・副作用】一時的',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'スキンバイブ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/肌育ジュベリック.jpg',
    '【医療内容】治療名：肌育注射ジュベルックは、 肌のコラーゲン生成を促進させ、ハリ・弾力改善、小じわ・毛穴の改善する注射医療です。極細の針を使って、真皮層に直接薬剤を注入します。使用薬剤：ジュベルック【',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    (SELECT id FROM subcategories WHERE slug = 'スキンバイブ' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/肌育リジュラン中村.jpg',
    '【医療内容】治療名：肌育注射リジュランヒーラーは、サーモン由来のポリヌクレオチド（PN）を主成分とする注射治療で、肌細胞の再生を促進し、肌本来の若々しさを引き出すことを目指します。肌のハリ・弾力、潤い',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);