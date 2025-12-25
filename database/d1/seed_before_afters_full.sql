-- 既存データを削除
DELETE FROM treatment_before_afters;

-- 症例写真を挿入（フルキャプション）
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
    '【医療内容】\n \n 治療名：エリシスセンス\n \n極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。\n \nこれによりコラーゲン生成が促進され、肌の再生を促します。\n \n使用薬剤：エクソソーム\n \n\n \n \n【治療期間・回数】\n \n 2回\n\n \n \n【費用】\n \n 25PIN／63,800円\n \nエクソソーム／33,000円\n \n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】\n \n 治療名：エリシスセンス\n \n極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。\n \nこれによりコラーゲン生成が促進され、肌の再生を促します。\n \n使用薬剤：ジュベルック\n \n\n \n \n【治療期間・回数】\n \n 2回\n\n \n \n【費用】\n \n 49PIN／70,400円\n \nジュベルック／33,000円\n \n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】\n \n 治療名：エリシスセンス\n \n極細の針で皮膚に穴を開け、同時に高周波エネルギーを真皮に届けます。\n \nこれによりコラーゲン生成が促進され、肌の再生を促します。\n \n使用薬剤：スキンボトックス、リジェバン\n \n\n \n \n【治療期間・回数】\n \n 2回\n\n \n \n【費用】\n \n 49PIN／70,400円\n \nスキンボトックス／16,500円\n \nリジェバン／23,100円\n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】 \n \n治療名：トライフィルプロ\n \n極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。\n \nこれによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。\n \n針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。\n \n使用薬剤：ジュベルック\n \n\n \n \n【治療期間・回数】\n  \n2回\n \n\n \n \n【費用】\n \n額こめかみ／88,000円\n \nジュベルック／33,000円\n \n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】 \n \n治療名：トライフィルプロ\n \n極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。\n \nこれによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。\n \n針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。\n \n使用薬剤：ジュベルック\n \n\n \n \n【治療期間・回数】\n  \n3回\n \n\n \n \n【費用】\n \n額こめかみ／118,800円\n \nジュベルック／49,500円\n \n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】 \n \n治療名：トライフィルプロ\n \n極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。\n \nこれによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。\n \n針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。\n \n使用薬剤：ジュベルック\n \n\n \n \n【治療期間・回数】\n  \n3回\n \n\n \n \n【費用】\n \n額こめかみ／118,800円\n \nジュベルック／49,500円\n \n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】 \n \n治療名：トライフィルプロ\n \n極細の針を皮膚に刺し、高周波（RF）エネルギーを直接真皮層に届けます。\n \nこれによりコラーゲン生成を促進し、肌の再生と症状改善を図ります。\n \n針から薬剤を直接注入するドラッグデリバリー機能も搭載されており、さらに効果を高めることができます。\n \n使用薬剤：ジュベルック\n \n\n \n \n【治療期間・回数】\n  \n2回\n \n\n \n \n【費用】\n \n額こめかみ／88,000円\n \nジュベルック／33,000円\n \n\n \n \n【リスク・副作用】\n \n 一般的なもの: 赤み、腫れ、内出血、痛み、微細なかさぶた（数日〜1週間程度）。\n \nまれなもの: 乾燥、ごわつき、色素沈着、感染。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】\n \n治療名：サブシジョン\n \nニキビ跡などのへこんだ傷跡（瘢痕）を改善する治療。\n \n針を使って傷跡の下の組織を切り離し、皮膚を持ち上げることでへこみをなくします。\n \n頬とこめかみへのサブシジョン後、ニューラミスヒアルロン酸を注入し、さらに皮膚のボリュームアップと平坦化を図ります。\n \n\n \n \n【治療期間・回数】 \n \n1回\n \n\n \n \n【費用】 \n \n中範囲／59,400円\n \nヒアルロン酸ニューラミス 2cc／6,6000円\n \n\n \n \n【リスク・副作用】 \n \n一般的なもの: 内出血、腫れ、痛み（一時的）。\n \nまれなもの: 感染、色素沈着、傷跡の悪化、神経損傷。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【医療内容】\n \n治療名：サブシジョン\n \nニキビ跡などのへこんだ傷跡（瘢痕）を改善する治療。\n \n針を使って傷跡の下の組織を切り離し、皮膚を持ち上げることでへこみをなくします。\n \n頬とこめかみへのサブシジョン後、ニューラミスヒアルロン酸を注入し、さらに皮膚のボリュームアップと平坦化を図ります。\n \n\n \n \n【治療期間・回数】 \n \n2回目\n \n\n \n \n【費用】 \n \n中範囲／59,400円\n \nヒアルロン酸ニューラミス 2cc／6,6000円\n \n\n \n \n【リスク・副作用】 \n \n一般的なもの: 内出血、腫れ、痛み（一時的）。\n \nまれなもの: 感染、色素沈着、傷跡の悪化、神経損傷。\n \n効果には個人差があり、複数回の治療が必要な場合もあります。',
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
    '【治療内容】\n\nイタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解\n\n二の腕・お腹・太もも・背中など、気になる部分の部分痩せやボディラインの引き締めに効果的\n\n脂肪の減少と同時に、肌のハリ改善やセルライトの軽減も期待できる\n\n痛み・ダウンタイムが少なく、直後から日常生活OK\n\n\n\n\n【期間・回数】\n\n1回　体用ハンドピース(ディープ)使用\n\n\n\n【費用】\n\n1回 税込36,300円\n\n\n\n\n【リスク・副作用】\n\n一時的な赤み、熱感、むくみ、筋肉痛のような違和感\n\n稀に火傷や色素沈着\n\n効果には個人差あり',
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
    '【治療内容】\n\nイタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解\n\n顔の脂肪（フェイスライン、二重あごなど）を減らしながら、肌の引き締め・ハリ改善を同時に行う\n\n痛みやダウンタイムが少なく、施術直後からメイク可能\n\n\n\n\n【期間・回数】\n\n1回 両頬+顎下セット\n\n\n\n【費用】\n\n1回 税込44,000円\n\n\n\n\n【リスク・副作用】\n\n一時的な赤み、熱感、むくみ、筋肉痛のような違和感\n\n軽い筋肉痛や熱感（数時間〜数日で軽快）\n\n稀に火傷や色素沈着\n\n効果には個人差あり',
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
    '【医療内容】\n\n高密度焦点式超音波（HIFU）を皮膚の深部（SMAS層・真皮層）に照射し、熱エネルギーによって組織を引き締め、たるみの改善やフェイスラインの引き締めを目的とする医療機器施術です。\n\nメスを使わず、皮膚表面へのダメージを抑えながらリフトアップを目指します。\n\n\n\n\n【治療期間・回数】 \n\n1回\n\n\n\n\n【費用】 \n\n1回(200SHOT)／22,000円\n\n\n\n\n【リスク・副作用】\n\n一般的なもの:赤み、腫れ、むくみ、筋肉痛のような痛み、押したときの鈍痛 ※多くは数日〜1週間程度で自然に軽快します。\n\nまれなもの:内出血、しびれ、知覚鈍麻、神経障害、脂肪萎縮\n\n※効果・感じ方には個人差があります。',
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
    '【治療内容】\n\n特殊な糸を皮下に入れ、たるみを引き上げる治療\n\nコラーゲン生成を促し、肌のハリを改善\n\n局所麻酔を使用\n\n\n\n【期間・回数】\n\n1回\n\n\n\n【費用】\n\n4本／198,000円\n\n\n\n【リスク・副作用】\n\n一時的な症状（数日～1週間で改善）\n\n腫れ、内出血、痛み\n\nひきつれ感、ツッパリ感\n\n\n稀に起こる可能性\n\n凹凸、左右差\n\n感染、糸の露出、アレルギー',
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
    '【治療内容】\n\n特殊な糸を皮下に入れ、たるみを引き上げる治療\n\nコラーゲン生成を促し、肌のハリを改善\n\n局所麻酔を使用\n\n\n\n【期間・回数】\n\n1回\n\n\n\n【費用】\n\n4本／198,000円\n\n\n\n【リスク・副作用】\n\n一時的な症状（数日～1週間で改善）\n\n腫れ、内出血、痛み\n\nひきつれ感、ツッパリ感\n\n\n稀に起こる可能性\n\n凹凸、左右差\n\n感染、糸の露出、アレルギー',
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
    '【治療内容】\n\n特殊な糸を皮下に入れ、たるみを引き上げる治療\n\nコラーゲン生成を促し、肌のハリを改善\n\n局所麻酔を使用\n\n\n\n【期間・回数】\n\n1回\n\n\n\n【費用】\n\n4本／198,000円\n\n\n\n【リスク・副作用】\n\n一時的な症状（数日～1週間で改善）\n\n腫れ、内出血、痛み\n\nひきつれ感、ツッパリ感\n\n\n稀に起こる可能性\n\n凹凸、左右差\n\n感染、糸の露出、アレルギー',
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
    '【治療内容】\n\n特殊な糸を皮下に入れ、たるみを引き上げる治療\n\nコラーゲン生成を促し、肌のハリを改善\n\n局所麻酔を使用\n\n\n\n【期間・回数】\n\n1回\n\n\n\n【費用】\n\n6本／275,000円\n\n\n\n【リスク・副作用】\n\n一時的な症状（数日～1週間で改善）\n\n腫れ、内出血、痛み\n\nひきつれ感、ツッパリ感\n\n\n稀に起こる可能性\n\n凹凸、左右差\n\n感染、糸の露出、アレルギー',
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
    '【医療内容】\n\n美容鍼のように極細の短い糸を皮下に数十本挿入し、肌質の改善を目指す治療です。\n\n網目状に入れた糸が皮膚の土台となり、その刺激でコラーゲン生成を強力に促進。\n\n\n\n\n【治療期間・回数】\n\n 1回\n\n\n\n\n【費用】\n\n 1回(20本)／76,780円\n\n\n\n\n【リスク・副作用】\n\n一般的なもの：内出血、腫れ、痛み、引きつれ感\n\nまれなもの：感染、アレルギー、左右差、糸の露出',
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
    '【医療内容】 \n\n脂肪溶解注射は、メスを使わずに気になる部分の脂肪を減らす痩身術です。\n\n脂肪を溶かす成分を直接皮下脂肪に注入し、脂肪細胞を破壊・溶解。\n\n使用薬剤：カベリン\n\n\n\n\n【治療期間・回数】\n\n 1回\n\n\n\n\n【費用】\n\n 1回(8cc)／31,680円\n\n\n\n\n【リスク・副作用】\n\n一般的なもの：内出血、腫れ、痛み、熱感、かゆみ\n\nまれなもの：色素沈着、しこり、硬結、感染、アレルギー反応',
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
    '【医療内容】\n\n表情筋の動きを和らげて、シワの改善や小顔効果を目的とした注射治療\n\n使用製剤：韓国製ボトックス\n\n特徴：ナチュラルな仕上がりで、コスパが良く人気\n\n\n\n\n【治療期間・回数】\n\n1回 \n\n\n\n\n【費用】\n\nエラ 16,500円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な赤み・腫れ・内出血・痛みが出ることがあります（数日で改善）\n\n稀に左右差・表情のこわばり・頭痛・違和感などが生じる場合あり\n\n効果は一時的で、時間の経過とともに自然に元に戻ります',
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
    '【医療内容】\n\n肩の筋肉（僧帽筋）にボトックスを注入し、肩こりの緩和や華奢な肩ライン(肩痩せ)を目指す施術\n\n使用製剤：韓国製ボトックス 両側50単位使用\n\n特徴：コスパが良く、自然な仕上がりで人気\n\n\n\n\n【治療期間・回数】\n\n1回 \n\n\n\n\n【費用】\n\n肩 16,500円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な赤み・腫れ・内出血・痛み（数日で改善）\n\n稀に肩のだるさ・重さ・筋力低下を感じる場合あり\n\n効果は時間とともに自然に元に戻ります',
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
    '【医療内容】\n\nボトックス製剤を薄めて、皮膚の浅い層に細かく注射します。 \n\n肌のハリ、小じわ、毛穴の引き締め、皮脂分泌抑制の改善が期待できます。\n\n使用薬剤：韓国社製ボトックス マイクロボトックス\n\n\n\n\n【治療期間・回数】\n\n 1回\n\n\n\n\n【費用】 \n\n鼻／24,200円\n\n\n\n\n【リスク・副作用】 \n\n一般的なもの: 内出血、腫れ、痛みが注入後に一時的に現れることがあります。\n\nまれなもの: 感染、アレルギー、表情の変化。非常に稀ですが、注意が必要です。',
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
    '【医療内容】\n\n肩の筋肉（僧帽筋）にボトックスを注入し、肩こりの緩和や華奢な肩ライン(肩痩せ)を目指す施術\n\n使用製剤：韓国製ボトックス 両側50単位使用\n\n特徴：コスパが良く、自然な仕上がりで人気\n\n\n\n\n【治療期間・回数】\n\n1回 \n\n\n\n\n【費用】\n\n肩 16,500円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な赤み・腫れ・内出血・痛み（数日で改善）\n\n稀に肩のだるさ・重さ・筋力低下を感じる場合あり\n\n効果は時間とともに自然に元に戻ります',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 0.5cc 唇\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：アラガン社製ヒアルロン酸（ジュビダームビスタ)\n\n特徴：高い安全性と持続性、なめらかな仕上がりが特長\n\n\n\n\n【治療期間・回数】\n\n1回 2cc 頬\n\n\n\n\n【費用】\n\n1ccあたり 66,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 1cc 顎\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 1cc 顎\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 0.5cc 涙袋\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 0.2cc 涙袋\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 0.5cc 顎\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 0.8cc ほうれい線\n\n2cc 頬\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 1cc 顎\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nヒアルロン酸を皮下に注入し、シワ・たるみ改善、ボリュームアップ、輪郭形成を行う施術\n\n使用製剤：ニューラミス（韓国製）\n\n特徴：リフティング効果・持続性・コスパに優れている\n\n\n\n\n【治療期間・回数】\n\n1回 1cc 顎\n\n\n\n\n【費用】\n\n1ccあたり 33,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的な腫れ・内出血・痛み・違和感（数日〜1週間ほどで落ち着く）\n\n稀にしこり・凹凸・アレルギー反応・感染の可能性\n\nごく稀に血管閉塞や壊死などの重篤な合併症のリスクあり',
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
    '【医療内容】\n\nローマピンクは、医療機関専用の低刺激ピーリング剤。\n\n角質の除去と美白・毛穴改善・ハリ感アップを目的とする。\n\n\n\n\n【治療期間・回数】\n\n1回\n\n\n\n\n【費用】\n\n唇 165,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的に赤み・乾燥・軽いヒリつきが生じる場合があります。\n\nまれに皮むけ・かゆみ・色素沈着が起こることがあります。\n\n日焼け直後や炎症のある肌への施術は控える必要があります。',
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
    '【医療内容】\n\nローマピンクは、医療機関専用の低刺激ピーリング剤。\n\n角質の除去と美白・毛穴改善・ハリ感アップを目的とする。\n\n\n\n\n【治療期間・回数】\n\n1回\n\n\n\n\n【費用】\n\n乳輪 220,000円（税込）\n\n\n\n\n【リスク・副作用】\n\n一時的に赤み・乾燥・軽いヒリつきが生じる場合があります。\n\nまれに皮むけ・かゆみ・色素沈着が起こることがあります。\n\n日焼け直後や炎症のある肌への施術は控える必要があります。',
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
    '【医療内容】\n\n 治療名：肌育注射\n\nジュベルックは、 肌のコラーゲン生成を促進させ、ハリ・弾力改善、小じわ・毛穴の改善する注射医療です。\n\n極細の針を使って、真皮層に直接薬剤を注入します。\n\n使用薬剤：ジュベルック\n\n\n\n\n【治療期間・回数】\n\n 1回\n\n\n\n\n【費用】 \n\n1回(4cc)／55,000円\n\n\n\n\n【リスク・副作用】 \n\n一般的なもの: 内出血、腫れ、痛みが注入後に一時的に現れることがあります。\n\nまれなもの: しこり、稀に注入部位に小さな硬い部分ができることがあります。\n\n感染、アレルギー。非常に稀ですが、注意が必要です。',
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
    '【医療内容】\n\n 治療名：肌育注射\n\nリジュランヒーラーは、サーモン由来のポリヌクレオチド（PN）を主成分とする注射治療で、肌細胞の再生を促進し、肌本来の若々しさを引き出すことを目指します。\n\n肌のハリ・弾力、潤い、小じわ、毛穴、くすみの改善が期待できます。\n\n使用薬剤：リジュランヒーラー\n\n\n\n\n【治療期間・回数】\n\n 1回\n\n\n\n\n【費用】 \n\n1回(4cc)／66,000円\n\n\n\n\n【リスク・副作用】 \n\n一般的なもの: 内出血、腫れ、痛みが注入後に一時的に現れることがあります。\n\n注射部位の軽い盛り上がりが注入直後に一時的に見られることがあります。\nまれなもの: 感染、アレルギー。非常に稀ですが、注意が必要です。',
    NULL,
    NULL,
    1,
    NULL,
    1,
    0
);