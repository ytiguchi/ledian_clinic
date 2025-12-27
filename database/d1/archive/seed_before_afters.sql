-- ============================================
-- 症例写真 シードデータ
-- 生成日時: 2025-12-26 15:44:12
-- Before/After: 5件
-- 単体画像: 36件
-- 合計: 41件
-- ============================================

-- 注意: treatment_id は実際のDBのIDに置き換える必要があります
-- subcategory_id を使用する場合はカラム名を変更してください

-- ポテンツァ (potenza) - B/A:2件, 単体:0件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '8d55408709c41aae',
    (SELECT id FROM subcategories WHERE slug = 'potenza' LIMIT 1),
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
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'fb49d2c986ebbb22',
    (SELECT id FROM subcategories WHERE slug = 'potenza' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.07.14-1-e1751965908337.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.07.22-1-e1751965926436.png',
    '肌の凹凸が目立ち全体的なハリ不足が目立つ',
    NULL,
    NULL,
    3,
    NULL,
    1,
    1
);

-- エリシスセンス (ellisys-sense) - B/A:0件, 単体:3件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '4a7a62d47ff06ae9',
    (SELECT id FROM subcategories WHERE slug = 'ellisys-sense' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/曽我様エリシスセンス1と3回目-scaled.jpg',
    '【医療内容】    治療名：エリシスセンス   極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。   これによりコラーゲン生成が促進され、肌の再生を促します。   使用薬剤：エクソソーム        【治療期間・回数】    2回      【費用】    25PIN／63,800円   エクソソーム／33,000円        【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '0191369fe49f20a3',
    (SELECT id FROM subcategories WHERE slug = 'ellisys-sense' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/河本様エリシスセンス2回-1-scaled.jpg',
    '【医療内容】    治療名：エリシスセンス   極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。   これによりコラーゲン生成が促進され、肌の再生を促します。   使用薬剤：ジュベルック        【治療期間・回数】    2回      【費用】    49PIN／70,400円   ジュベルック／33,000円        【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    1
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '9627a6395238e39e',
    (SELECT id FROM subcategories WHERE slug = 'ellisys-sense' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/高山様エリシスセンス2回-scaled.jpg',
    '【医療内容】    治療名：エリシスセンス   極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。   これによりコラーゲン生成が促進され、肌の再生を促します。   使用薬剤：スキンボトックス、リジェバン        【治療期間・回数】    2回      【費用】    49PIN／70,400円   スキンボトックス／16,500円   リジェバン／23,100円      【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    2
);

-- トライフィルプロ (trifill-pro) - B/A:0件, 単体:4件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '1d00fbfd74579f07',
    (SELECT id FROM subcategories WHERE slug = 'trifill-pro' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/星野様トライフィル2回-scaled.jpg',
    '【医療内容】    治療名：トライフィルプロ   極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。   これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。   針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。   使用薬剤：ジュベルック        【治療期間・回数】    2回        【費用】   額こめかみ／88,000円   ジュベルック／33,000円        【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'a2a3af7542426147',
    (SELECT id FROM subcategories WHERE slug = 'trifill-pro' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/中島様トライフィル3回-1-scaled.jpg',
    '【医療内容】    治療名：トライフィルプロ   極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。   これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。   針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。   使用薬剤：ジュベルック        【治療期間・回数】    3回        【費用】   額こめかみ／118,800円   ジュベルック／49,500円        【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    3,
    '1週間',
    1,
    1
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '9ca6babf705f7128',
    (SELECT id FROM subcategories WHERE slug = 'trifill-pro' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/落合様トライフィル3回-1-scaled.jpg',
    '【医療内容】    治療名：トライフィルプロ   極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。   これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。   針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。   使用薬剤：ジュベルック        【治療期間・回数】    3回        【費用】   額こめかみ／118,800円   ジュベルック／49,500円        【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    3,
    '1週間',
    1,
    2
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'b442c9ae3ab3e88c',
    (SELECT id FROM subcategories WHERE slug = 'trifill-pro' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/田中様トライフィル2回-1-scaled.jpg',
    '【医療内容】    治療名：トライフィルプロ   極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。   これによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。   針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。   使用薬剤：ジュベルック        【治療期間・回数】    2回        【費用】   額こめかみ／88,000円   ジュベルック／33,000円        【リスク・副作用】    一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。   まれなもの: 乾燥、ごわつき、色素沈着、感染。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    2,
    '1週間',
    1,
    3
);

-- サブシジョン (subcision) - B/A:0件, 単体:2件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '6d8fd9dcf39308e2',
    (SELECT id FROM subcategories WHERE slug = 'subcision' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/今村様サブシジョン横版-1-scaled.jpg',
    '【医療内容】   治療名：サブシジョン   ニキビ跡などのへこんだ傷跡（瘢痕）を改善する治療。   針を使って傷跡の下の組織を切り離し、皮膚を持ち上げることでへこみをなくします。   頬とこめかみへのサブシジョン後、ニューラミスヒアルロン酸を注入し、さらに皮膚のボリュームアップと平坦化を図ります。        【治療期間・回数】    1回        【費用】    中範囲／59,400円   ヒアルロン酸ニューラミス 2cc／6,6000円        【リスク・副作用】    一般的なもの: 内出血、腫れ、痛み（一時的）。   まれなもの: 感染、色素沈着、傷跡の悪化、神経損傷。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '1699b407e1e9ef21',
    (SELECT id FROM subcategories WHERE slug = 'subcision' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/12/今村様サブシジョン2回目.jpg',
    '【医療内容】   治療名：サブシジョン   ニキビ跡などのへこんだ傷跡（瘢痕）を改善する治療。   針を使って傷跡の下の組織を切り離し、皮膚を持ち上げることでへこみをなくします。   頬とこめかみへのサブシジョン後、ニューラミスヒアルロン酸を注入し、さらに皮膚のボリュームアップと平坦化を図ります。        【治療期間・回数】    2回目        【費用】    中範囲／59,400円   ヒアルロン酸ニューラミス 2cc／6,6000円        【リスク・副作用】    一般的なもの: 内出血、腫れ、痛み（一時的）。   まれなもの: 感染、色素沈着、傷跡の悪化、神経損傷。   効果には個人差があり、複数回の治療が必要な場合もあります。',
    NULL,
    NULL,
    2,
    NULL,
    1,
    1
);

-- オンダプロ (onda-pro) - B/A:0件, 単体:2件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'c1ab3b67068c3d1e',
    (SELECT id FROM subcategories WHERE slug = 'onda-pro' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/オンダプロ腕-scaled.jpg',
    '【治療内容】  イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解  二の腕・お腹・太もも・背中など、気になる部分の部分痩せやボディラインの引き締めに効果的  脂肪の減少と同時に、肌のハリ改善やセルライトの軽減も期待できる  痛み・ダウンタイムが少なく、直後から日常生活OK     【期間・回数】  1回　体用ハンドピース(ディープ)使用    【費用】  1回 税込36,300円     【リスク・副作用】  一時的な赤み、熱感、むくみ、筋肉痛のような違和感  稀に火傷や色素沈着  効果には個人差あり',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'b852295d1d99baff',
    (SELECT id FROM subcategories WHERE slug = 'onda-pro' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/さきさんオンダプロ-scaled.jpg',
    '【治療内容】  イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解  顔の脂肪（フェイスライン、二重あごなど）を減らしながら、肌の引き締め・ハリ改善を同時に行う  痛みやダウンタイムが少なく、施術直後からメイク可能     【期間・回数】  1回 両頬+顎下セット    【費用】  1回 税込44,000円     【リスク・副作用】  一時的な赤み、熱感、むくみ、筋肉痛のような違和感  軽い筋肉痛や熱感（数時間〜数日で軽快）  稀に火傷や色素沈着  効果には個人差あり',
    NULL,
    NULL,
    1,
    NULL,
    1,
    1
);

-- オリジオKISS (origio-kiss) - B/A:2件, 単体:0件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'b87748e383ab027d',
    (SELECT id FROM subcategories WHERE slug = 'origio-kiss' LIMIT 1),
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
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'f8e3d9e3ca91262a',
    (SELECT id FROM subcategories WHERE slug = 'origio-kiss' LIMIT 1),
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.27.08-e1751967216775.png',
    'https://ledianclinic.jp/wp-content/uploads/2025/07/スクリーンショット-2025-07-08-18.27.16-e1751967238295.png',
    'オリジオKISS施術前',
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    1
);

-- HIFU ウルトラセルZi (high-intensity-focused-ultrasound) - B/A:0件, 単体:1件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'c43f6cb0ba813e4e',
    (SELECT id FROM subcategories WHERE slug = 'high-intensity-focused-ultrasound' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/コさんフォトフェイシャル-scaled.jpg',
    '【医療内容】  高密度焦点式超音波（HIFU）を皮膚の深部（SMAS層・真皮層）に照射し、熱エネルギーによって組織を引き締め、たるみの改善やフェイスラインの引き締めを目的とする医療機器施術です。  メスを使わず、皮膚表面へのダメージを抑えながらリフトアップを目指します。     【治療期間・回数】   1回     【費用】   1回(200SHOT)／22,000円     【リスク・副作用】  一般的なもの:赤み、腫れ、むくみ、筋肉痛のような痛み、押したときの鈍痛 ※多くは数日〜1週間程度で自然に軽快します。  まれなもの:内出血、しびれ、知覚鈍麻、神経障害、脂肪萎縮  ※効果・感じ方には個人差があります。',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);

-- 糸リフト (thread-lift) - B/A:0件, 単体:4件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '3ec047b5d141bf27',
    (SELECT id FROM subcategories WHERE slug = 'thread-lift' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ももちゃん糸リフト-1.jpg',
    '【治療内容】  特殊な糸を皮下に入れ、たるみを引き上げる治療  コラーゲン生成を促し、肌のハリを改善  局所麻酔を使用    【期間・回数】  1回    【費用】  4本／198,000円    【リスク・副作用】  一時的な症状（数日～1週間で改善）  腫れ、内出血、痛み  ひきつれ感、ツッパリ感   稀に起こる可能性  凹凸、左右差  感染、糸の露出、アレルギー',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'abae1639f214905c',
    (SELECT id FROM subcategories WHERE slug = 'thread-lift' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/かもさんコラ画像-scaled.jpg',
    '【治療内容】  特殊な糸を皮下に入れ、たるみを引き上げる治療  コラーゲン生成を促し、肌のハリを改善  局所麻酔を使用    【期間・回数】  1回    【費用】  4本／198,000円    【リスク・副作用】  一時的な症状（数日～1週間で改善）  腫れ、内出血、痛み  ひきつれ感、ツッパリ感   稀に起こる可能性  凹凸、左右差  感染、糸の露出、アレルギー',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    1
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'efb53130b1bafcb2',
    (SELECT id FROM subcategories WHERE slug = 'thread-lift' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/高橋様糸リフト-scaled.jpg',
    '【治療内容】  特殊な糸を皮下に入れ、たるみを引き上げる治療  コラーゲン生成を促し、肌のハリを改善  局所麻酔を使用    【期間・回数】  1回    【費用】  4本／198,000円    【リスク・副作用】  一時的な症状（数日～1週間で改善）  腫れ、内出血、痛み  ひきつれ感、ツッパリ感   稀に起こる可能性  凹凸、左右差  感染、糸の露出、アレルギー',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    2
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'd1162c601dc9c780',
    (SELECT id FROM subcategories WHERE slug = 'thread-lift' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/12/かぐみ様糸リフト3本ずつ.jpg',
    '【治療内容】  特殊な糸を皮下に入れ、たるみを引き上げる治療  コラーゲン生成を促し、肌のハリを改善  局所麻酔を使用    【期間・回数】  1回    【費用】  6本／275,000円    【リスク・副作用】  一時的な症状（数日～1週間で改善）  腫れ、内出血、痛み  ひきつれ感、ツッパリ感   稀に起こる可能性  凹凸、左右差  感染、糸の露出、アレルギー',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    3
);

-- ショッピングリフト (shopping-lift) - B/A:0件, 単体:1件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'a41a8c1eb6e676fc',
    (SELECT id FROM subcategories WHERE slug = 'shopping-lift' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/ショッピングリフト吉田さん.jpg',
    '【医療内容】  美容鍼のように極細の短い糸を皮下に数十本挿入し、肌質の改善を目指す治療です。  網目状に入れた糸が皮膚の土台となり、その刺激でコラーゲン生成を強力に促進。     【治療期間・回数】   1回     【費用】   1回(20本)／76,780円     【リスク・副作用】  一般的なもの：内出血、腫れ、痛み、引きつれ感  まれなもの：感染、アレルギー、左右差、糸の露出',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);

-- ハイドラジェントル (hydra-gentle) - B/A:1件, 単体:0件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '49f2957f72bf3104',
    (SELECT id FROM subcategories WHERE slug = 'hydra-gentle' LIMIT 1),
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

-- 脂肪溶解注射 (lipodissolve-injection) - B/A:0件, 単体:1件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '4411aa2696d3a68e',
    (SELECT id FROM subcategories WHERE slug = 'lipodissolve-injection' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/下玉梨さん脂肪溶解.jpg',
    '【医療内容】   脂肪溶解注射は、メスを使わずに気になる部分の脂肪を減らす痩身術です。  脂肪を溶かす成分を直接皮下脂肪に注入し、脂肪細胞を破壊・溶解。  使用薬剤：カベリン     【治療期間・回数】   1回     【費用】   1回(8cc)／31,680円     【リスク・副作用】  一般的なもの：内出血、腫れ、痛み、熱感、かゆみ  まれなもの：色素沈着、しこり、硬結、感染、アレルギー反応',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);

-- ボトックス (botox) - B/A:0件, 単体:4件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'be7f12da4ee5b764',
    (SELECT id FROM subcategories WHERE slug = 'botox' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/さきさんエラボト-scaled.jpg',
    '【医療内容】  表情筋の動きを和らげて、シワの改善や小顔効果を目的とした注射治療  使用製剤：韓国製ボトックス  特徴：ナチュラルな仕上がりで、コスパが良く人気     【治療期間・回数】  1回      【費用】  エラ 16,500円（税込）     【リスク・副作用】  一時的な赤み・腫れ・内出血・痛みが出ることがあります（数日で改善）  稀に左右差・表情のこわばり・頭痛・違和感などが生じる場合あり  効果は一時的で、時間の経過とともに自然に元に戻ります',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '3be7a0e5e2b5a056',
    (SELECT id FROM subcategories WHERE slug = 'botox' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ここなちゃん肩ボト-scaled.jpg',
    '【医療内容】  肩の筋肉（僧帽筋）にボトックスを注入し、肩こりの緩和や華奢な肩ライン(肩痩せ)を目指す施術  使用製剤：韓国製ボトックス 両側50単位使用  特徴：コスパが良く、自然な仕上がりで人気     【治療期間・回数】  1回      【費用】  肩 16,500円（税込）     【リスク・副作用】  一時的な赤み・腫れ・内出血・痛み（数日で改善）  稀に肩のだるさ・重さ・筋力低下を感じる場合あり  効果は時間とともに自然に元に戻ります',
    NULL,
    NULL,
    1,
    NULL,
    1,
    1
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'a5d73af624fdf5a9',
    (SELECT id FROM subcategories WHERE slug = 'botox' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/小森さんスキンボト.jpg',
    '【医療内容】  ボトックス製剤を薄めて、皮膚の浅い層に細かく注射します。   肌のハリ、小じわ、毛穴の引き締め、皮脂分泌抑制の改善が期待できます。  使用薬剤：韓国社製ボトックス マイクロボトックス     【治療期間・回数】   1回     【費用】   鼻／24,200円     【リスク・副作用】   一般的なもの: 内出血、腫れ、痛みが注入後に一時的に現れることがあります。  まれなもの: 感染、アレルギー、表情の変化。非常に稀ですが、注意が必要です。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    2
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '07d8285ebf732951',
    (SELECT id FROM subcategories WHERE slug = 'botox' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/12/ここなちゃん肩ボト1ヶ月後.jpg',
    '【医療内容】  肩の筋肉（僧帽筋）にボトックスを注入し、肩こりの緩和や華奢な肩ライン(肩痩せ)を目指す施術  使用製剤：韓国製ボトックス 両側50単位使用  特徴：コスパが良く、自然な仕上がりで人気     【治療期間・回数】  1回      【費用】  肩 16,500円（税込）     【リスク・副作用】  一時的な赤み・腫れ・内出血・痛み（数日で改善）  稀に肩のだるさ・重さ・筋力低下を感じる場合あり  効果は時間とともに自然に元に戻ります',
    NULL,
    NULL,
    1,
    NULL,
    1,
    3
);

-- ヒアルロン酸 (hyaluronic-acid-2) - B/A:0件, 単体:10件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'd927a9600a77dbdc',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/小山さん唇ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 0.5cc 唇     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '2b8fa5aae41e250a',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/上原さん頬ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：アラガン社製ヒアルロン酸（ジュビダームビスタ)  特徴：高い安全性と持続性、なめらかな仕上がりが特長     【治療期間・回数】  1回 2cc 頬     【費用】  1ccあたり 66,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    1
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '5c320c214ed8641a',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/下玉梨さん顎ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 1cc 顎     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    2
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '5015e96fcf4f1c9e',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/だいあさん顎ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 1cc 顎     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    3
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'cb4f12e63c64f9a0',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/だいあさん目ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 0.5cc 涙袋     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    4
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'f50841ef02f6cabb',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/すがぬまさん涙袋ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 0.2cc 涙袋     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    5
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'b9835ad3f1559f13',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/おまみさん顎ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 0.5cc 顎     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    6
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    'a240ceda51918840',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/おまみさん頬ほうれい線ヒアル-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 0.8cc ほうれい線  2cc 頬     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    7
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '7fe42db53b2c4b9b',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/山本さん顎ヒアル-1-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 1cc 顎     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    8
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '1e9b3fdb7af63ea4',
    (SELECT id FROM subcategories WHERE slug = 'hyaluronic-acid-2' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ことみさん顎ヒアルロン-1-scaled.jpg',
    '【医療内容】  ヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術  使用製剤：ニューラミス（韓国製）  特徴：リフティング効果・持続性・コスパに優れている     【治療期間・回数】  1回 1cc 顎     【費用】  1ccあたり 33,000円（税込）     【リスク・副作用】  一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）  稀にしこり・凹凸・アレルギー反応・感染の可能性  ごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
    NULL,
    NULL,
    1,
    '1週間',
    1,
    9
);

-- ローマピンク (roma-pink) - B/A:0件, 単体:2件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '7258ac9ee1c99947',
    (SELECT id FROM subcategories WHERE slug = 'roma-pink' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ローマピンク唇-scaled.jpg',
    '【医療内容】  ローマピンクは、医療機関専用の低刺激ピーリング剤。  角質の除去と美白・毛穴改善・ハリ感アップを目的とする。     【治療期間・回数】  1回     【費用】  唇 165,000円（税込）     【リスク・副作用】  一時的に赤み・乾燥・軽いヒリつきが生じる場合があります。  まれに皮むけ・かゆみ・色素沈着が起こることがあります。  日焼け直後や炎症のある肌への施術は控える必要があります。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '61043783eaae12bf',
    (SELECT id FROM subcategories WHERE slug = 'roma-pink' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/10/ローマピンク胸元-scaled.jpg',
    '【医療内容】  ローマピンクは、医療機関専用の低刺激ピーリング剤。  角質の除去と美白・毛穴改善・ハリ感アップを目的とする。     【治療期間・回数】  1回     【費用】  乳輪 220,000円（税込）     【リスク・副作用】  一時的に赤み・乾燥・軽いヒリつきが生じる場合があります。  まれに皮むけ・かゆみ・色素沈着が起こることがあります。  日焼け直後や炎症のある肌への施術は控える必要があります。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    1
);

-- 肌育注射 (skin-boosting-injection) - B/A:0件, 単体:2件
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '5eed7193931393da',
    (SELECT id FROM subcategories WHERE slug = 'skin-boosting-injection' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/肌育ジュベリック.jpg',
    '【医療内容】   治療名：肌育注射  ジュベルックは、 肌のコラーゲン生成を促進させ、ハリ・弾力改善、小じわ・毛穴の改善する注射医療です。  極細の針を使って、真皮層に直接薬剤を注入します。  使用薬剤：ジュベルック     【治療期間・回数】   1回     【費用】   1回(4cc)／55,000円     【リスク・副作用】   一般的なもの: 内出血、腫れ、痛みが注入後に一時的に現れることがあります。  まれなもの: しこり、稀に注入部位に小さな硬い部分ができることがあります。  感染、アレルギー。非常に稀ですが、注意が必要です。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);
INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '0ac10e2962189c70',
    (SELECT id FROM subcategories WHERE slug = 'skin-boosting-injection' LIMIT 1),
    '',
    'https://ledianclinic.jp/wp-content/uploads/2025/11/肌育リジュラン中村.jpg',
    '【医療内容】   治療名：肌育注射  リジュランヒーラーは、サーモン由来のポリヌクレオチド（PN）を主成分とする注射治療で、肌細胞の再生を促進し、肌本来の若々しさを引き出すことを目指します。  肌のハリ・弾力、潤い、小じわ、毛穴、くすみの改善が期待できます。  使用薬剤：リジュランヒーラー     【治療期間・回数】   1回     【費用】   1回(4cc)／66,000円     【リスク・副作用】   一般的なもの: 内出血、腫れ、痛みが注入後に一時的に現れることがあります。  注射部位の軽い盛り上がりが注入直後に一時的に見られることがあります。 まれなもの: 感染、アレルギー。非常に稀ですが、注意が必要です。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    1
);
