-- ============================================
-- サービスコンテンツ シードデータ
-- 生成日時: 2025-12-24 20:12:52
-- ============================================

-- ポテンツァ
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'c10d5ac1',
    NULL, -- subcategory_idは後で紐付け
    'ポテンツァ',
    'POTENZA',
    'potenza',
    'https://ledianclinic.jp/service/potenza/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('d39d3e8f', 'c10d5ac1', 'お悩みに合わせた薬剤を注入できる“ドラッグデリバリーシステム”', '針が抜ける瞬間の空気圧を利用した独自の「ポンピング作用」で、皮膚表面の薬剤を穴の中へ均一に押し込みます。これにより、肌悩みに応じた有効成分を正確かつ効率的に真皮層へ届け、治療効果を最大化します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('22725506', 'c10d5ac1', 'マイクロニードル', 'ポテンツァの極細マイクロニードルで皮膚に多数の微細な穴を開け、肌の再生能力を引き出すと同時に、薬剤が真皮層まで到達するための物理的な道を作ります。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('675775a2', 'c10d5ac1', 'RF(高周波)', '針先からRF(高周波)の熱を照射し、肌内部のコラーゲン生成を促して引き締めます。このRFの熱作用により、真皮組織の透過性が一時的に高まり、薬剤がよりスムーズに、広範囲に浸透しやすくなるようサポートします。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d3bc681c', 'c10d5ac1', '毛穴を引き締めたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('78fe8c83', 'c10d5ac1', 'ニキビ跡や皮膚の凹凸が気になる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('7b1c26ba', 'c10d5ac1', '肝斑を改善したい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f658f582', 'c10d5ac1', '赤ら顔が気になる', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('b635c6e1', 'c10d5ac1', 'シワ、たるみが気になる', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('e08c1d98', 'c10d5ac1', '60分程度(麻酔、鎮静パック込み)', '赤み・腫れが数時間~1日程度', '4週間~6週間に1回目安', '12時間後から可能', '長時間の入浴は2~3日控える', '妊娠中・授乳中の方、ペースメーカーを装着されている方、施術部位に金属プレートやシリコンを挿入されている方、ケロイド体質の方、皮膚疾患や重度の糖尿病、自己免疫疾患をお持ちの方');

-- エリシスセンス
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '55eb4734',
    NULL, -- subcategory_idは後で紐付け
    'エリシスセンス',
    'ELLISYS SENSE',
    'ellisys-sense',
    'https://ledianclinic.jp/service/ellisys-sense/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('4e0f17cd', '55eb4734', 'ダブルショット機能', 'エリシスセンスだけの特許を受けた技術で、1度のショット（肌に針を刺す）で2種類の異なる深さの皮膚層にRFエナジーを伝達させるシステムです。
1度のショットで2回分の効果があるため、施術時間の短縮・ニードルの痛み緩和・ダウンタイム短縮につながります。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('01e204ab', '55eb4734', '真空サクション機能', '肌に機器をあてたとき、お肌を吸引しながらニードルチップを挿入するため、チップと肌を密着させることが可能にするシステムです。そのため、瞼の上や首などの皮膚が重なるパーツにも使用することができます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('2159c218', '55eb4734', '金メッキニードル', '治療後に発生する可能性のあるアレルギー反応を最小限に抑えます。そのため、金属アレルギーの方でも施術が可能です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ad625e9a', '55eb4734', '毛穴を引き締めたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4ddd0441', '55eb4734', 'ニキビ跡や皮膚の凹凸が気になる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('527701fa', '55eb4734', '肝斑を改善したい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('00aed3cb', '55eb4734', '赤ら顔が気になる', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('c1168952', '55eb4734', 'シワ、たるみが気になる', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('d3f00134', '55eb4734', '60分程度（麻酔、鎮静パック込み）', '赤み・腫れが数時間〜1日程度', '4週間〜6週間に1回目安', '12時間後から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、ペースメーカーを装着されている方、施術部位に金属プレートやシリコンを挿入されている方、ケロイド体質の方、皮膚疾患や重度の糖尿病、自己免疫疾患をお持ちの方');

-- トライフィルプロ
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'e5eddc5a',
    NULL, -- subcategory_idは後で紐付け
    'トライフィルプロ',
    'Trifill Pro',
    'trifill-pro',
    'https://ledianclinic.jp/service/trifill-pro/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('7aede8b7', 'e5eddc5a', '1.炭酸ガスを使って癒着した組織を剥がす', 'ニキビ跡やクレーターは、硬く癒着した瘢痕が原因です。この瘢痕組織を炭酸ガスで切り離し、ニキビ跡を表面に引き上げます。さらに、炭酸ガスの注入によって血流が促進され、コラーゲンの生成も期待できます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b194c295', 'e5eddc5a', '2.お選び頂いた薬剤注入', '剥離した部分には、症状に合わせた薬剤を注入します。これにより、皮膚内で再びニキビ跡が癒着するのを防ぎ、治療効果を高めます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('c18bce95', 'e5eddc5a', '3.炭酸ガスを再度注入して薬剤を効果的に分散', '炭酸ガスを再び注入することで、薬剤が肌全体に均等に行き渡ります。同時に、コラーゲンの生成も促進され、治療効果がさらに高まります。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('171e624f', 'e5eddc5a', 'ニキビ跡の深いクレーターを滑らかにしたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('6044d20f', 'e5eddc5a', '根深いニキビ跡に長年悩んでいる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('209e2cb6', 'e5eddc5a', '怪我・手術による凹んだ傷跡を目立たなくしたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8765ad36', 'e5eddc5a', '肌の凹凸を本格的に改善したい', 3);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('20a51759', 'e5eddc5a', '1時間～1時間半程度（麻酔、鎮静パック込み）', '3日〜1週間程度が目安ですが、内出血が長引く場合は2週間ほどかかることもあります', '1ヶ月〜1ヶ月半に1回目安', '施術の翌日（24時間後）から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術後2～3日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、重度のケロイド体質の方、施術部位に強い炎症・感染症（ヘルペスなど）・未治療の皮膚がんがある方、重度の心疾患・出血性疾患をお持ちの方、血液をサラサラにする薬（抗凝固薬など）を服用中の方、コントロール不良の糖尿病の方、金属アレルギーや使用する薬剤にアレルギーのある方');

-- サブシジョン
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'f5441de7',
    NULL, -- subcategory_idは後で紐付け
    'サブシジョン',
    'Subcision',
    'subcision',
    'https://ledianclinic.jp/service/subcision/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('0e6d60ce', 'f5441de7', '凹みの「根本原因」に直接アプローチ', 'サブシジョンは、ニキビ跡のクレーターや傷跡の凹みの直接的な原因である、皮膚の奥で固くなった線維組織（癒着）を専用の針で物理的に切り離す治療です。皮膚を下に引っ張っていた「くい」を断ち切ることで、凹んだ部分を内側から持ち上げます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('3dc96a7d', 'f5441de7', '自己治癒力を利用して肌を再生', '癒着を切り離す際にできた空間と傷が治っていく過程で、体自身の「創傷治癒能力」が働き、コラーゲンやエラスチンの生成が強力に促進されます。これにより、肌に厚みとハリが生まれ、凹みがさらに目立ちにくくなるという長期的な効果も期待できます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('67bb913e', 'f5441de7', '深いクレーターへの高い効果', '特に広範囲にわたる「ローリング型」や、底が平らな「ボックス型」といった、他の表面的な治療では改善が難しいとされる深い凹みに対して、高い効果を発揮します。肌の深部に直接アプローチすることで、これまで諦めていたクレーターの改善が期待できます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('e2d88000', 'f5441de7', 'ニキビ跡の凹凸やクレーターが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('df33f1cc', 'f5441de7', '怪我・手術による傷跡の凹みが目立つ', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('b2b7206a', 'f5441de7', 'メイクで凹みを隠そうとしても、ファンデーションが溜まったり影になったりしてしまう', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('dad97146', 'f5441de7', '深く刻まれてしまったほうれい線や眉間のシワを和らげたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('856ef386', 'f5441de7', 'これまでレーザーやダーマペンなど、他の治療を試しても効果を実感しにくかった方', 4);

-- オンダリフト
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'e250784d',
    NULL, -- subcategory_idは後で紐付け
    'オンダリフト',
    'Onda Pro',
    'onda-pro',
    'https://ledianclinic.jp/service/onda-pro/',
    NULL,
    NULL,
    NULL,
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('c9301b9f', 'e250784d', '独自技術「Coolwaves®（クールウェーブ）」による高い効果と安全性', 'Coolwaves®は、2.45GHzという特殊な周波数のマイクロ波を使用しているため、皮膚表面ではほとんど吸収されず、そのエネルギーの約80%が皮下脂肪層に直接届きます。従来の高周波（RF）治療器などが皮膚表面から熱を加えるのに対し、オンダプロは皮膚へのダメージを最小限に抑えながら、脂肪細胞だけを選択的に加熱・破壊します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('11956b50', 'e250784d', '「脂肪減少」「セルライト改善」「引き締め」のトリプルアクション', 'ONDA PRO独自のマイクロ波は、脂肪細胞を選択的に破壊して体外への排出を促し、気になる部分痩せを実現します。同時に、セルライトの原因である硬い線維組織に働きかけて肌の凹凸を滑らかに整えます。さらに、コラーゲンの生成を促進することで皮膚を内側から引き締め、ハリと弾力のある理想のボディラインへと導きます。', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('965c8645', 'e250784d', '顔の脂肪が気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4fe93857', 'e250784d', '小顔になりたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('e81cb7ee', 'e250784d', '体の部分痩せを目指したい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('871c4bbd', 'e250784d', '顔のリフトアップも、引き締め効果も同時に叶えたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('5843d484', 'e250784d', '従来の痩身治療で効果を感じられなかった', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('85363c87', 'e250784d', '1部位10〜15分程度', 'ほとんどなし', '顔:2週間に1回体:4週間に1回', '直後から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術後2〜3日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、ペースメーカーを装着されている方、施術部位に金属プレートやシリコンを挿入されている方、重度の心臓疾患・腎臓・肝臓疾患・てんかん発作の既往がある方、ケロイド体質の方、現在悪性腫瘍（がん）の治療を受けている方、またはその既往歴がある方、皮膚疾患や重度の糖尿病の方、自己免疫疾患をお持ちの方');

-- オリジオKISS
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '12199f9f',
    NULL, -- subcategory_idは後で紐付け
    'オリジオKISS',
    'OligioKISS',
    '%e3%82%aa%e3%83%aa%e3%82%b8%e3%82%aakiss',
    'https://ledianclinic.jp/service/%e3%82%aa%e3%83%aa%e3%82%b8%e3%82%aakiss/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('86940c98', '12199f9f', 'T Mode　-タイトニングモード-', '顔全体のタイトニング（引き締め）を目的としたモードです。皮膚の広い範囲に均一にRF（高周波）エネルギーを届け、肌全体のハリ感を高め、小じわを改善します。お顔全体のベースを整え、若々しい印象へと導きます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('1faeb2b6', '12199f9f', 'G Mode　-肌質改善モード-', '肌のキメを整え、内側から輝くようなツヤと滑らかさを引き出すモードです。RF（高周波）エネルギーを肌の浅い層にシャワーのように照射することで、肌表面の質感を改善。毛穴の開きやごわつきが気になる肌を、透明感のあるなめらかなツヤ肌へと導きます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('8d95eda6', '12199f9f', 'X Mode　-集中ケアモード-', '目元や口元、フェイスラインなど、特に気になる部分をピンポイントで引き上げるモードです。高密度のRF（高周波）エネルギーを気になる箇所へ集中的に照射し、コラーゲンの生成を強力に促進。ほうれい線やマリオネットラインなど、年齢サインの出やすい部分に深くアプローチします。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d106822b', '12199f9f', '顔全体のたるみが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('cafa386a', '12199f9f', 'ほうれい線やマリオネットラインが目立つ', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('5d509ad9', '12199f9f', '肌のハリや弾力がなくなってきた', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f53c7489', '12199f9f', 'メスを使わずにリフトアップしたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('783a0364', '12199f9f', '将来のたるみに備えて、今から予防的なケアを始めたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('a5089004', '12199f9f', '30~40分程度（施術部位や範囲によって異なります）', 'ほとんどなし', '3ヶ月～6ヶ月に1回程度', '直後から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、ペースメーカー・埋め込み式除細動器をご使用中の方、施術部位に金属製のプレートやボルト・金の糸などを埋め込んでいる方、重度の心疾患・糖尿病・自己免疫疾患をお持ちの方、施術部位に重度の皮膚疾患や感染症・炎症がある方、ケロイド体質の方、てんかんの既往がある方、光線過敏症（日光アレルギー）の方');

-- HIFU ウルトラセルZi
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'fe1496f8',
    NULL, -- subcategory_idは後で紐付け
    'HIFU ウルトラセルZi',
    'High Intensity Focused Ultrasound',
    'high-intensity-focused-ultrasound',
    'https://ledianclinic.jp/service/high-intensity-focused-ultrasound/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('939242c3', 'fe1496f8', 'たるみの根本原因「SMAS筋膜」へ直接アプローチ', 'メスを使わずに、肌の土台である「SMAS筋膜」まで超音波を届け、たるみを根本から引き締めます。外科手術でしか届かなかった層にアプローチできるため、確かなリフトアップ効果が期待できます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('5a1ae6b6', 'fe1496f8', '未来の肌まで育てる「Wの効果」', '施術直後の引き締め効果に加え、数ヶ月かけてご自身のコラーゲンが増え続ける長期的なハリ感アップ効果も。一人ひとりの骨格に合わせたオーダーメイド照射で、未来の美しさまでデザインします。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('f9203480', 'fe1496f8', '痛みとダウンタイムを抑えた快適な治療', '最新機種と丁寧な技術で、施術中の痛みを最小限に抑えます。ダウンタイムもほとんどなく、施術直後からメイクも可能なので、日常生活に支障なく本格的なリフトアップが叶います。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('21858438', 'fe1496f8', 'フェイスラインがぼやけてきた、もたついている', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('167dd09c', 'fe1496f8', '二重あごをスッキリさせたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('758a38ca', 'fe1496f8', 'ほうれい線やマリオネットラインが目立つ', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('eb6bc8cd', 'fe1496f8', '目の下のたるみやクマが気になる', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8eb1b738', 'fe1496f8', 'メスを使わずにリフトアップしたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('828a7dc1', 'fe1496f8', '30分～45分程度', 'ほとんどなし', '半年に1回〜1年に1回目安', '施術直後から可能', '当日から可能', '妊娠中・授乳中の方、または妊娠の可能性のある方、施術部位に金属プレート、金の糸、シリコンなどが入っている方、ペースメーカーや埋め込み式除細動器を使用している方、重度の心疾患・糖尿病・自己免疫疾患をお持ちの方、重度のケロイド体質の方、施術部位に感染症・重度の皮膚疾患・開放創（傷）がある方、ヒアルロン酸やボトックスなどの注入治療を直近で受けた方（通常1ヶ月程度の間隔を空ける必要があります）');

-- 糸リフト
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '84577c5c',
    NULL, -- subcategory_idは後で紐付け
    '糸リフト',
    'thread lift',
    'thread-lift',
    'https://ledianclinic.jp/service/thread-lift/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('12c27f2f', '84577c5c', '圧倒的なデザイン力で叶える「オーダーメイドの仕上がり」', '当院では、単にたるみを引き上げるだけでなく、患者様一人ひとりの骨格、脂肪のつき方、皮膚の厚みまでを考慮した「オーダーメイドデザイン」にこだわります。解剖学を熟知した医師が、どの位置からどの深さに糸を挿入すれば最も自然で美しいフェイスラインになるかをミリ単位で設計し、あなただけの”黄金比”を引き出します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('695e1550', '84577c5c', '痛みへの配慮と安全性の追求', '施術中の不快感を最小限に抑えるため、麻酔を適切に使い分け、痛みに最大限配慮しています。また、経験豊富な医師が解剖学に基づき、血管や神経を避け安全な層に正確に糸を挿入することで、内出血や腫れといったダウンタイムを極力抑えます。患者様の安心と快適さを最優先し、丁寧な施術を心がけています。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('e8298a7e', '84577c5c', '持続するハリ感と肌質改善効果', '挿入された糸は、コラーゲンやエラスチンの生成を促進する働きがあります。これにより、リフトアップ効果だけでなく、肌の内側からハリや弾力が生まれ、肌質そのものの改善も期待できます。引き上げ効果が落ち着いた後も、肌全体の若々しさが持続するよう、肌の自己再生能力を引き出すことにこだわります。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ceddb128', '84577c5c', 'フェイスラインのもたつきが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('bcbce12c', '84577c5c', 'ほうれい線やマリオネットラインが深くなってきた', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('7a66598c', '84577c5c', '二重あごをすっきりさせたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('6f46aa77', '84577c5c', '頬の位置が下がり、顔全体が下がったように感じる', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('a058ee1f', '84577c5c', '切開リフトのような本格的な手術には抵抗がある', 4);

-- ショッピングリフト
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '421e2c91',
    NULL, -- subcategory_idは後で紐付け
    'ショッピングリフト',
    'shopping thread lift',
    '%e3%82%b7%e3%83%a7%e3%83%83%e3%83%94%e3%83%b3%e3%82%b0%e3%83%aa%e3%83%95%e3%83%88',
    'https://ledianclinic.jp/service/%e3%82%b7%e3%83%a7%e3%83%83%e3%83%94%e3%83%b3%e3%82%b0%e3%83%aa%e3%83%95%e3%83%88/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('809d7f04', '421e2c91', '肌の奥から育む、自然なハリとツヤ', 'ただ引き締めるだけでなく、挿入した極細の糸が肌のコラーゲンを増やす刺激になります。これにより、肌の内側からふっくらと弾むようなハリと自然なツヤが生まれ、根本から肌を若々しく育むことにこだわっています。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('7185d029', '421e2c91', '手軽なのに、一人ひとりに合わせた精密な施術', 'メスを使わず、短時間で受けられるのが大きな魅力です。その手軽さに加え、お客様お一人おひとりの肌質やたるみに合わせ、糸を入れる位置や本数を細かく調整します。痛みにも配慮し、少ない負担で理想の結果を目指します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b5d98ea4', '421e2c91', '未来の肌を守り、若々しさを長くキープ', '今ある小じわや毛穴の開きを改善するだけでなく、コラーゲンが増えることで、将来の肌老化を遅らせる「予防美容」としても有効です。一時的ではない、長く続く若々しさと、年齢に負けない強い肌作りをサポートすることに力を入れています。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('de832931', '421e2c91', '肌のハリ・弾力が失われてきた', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('fe6042eb', '421e2c91', 'たるみ毛穴が気になる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('bff4c279', '421e2c91', '肌のキメを整えたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('be3b685a', '421e2c91', '顔全体を自然に引き締めたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('95ef3502', '421e2c91', '手軽にエイジングケアを始めたい', 4);

-- ハイドラジェントル
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '8263f505',
    NULL, -- subcategory_idは後で紐付け
    'ハイドラジェントル',
    'HYDRA GENTLE',
    'hydra-gentle',
    'https://ledianclinic.jp/service/hydra-gentle/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('32045e59', '8263f505', 'クレンジング&ピーリング', '特殊なチップから渦巻き状の水流を噴射し、毛穴の奥の汚れや皮脂、角質を優しく除去します。サリチル酸などのピーリング剤を配合した水流で、古い角質を柔らかくし、毛穴詰まりを解消します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b3d8542e', '8263f505', '吸引＆除去', '水流で浮き上がらせた汚れや老廃物を、吸引機能で取り除きます。毛穴の黒ずみ、白ニキビ、角栓などを効果的に除去し、肌表面をなめらかに整えます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('6981a8b2', '8263f505', '美容液導入', '抗酸化作用や保湿効果の高い美容液を、水流とともに肌の奥深くまで浸透させます。ヒアルロン酸、ビタミンC誘導体など、肌悩みに合わせた美容液を選択することで、より高い効果が期待できます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('6d07b33a', '8263f505', '毛穴の黒ずみが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('2c874af1', '8263f505', '毛穴の開きが目立つ', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('2faa9df2', '8263f505', 'Tゾーンのテカリや皮脂が多い', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d055d713', '8263f505', 'ニキビや肌荒れを予防したい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('14bb45ee', '8263f505', '肌のくすみを改善し、透明感を出したい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('47aec3e2', '8263f505', '20～30分程度', 'ほとんどなし', '月に1回程度', '直後から可能', '当日から可能', '妊娠中・授乳中の方、または妊娠の可能性のある方、施術部位に強い炎症や皮膚疾患・ヘルペスがある方、施術部位に未治療の傷や感染症がある方、過度な日焼けをされている方、アスピリンアレルギー・グリコール酸アレルギーをお持ちの方、ケロイド体質の方');

-- マッサージピール
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'd13730c5',
    NULL, -- subcategory_idは後で紐付け
    'マッサージピール',
    'MASSAGE PEEL',
    'massage-peel',
    'https://ledianclinic.jp/service/massage-peel/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('2e9b943a', 'd13730c5', '真皮層へ直接アプローチ', '主成分である高濃度トリクロロ酢酸（TCA）が肌の奥深く「真皮層」に作用し、コラーゲンの生成を強力に促進。肌の土台からハリと弾力を生み出し、たるみを内側から引き上げます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('36787a3c', 'd13730c5', '“剥がさない”ピーリング', '高濃度TCAに配合された過酸化水素が肌表面へのダメージを抑えるため、従来のピーリングのような皮むけはほとんどありません。ダウンタイムを気にせず手軽に受けられます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b85315cf', 'd13730c5', 'ハリ・ツヤ・美白を一度に', 'コラーゲン増生によるハリ改善に加え、美白成分「コウジ酸」がシミやくすみを抑制。ハリ・弾力・トーンアップを同時に叶え、施術直後から輝くようなツヤ肌を実感できます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('58a8eb9a', 'd13730c5', '肌全体のハリ不足が気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('473255e9', 'd13730c5', '目元や口元の小じわを目立たなくしたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('a86cc6d9', 'd13730c5', '顔全体のくすみを払い、透明感と明るさが欲しい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('16171cd5', 'd13730c5', '肌のキメを整えたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4847dd79', 'd13730c5', '痛い施術やダウンタイムのある治療は避けたい', 4);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('75214db8', 'd13730c5', '首やデコルテのシワをケアしたい', 5);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('59cac7b9', 'd13730c5', '15分～20分程度', 'ほとんどなし', '2～4週間に1回目安', '施術直後から可能', '当日から可能', '妊娠中・授乳中の方、または妊娠の可能性のある方、薬剤の成分（特にトリクロロ酢酸やコウジ酸）にアレルギーがある方、施術部位に強い炎症や皮膚疾患（ヘルペス、重度のアトピー性皮膚炎など）がある方、脂漏性皮膚炎の部位、日光過敏症の方、イソトレチノイン（アキュテインなど）の内服治療中の方・または治療後間もない方、施術前にトレチノインやハイドロキノンなど刺激の強い外用薬を使用している方（前後数日～1週間の休薬が必要です）');

-- ミラノリピール
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'a12e01d5',
    NULL, -- subcategory_idは後で紐付け
    'ミラノリピール',
    'Milano RePeel',
    'milano-repeel',
    'https://ledianclinic.jp/service/milano-repeel/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('23348a01', 'a12e01d5', '効果と低刺激の両立', '国際特許技術の「2層式」製剤が特徴。オイルベースの層が肌表面を保護し、有効成分を肌の奥深くまで届けます。これにより、高いピーリング効果とコラーゲン増生作用を発揮しつつ、赤みや皮むけなどのダウンタイムを最小限に抑えます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('5d8eb35c', 'a12e01d5', '5種の酸と美容成分で肌再生アプローチ', '5種類の酸（TCA・AHA・BHAなど）を絶妙に配合し、ターンオーバー促進から真皮層のコラーゲン生成まで多角的にアプローチ。さらに豊富な美容成分が肌に栄養を与え、ニキビ、毛穴、くすみ、ハリ不足といった様々な肌悩みを一度にケアします。', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ded997b0', 'a12e01d5', '毛穴の開き・黒ずみと、肌のくすみ・ごわつきを同時に改善したい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('bb1f2488', 'a12e01d5', 'ニキビやニキビ跡、オイリー肌に悩んでいる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('17ce5332', 'a12e01d5', '肌全体のハリ不足や小じわが気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('167a4807', 'a12e01d5', 'ニキビ跡の色素沈着を改善したい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('9aafdc74', 'a12e01d5', '顔全体のくすみを払い、透明感のある明るい肌になりたい', 4);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('af521982', 'a12e01d5', '肌質を根本から見直したい', 5);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('6cffc028', 'a12e01d5', '20分～30分程度', 'ほとんどなし〜数日程度マッサージピールに比べると、やや皮剥けなどが起こる可能性あり', '2〜4週間に1回目安', '施術直後から可能', '当日から可能', '妊娠中・授乳中の方、または妊娠の可能性のある方、薬剤の成分にアレルギーがある方（TCA、サリチル酸など）、アスピリン喘息の既往がある方（サリチル酸が含まれるため）、施術部位に強い炎症・感染症（ヘルペスなど）・未治療の皮膚疾患がある方、重度の皮膚疾患（アトピー性皮膚炎など）で炎症が強く出ている場合、日光過敏症の方、イソトレチノイン（アキュテインなど）の内服治療中の方・または治療後間もない方');

-- マヌカピール
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'd8f1ee45',
    NULL, -- subcategory_idは後で紐付け
    'マヌカピール',
    'Manuka Peel',
    'manuka-peel',
    'https://ledianclinic.jp/service/manuka-peel/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('2e664a1b', 'd8f1ee45', '天然の抗菌力「マヌカハニー」でニキビの根本原因を断つ', '医療用マヌカハニーの強力な抗菌・抗炎症作用で、ニキビの原因となるアクネ菌を抑制し、炎症を鎮めます。天然由来の力で肌本来の健やかさを取り戻し、ニキビができにくい肌環境へ導きます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b9c795fd', 'd8f1ee45', '三大角質ケア成分で、毛穴の詰まりとごわつきを一掃', 'サリチル酸・グリコール酸・乳酸の3つの酸を黄金比で配合。毛穴の奥の詰まりから肌表面のごわつきまでを一掃し、乱れたターンオーバーを正常化。ニキビができにくい、滑らかでクリアな肌へ整えます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('f5da9a40', 'd8f1ee45', '乾燥させない高保湿ピーリング', 'マヌカハニーの高い保湿効果により、ピーリング特有の乾燥や刺激を最小限に抑制します。肌のバリア機能を守りながら潤いを与える「肌育」ピーリングのため、敏感肌や乾燥肌の方でも安心です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('423b142a', 'd8f1ee45', '思春期ニキビ・大人ニキビが繰り返しできてしまう', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('9190fdfe', 'd8f1ee45', 'ニキビ跡の赤みや色素沈着を改善したい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('7d8e8d79', 'd8f1ee45', 'あごやフェイスラインの肌荒れをどうにかしたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('1ffdb474', 'd8f1ee45', '毛穴の詰まりや黒ずみ、角栓をスッキリさせたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ea3d457e', 'd8f1ee45', '敏感肌や乾燥肌で、これまでのピーリングが刺激に感じた', 4);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('7be5072a', 'd8f1ee45', 'ピーリングをしたいけれど、乾燥や皮むけが心配', 5);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('d5f305e7', 'd8f1ee45', '15分～20分程度', 'ほとんどなし', '2～4週間に1回目安', '施術直後から可能', '当日から可能', '妊娠中・授乳中の方、または妊娠の可能性のある方、ハチミツアレルギーの方、アスピリン喘息の既往がある方（サリチル酸が含まれるため）、サリチル酸に対してアレルギーがある方、施術部位に強い炎症・感染症（ヘルペスなど）・傷がある方、重度の皮膚疾患（アトピー性皮膚炎など）で炎症が強く出ている場合、イソトレチノイン（アキュテインなど）の内服治療中の方・または治療後間もない方');

-- ララドクター
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'a3a413da',
    NULL, -- subcategory_idは後で紐付け
    'ララドクター',
    'LHALA Doctor',
    'lhala-doctor',
    'https://ledianclinic.jp/service/lhala-doctor/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('e3d42599', 'a3a413da', 'ララフォーム 〜LHALA Foam〜', 'ー マイクロバブルクレンザー ー酸素が含まれた細かい泡で洗うことで、毛穴の奥の汚れや古い角質、余分な皮脂を効果的に除去し、ディープクレンジングの効果が期待できます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('be75678e', 'a3a413da', 'ララオレ 〜LHALA Ole〜', 'ー スキントップコート ーララドクター施術前の皮膚保護とコーティングの役割でララドクターがよく吸収できるようにしてくれます。皮膚の炎症を引き起こす要因から保護します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('1ee15fd6', 'a3a413da', 'ララドクター 〜LHALA Doctor〜', 'ー ピーリング＋肌育 ー低刺激のLHAと線維芽細胞活性化成分P-SOL™配合で、脂質成分でバリア機能も保護してくれるため、ダウンタイムが短く、ニキビ・毛穴・くすみ等、様々な肌悩みに効果的です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d42852a8', 'a3a413da', '毛穴の黒ずみや開きをきれいにしたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('0fe1bad5', 'a3a413da', '透明感や水光肌のようなツヤが欲しい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('827c4dda', 'a3a413da', 'ニキビができやすい、ニキビ跡の色素沈着が気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('6aff0cd1', 'a3a413da', '乾燥による小じわや、肌全体のハリ不足が気になる', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('a9c3c5f5', 'a3a413da', '混合肌のバランスを整えたい', 4);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8c24e195', 'a3a413da', '痛い施術や、赤み・皮むけなどのダウンタイムがある治療は避けたい', 5);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('6269027b', 'a3a413da', '40分～1時間程度', 'ほとんどなし', '1～2週間に1回目安', '施術直後から可能', '当日から可能', '妊娠中・授乳中の方、または妊娠の可能性のある方、使用する薬剤の成分（LHA、P-SOL™など）にアレルギーがある方、施術部位に強い炎症・感染症（ヘルペスなど）・未治療の皮膚疾患がある方、重度の皮膚疾患（アトピー性皮膚炎など）で炎症が強く出ている場合、日光過敏症の方、イソトレチノイン（アキュテイン、ロアキュタンなど）を内服中の方、または服用終了後すぐの方');

-- ジャルプログロウピール
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '3e855e2a',
    NULL, -- subcategory_idは後で紐付け
    'ジャルプログロウピール',
    'Jalupro GlowPeel',
    'jalupro-glowpeel',
    'https://ledianclinic.jp/service/jalupro-glowpeel/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('bbedb9a0', '3e855e2a', 'ダウンタイムほぼゼロへのこだわり', '従来のピーリングの課題であった「痛み」「赤み」「皮むけ」を最小限に抑えることにこだわっています。分子量の異なる複数の酸を緻密に配合することで、肌の奥へ穏やかに作用させます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('eb5790d5', '3e855e2a', 'ツヤとハリに特化した独自処方', 'その名の通り、肌の「Glow（輝き）」を引き出すことに特化しています。単に角質を除去するだけでなく、抗酸化作用のあるフィチン酸などを配合し、くすみの原因にアプローチして、内側から発光するようなツヤとハリ感のある肌を目指す処方です。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('32e2f687', '3e855e2a', '他の治療との相乗効果を前提とした設計', '単体での効果はもちろん、他の美容医療との組み合わせを前提に開発されています。ピーリングで肌表面を滑らかにし、美容成分の浸透しやすい土台を作ることで、後に行う施術の効果を飛躍的に高めます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('532ff27f', '3e855e2a', '肌のくすみや色ムラが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f0952626', '3e855e2a', '内側から発光するような自然なツヤ肌を手に入れたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d68b0e35', '3e855e2a', 'キメが乱れて化粧ノリが悪いと感じる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ffb75532', '3e855e2a', '肌に滑らかさが欲しい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f30bb26d', '3e855e2a', '痛みが少なく、ダウンタイムのない手軽な美肌治療を受けたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('27040a57', '3e855e2a', '約20～30分程度', 'ほとんどなし', '2～4週間に1回がおすすめ', '施術直後から可能', 'シャワーは施術当日から可能入浴（湯船）は血行促進され、赤みや痒みが増す可能性があるため、施術後当日はお控えください', '妊娠中・授乳中の方、施術部位にヘルペスなどの感染症や強い炎症、未治療の皮膚疾患がある方、ケロイド体質の方、日光過敏症の方、配合されている成分にアレルギーがある方、重度の皮膚疾患をお持ちの方');

-- ブラックピール
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'a457d241',
    NULL, -- subcategory_idは後で紐付け
    'ブラックピール',
    'V Carbon Peel',
    'v-carbon-peel',
    'https://ledianclinic.jp/service/v-carbon-peel/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b3e3b5e7', 'a457d241', '「植物性活性炭」による圧倒的な毛穴浄化力', 'ブラックピールの最大の特徴は、医療グレードの「植物性活性炭」を配合している点です。この微細な炭の粒子が、毛穴の奥に詰まった皮脂、古い角質、メイク汚れなどを磁石のように強力に吸着します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('6d14f695', 'a457d241', '浄化と同時に育む、攻めのアンチエイジング処方', '3種類の酸（フェルラ酸、マンデル酸、乳酸）がターンオーバーを正常化し、美白効果をもたらします。さらに、黒ショウガエキスや甘草エキスといった抗酸化成分を贅沢に配合。これにより、肌の酸化（老化）を防ぎながら、リフティング効果やハリ感向上を同時に叶えます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('553c3ccc', 'a457d241', '即効性と低刺激の両立へのこだわり', 'これほど強力な浄化作用と美肌効果を持ちながら、施術中の痛みが少なく、ダウンタイムがほぼない点も大きな特徴です。肌への刺激を最小限に抑えるよう成分バランスが調整されており、施術直後からメイクも可能です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('13ba4ad9', 'a457d241', '鼻や頬の毛穴の「黒ずみ」「詰まり」をきれいにしたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('eaa7b2e7', 'a457d241', '毛穴をキュッと引き締めたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('2ae8b3e1', 'a457d241', '肌が脂っぽく、テカリやベタつきが気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f4c912c4', 'a457d241', 'ニキビができやすく、跡も残りやすい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('83fa810a', 'a457d241', 'フェイスラインのたるみや、肌のハリ不足を感じる', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('a8c2e690', 'a457d241', '約20～30分程度', 'ほとんどなし', '2～4週間に1回がおすすめ', '施術直後から可能', 'シャワーは施術当日から可能入浴（湯船）は血行促進され、赤みや痒みが増す可能性があるため、施術後当日はお控えください', '妊娠中・授乳中の方、施術部位にヘルペスなどの感染症や強い炎症、未治療の皮膚疾患がある方、ケロイド体質の方、日光過敏症の方、配合されている成分にアレルギーがある方、重度の皮膚疾患をお持ちの方');

-- フォトフェイシャル Stella M22
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '5a5bb6cc',
    NULL, -- subcategory_idは後で紐付け
    'フォトフェイシャル Stella M22',
    'Stellar M22 Photofacial',
    'stella-m22',
    'https://ledianclinic.jp/service/stella-m22/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('dc3c7074', '5a5bb6cc', 'シミ・そばかす', 'メラニン色素に反応する光で、気になる部分だけをピンポイントに除去。肌への負担を抑え、数日でかさぶたが剥がれ落ち、透明感のある肌へ導きます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('3524e3e7', '5a5bb6cc', '赤ら顔・ニキビ跡', '赤みの原因である毛細血管に光を照射。不要な血管を収縮させることで、赤ら顔やニキビ跡を根本から改善します。諦めていた赤みにも効果が期待できます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('7ae94a4a', '5a5bb6cc', 'ハリ・毛穴・小じわ', '肌の深層部（真皮層）に光を届け、コラーゲンの生成を促進。内側からハリを生み出し、毛穴や小じわの目立たない、若々しい肌質へと整えます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('5dd59937', '5a5bb6cc', 'シミ・そばかす・くすみが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f1f62e68', '5a5bb6cc', '顔全体の色ムラをなくし、肌のトーンを均一にしたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('b91f8d63', '5a5bb6cc', '赤ら顔が気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('db67d352', '5a5bb6cc', '肌のくすみを改善し、透明感を出したい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('1e45b6b3', '5a5bb6cc', '肌全体のトーンアップを叶えたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('777f141e', '5a5bb6cc', '15分～30分程度', 'ほとんどない', '3～4週間に1回程度', '直後から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、光線過敏症（光アレルギー）の方、てんかん発作の既往がある方、重度の皮膚疾患（ケロイド体質、ヘルペス、アトピー性皮膚炎など）がある方、施術部位に金の糸が入っている方、施術前後に過度な日焼けをされている、またはその予定がある方、光感受性を高める薬（一部の抗生物質や精神薬など）を内服・外用している方');

-- ピコレーザー
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '7b96556c',
    NULL, -- subcategory_idは後で紐付け
    'ピコレーザー',
    'Pico laser',
    'pico-laser',
    'https://ledianclinic.jp/service/pico-laser/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('e58862b2', '7b96556c', 'ピコトーニング', '低出力のレーザーを顔全体にシャワーのように優しく照射し、肌全体のトーンアップを目指す治療です。メラニン色素を少しずつ分解・排出させることで、従来のレーザーでは難しかった肝斑や、そばかす、薄いシミ、くすみを改善します。ダウンタイムがほとんどなく、回数を重ねることで透明感のある均一な肌色へと導きます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('f1f6dce4', '7b96556c', 'ピコスポット', '気になるシミやそばかすに、高出力のレーザーをピンポイントで照射する治療法です。衝撃波で色素を細かく粉砕するため、従来のレーGーより少ない回数で高い効果が期待できます。照射後は患部が薄いかさぶたになり、1～2週間で自然に剥がれ落ちます。濃くハッキリとしたシミを少ない回数で取りたい方におすすめです。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('628c5132', '7b96556c', 'ピコフラクショナル', 'レーザーを点状に高密度で照射し、皮膚の深部に微細な空洞を作ることで、コラーゲンやエラスチンの生成を強力に促す肌再生治療です。肌表面へのダメージを最小限に抑えながら、ニキビ跡の凹凸や毛穴の開き、小じわを内側から改善。ハリと弾力のある滑らかな肌質へと導きます。数日間の赤みなどのダウンタイムがあります。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('c5848059', '7b96556c', '薄いシミやそばかすをまとめてキレイにしたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('61b9e96b', '7b96556c', '肝斑（かんぱん）を悪化させずに薄くしたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('58dea66c', '7b96556c', '肌全体のくすみや色ムラを解消したい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('77d7f516', '7b96556c', 'ニキビ跡や傷跡の色素沈着が気になる', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4353a032', '7b96556c', 'ワントーン明るい透明感のある肌を手に入れたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('c4a8df75', '7b96556c', '15分～30分程度', 'ピコトーニング：ほとんどなしピコフラクショナル：3日～1週間程度', 'ピコトーニング：3〜4週間に1回程度目安ピコフラクショナル：4週間に1回程度目安', 'ピコトーニング：施術直後から可能ピコフラクショナル：施術の翌日（24時間後）から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、光過敏症の方・または光感受性を高める薬を服用中の方、てんかん発作の既往がある方、重度のケロイド体質の方、施術部位に金の糸が入っている方、施術部位に感染症・重度の皮膚疾患・傷がある方、日焼け直後・またはこれから日焼けをする予定のある方');

-- 脂肪溶解注射
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'cfaf2af9',
    NULL, -- subcategory_idは後で紐付け
    '脂肪溶解注射',
    'Lipodissolve Injection',
    'lipodissolve-injection',
    'https://ledianclinic.jp/service/lipodissolve-injection/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('8164680a', 'cfaf2af9', '切らずに実現！「注射で部分痩せ」の仕組み', 'メスを使わず、気になる部分に注射するだけで脂肪細胞を直接破壊。溶け出した脂肪は老廃物として自然に体外へ排出される、手軽で負担の少ない治療です。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('065dd681', 'cfaf2af9', '気になる"ココだけ"を狙い撃ち', 'フェイスラインや二重あご、二の腕、お腹周りなど、痩せにくい部分をピンポイントで狙い撃ち。食事制限や運動では難しい「部分痩せ」を医療の力で実現します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('52c45fa9', 'cfaf2af9', 'ダウンタイムが短く、自然な変化でバレにくい！', '脂肪吸引に比べ、腫れや痛みが少なくダウンタイムが短いのが特長です。施術も約15分で、日常生活への影響はほとんどありません。脂肪が徐々に減っていくため、周りに気づかれにくい自然な変化が期待できます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('e0c47f92', 'cfaf2af9', '二重あごをスッキリさせたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('db137508', 'cfaf2af9', '顔だけ痩せない、丸顔が気になる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('953f9b0e', 'cfaf2af9', '笑ったときに盛り上がる頬肉が気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('db1b5559', 'cfaf2af9', '運動や食事制限では落ちにくい部分だけ、サイズダウンしたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('c4d2efea', 'cfaf2af9', '振袖のような二の腕を細くしたい', 4);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('217a6409', 'cfaf2af9', 'ぽっこりした下腹や、ジーンズの上に乗る腰回りの脂肪を減らしたい', 5);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('034f0621', 'cfaf2af9', '15分～30分程度', '数日〜1週間程度が目安です腫れ・むくみ・熱感：ピークは施術直後～3日程度内出血（アザ）：1～2週間程度痛み・鈍痛：数日～1週間程度しこり（硬結）：数週間程度', '1回でも効果を実感できる場合がありますが、多くの場合3〜5回程度の継続が推奨されます顔の場合： 2週間〜1ヶ月に1回体の場合： 1ヶ月に1回', '施術当日から可能ですが、注射した箇所（針穴）は避けてください', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、使用する薬剤の成分にアレルギーがある方、重度の心疾患・腎疾患・肝疾患・甲状腺疾患をお持ちの方、自己免疫疾患をお持ちの方、施術部位に感染症や重度の皮膚疾患・傷がある方、血液をサラサラにする薬（抗凝固薬など）を服用中の方');

-- ボトックス
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '0bf4808b',
    NULL, -- subcategory_idは後で紐付け
    'ボトックス',
    'Botox',
    'botox',
    'https://ledianclinic.jp/service/botox/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('c4750916', '0bf4808b', '表情ジワの原因となる筋肉へ直接アプローチ', '眉間や目尻の表情ジワは、筋肉の過剰な動きが原因です。ボトックスで筋肉の緊張を和らげ、シワを改善・予防します。未来のシワを防ぐ「予防美容」としても効果的です。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('57995a58', '0bf4808b', 'メスを使わない、短時間で完了する手軽さ', '施術は極細の針による注入のみで、わずか5～10分で完了します。ダウンタイムがほとんどなく、施術後すぐにメイクも可能です。忙しい方でも気軽に受けていただけます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('e9858f9f', '0bf4808b', '自然な仕上がりを叶える、医師の技術力とデザイン力', '医師が一人ひとりの筋肉のつき方や骨格を見極め、注入量と部位をミリ単位で調整します。その人本来の美しさを引き出す、自然で違和感のない仕上がりを追求します。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8ab0a507', '0bf4808b', '眉間、額、目尻などにできる表情ジワを改善したい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ead93d96', '0bf4808b', 'エラの張りを抑え、すっきりとした小顔に見せたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('279c1d8b', '0bf4808b', 'あごにできるシワをなくしたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8d58b6b3', '0bf4808b', '肩こりを緩和したい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('3561b646', '0bf4808b', '将来のシワ予防をしたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('d7e3ccb8', '0bf4808b', '5分～10分程度', 'ほとんどなし', '4～6ヶ月に1回程度', '直後から可能', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、過去にボツリヌス製剤でアレルギー反応が出た方、特定の神経筋疾患（重症筋無力症など）をお持ちの方、治療中の疾患があり内服中の薬がある方（特に一部の抗生物質や筋弛緩薬など）');

-- ヒアルロン酸
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '38509884',
    NULL, -- subcategory_idは後で紐付け
    'ヒアルロン酸',
    'Hyaluronic acid injection',
    'hyaluronic-acid-2',
    'https://ledianclinic.jp/service/hyaluronic-acid-2/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('51a34021', '38509884', 'シワ改善から輪郭形成まで、幅広い悩みに即効アプローチ', 'ほうれい線などの深いシワを埋めるだけでなく、加齢で失われた頬やこめかみのボリュームを回復。さらに鼻筋やあごのラインを整えるなど、メスを使わずに理想の輪郭を形成します。施術直後から効果を実感できるのが魅力です。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('02fdf305', '38509884', '一人ひとりに合わせたオーダーメイド施術', 'ヒアルロン酸には硬さの異なる様々な種類があります。当院ではシワの深さや注入部位、目的に応じて最適な製剤を厳選。一人ひとりのご要望に合わせた、自然で美しい仕上がりを追求します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('5bdff1e1', '38509884', 'エイジングサインへの多角的なアプローチと長期的な美肌ケア', 'シワやたるみを改善するだけでなく、肌の保湿力を高めて肌質そのものを向上させます。涙袋や唇、鼻、あごの形成など、美容ニーズに多角的に応え、顔全体の魅力を引き出します。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('425d12fa', '38509884', 'ほうれい線、ゴルゴ線、マリオネットラインなどの深いシワが気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('fd5506b0', '38509884', '頬やこめかみのコケをふっくらさせたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d8f49dd7', '38509884', '目の下のくぼみやクマ（影クマ）を改善したい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('96337b08', '38509884', '唇をぷっくりと厚くしたり、輪郭を整えたりしたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d1052f2f', '38509884', '鼻筋を高くしたり、あごのラインをシャープにしたりしたい', 4);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('0a2ca8c2', '38509884', '涙袋を作って、優しく華やかな目元にしたい', 5);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8b973394', '38509884', 'おでこを丸くして、女性らしい印象にしたい', 6);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('81a50fdd', '38509884', '自然な変化で、コンプレックスを解消したい方', 7);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('974247a1', '38509884', '30分～1時間程度（カウンセリングから施術まで全て含む）', 'ほとんどない〜2週間程度（※個人差あり）腫れ・赤み：施術直後～3日程度内出血（アザ）：1～2週間程度痛み・違和感：数日～1週間程度凹凸感・しこり：2週間～1ヶ月程度', NULL, '施術当日から可能ですが、注射した箇所は避けてください施術翌日からは、全顔のメイクが可能です', 'シャワー： 当日から可能湯船に浸かる入浴： 施術当日は避けてください', '妊娠中・授乳中の方、または妊娠の可能性のある方、ヒアルロン酸に対してアレルギーがある方、重度のケロイド体質の方、自己免疫疾患をお持ちの方、施術部位に感染症や重度の皮膚疾患がある方、血液をサラサラにする薬（抗凝固薬など）を服用中の方');

-- ケアシス
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'f5a15260',
    NULL, -- subcategory_idは後で紐付け
    'ケアシス',
    'CareCys',
    'carecys',
    'https://ledianclinic.jp/service/carecys/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('7c590382', 'f5a15260', '“針を使わない”のに、肌の奥深くまで届ける力', 'ケアシスは、特殊な電気パルスで一時的に細胞膜に微細な通り道を作る「エレクトロポレーション（電気穿孔法）」技術を搭載。これにより、イオン導入の約20倍もの量の美容成分を、針を使わずに肌の奥深く（真皮層）までダイレクトに浸透させます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('d3684539', 'f5a15260', '“鎮静”と“引き締め”を同時に叶えるクール導入', '最大のこだわりは、美容成分を導入しながら肌を強力に冷却する機能です。レーザー治療やピーリング後の火照った肌をひんやりと鎮静させ、赤みや炎症などのダウンタイムを大幅に軽減します。さらに、冷却作用によって開いた毛穴をキュッと引き締める効果も。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('62cb329c', 'f5a15260', '美容成分を肌に“閉じ込める”独自アプローチ', 'ただ導入するだけでは終わりません。冷却によって血管を収縮させることで、肌の奥へ届けた美容成分が血中に吸収されてしまうのを防ぎ、肌内部に長時間しっかりと留まらせることができます。この「閉じ込める」アプローチにより、施術効果の持続性が格段に向上します。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('2ac09404', 'f5a15260', '毛穴の開きを引き締めたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('730e4ef4', 'f5a15260', '肌が乾燥しやすく、うるおいとツヤが欲しい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('34ff9952', 'f5a15260', '顔全体のくすみを改善し、透明感のある肌になりたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('de3557a5', 'f5a15260', 'レーザー治療やピーリングと組み合わせて、治療効果をさらに高めたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('f1595d3c', 'f5a15260', 'レーザー後の赤みや腫れを早く鎮静させたい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('f4f1ece9', 'f5a15260', '15～20分程度', 'ほとんどなし', '2～4週間に1回', '施術直後から可能', '施術当日から可能', '妊娠中・授乳中の方、ペースメーカーや除細動器など体内に金属製の電子機器を埋め込んでいる方、施術部位に重度の皮膚疾患や感染症・未治療の傷がある方、てんかんの既往がある方、重度の心疾患をお持ちの方、導入する薬剤に対してアレルギーがある方');

-- Lhala 10 LDM
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '0bf9ec5f',
    NULL, -- subcategory_idは後で紐付け
    'Lhala 10 LDM',
    'Local Dynamic Micromassage',
    'lhala-10-ldm',
    'https://ledianclinic.jp/service/lhala-10-ldm/',
    NULL,
    NULL,
    NULL,
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('11f5309a', '0bf9ec5f', '痛みゼロで「肌を育てる」', 'LDMの最大の特徴は、レーザーやHIFUのように熱で組織を破壊・再生させるのではなく、「細胞レベルで肌そのものを健康に育てる」という全く異なるアプローチにあります。高密度の超音波が肌細胞に微細なマッサージ効果を与え、コラーゲンを増やすだけでなく、肌の水分保持能力やバリア機能を根本から正常化します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('acada775', '0bf9ec5f', '周波数を切り替える「デュアル周波数技術」', 'LDMは、周波数の異なる超音波を1秒間に数百回も高速で切り替える独自の技術を搭載しています。これにより、肌の浅い層と深い層の両方に同時にエネルギーを届けることができます。このリズミカルな刺激が、肌のハリを損なう酵素（MMP）の活動を効果的に抑制し、同時にコラーゲン生成を促進します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('aea86df4', '0bf9ec5f', '圧倒的な「水分量アップ」と即時的なツヤ感', '施術直後から、肌が内側からパンッと潤うような圧倒的な保湿効果とツヤ感が実感できです。これはLDMが、肌の水分量を保つ重要な成分（GAG：グリコサミノグリカン）の生成と分布を最適化するためです。肌が潤いで満たされることで、乾燥による小じわが目立たなくなり、キメが整い、光を美しく反射する水光肌が生まれます。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4f84f26b', '0bf9ec5f', '肌のたるみが気になる・肌のハリを取り戻したい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('5024b11c', '0bf9ec5f', '毛穴の開きやキメの乱れを引き締めたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('7d69427d', '0bf9ec5f', '乾燥肌がひどく、小じわが気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4e47747b', '0bf9ec5f', 'ニキビ・肌荒れ・赤みを繰り返す', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('6eba90f9', '0bf9ec5f', 'くすみが気になり、透明感やツヤが欲しい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('9068d102', '0bf9ec5f', '15分～30分程度', 'ほとんどなし', '初期は1〜2週間に1回、その後は月1回程度のメンテナンスがおすすめです', '施術直後から可能', '施術当日から可能', '妊娠中・授乳中の方、施術部位に金の糸や金属プレート、シリコンプロテーゼなどを入れている方、ペースメーカーや植え込み型除細動器を使用している方、施術部位に悪性腫瘍またはその疑いがある方、施術部位に重度の皮膚疾患や感染症がある方、ケロイド体質の方、てんかん発作の既往がある方');

-- ローマピンク
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '3981cbec',
    NULL, -- subcategory_idは後で紐付け
    'ローマピンク',
    'Roma Pink',
    'roma-pink',
    'https://ledianclinic.jp/service/roma-pink/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b55085a4', '3981cbec', '“剥がさない”から、ダウンタイムほぼゼロ', '従来のピーリングは肌表面を「剥離」させることで新陳代謝を促しましたが、ローマピンクは「浸透させる」ことに特化した次世代のピーリングです。特殊な2層式リキッドが肌表面へのダメージを最小限に抑えながら有効成分を深層へ届けるため、痛みや皮むけなどのダウンタイムがほとんどありません。施術直後から普段通りの生活が送れる手軽さが最大の魅力です。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('cd12d5f5', '3981cbec', 'デリケートな部分のために生まれた“究極の優しさ”', 'ローマピンクは、皮膚が薄く敏感なデリケートゾーン（VIO）や乳輪のために開発された専用処方です。美白効果で知られる「コウジ酸」や植物由来成分を配合し、肌への刺激を徹底的に考慮。セルフケアでは届かない領域を、プロの品質で優しくケアします。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('a9265a6d', '3981cbec', '“黒ずみ改善”と“ハリ感アップ”を同時に実現', 'ただ肌の色を明るくするだけではありません。ローマピンクは黒ずみの原因となるメラニンにアプローチすると同時に、真皮のコラーゲン生成を強力に促進します。これにより、肌のトーンアップに加え、失われがちなハリや弾力、うるおいを取り戻す「エイジングケア効果」も期待できます。「見た目の美しさ」と「ふっくらとした質感」の両方を追求できる施術です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('05f5b6a4', '3981cbec', '唇のくすみをなくして自然なピンク色にしたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('cb21fa6c', '3981cbec', '乳輪（バストトップ）の色を明るくしたい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('2d04f333', '3981cbec', 'デリケートゾーン（VIO）の黒ずみが気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('c5e68dcd', '3981cbec', 'ワキやひじ、ひざの色素沈着を改善したい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('59710054', '3981cbec', '自己処理によるカミソリ負けや肌荒れで色素沈着してしまった', 4);

-- アートメイク
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    'b4710627',
    NULL, -- subcategory_idは後で紐付け
    'アートメイク',
    'Permanent Makeup',
    'permanent-makeup',
    'https://ledianclinic.jp/service/permanent-makeup/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('da589b70', 'b4710627', '素顔に自信を与える、落ちないメイク', 'アートメイクは、毎日のメイクアップ不要で、あなたの素顔に確かな自信をもたらします。汗や水、皮脂、摩擦にも強く、ジムや旅行、雨の日など、どんなシーンでも美しい状態をキープ。毎朝のメイク時間を短縮し、メイク直しからも解放されます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('56d14176', 'b4710627', '肌への負担を最小限に、自然な仕上がりを追求', '最新技術と安全性の高い色素を使用し、肌のターンオーバーに合わせて徐々に薄くなるよう、非常に浅い皮膚層に色素を注入します。これにより、不自然な仕上がりや肌への負担を最小限に抑え、数年かけて自然に馴染んでいくため、ライフステージの変化にも柔軟に対応できます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('d164239e', 'b4710627', '一人ひとりの美しさを引き出す、完全オーダーメイドデザイン', '当院では、骨格、肌質、毛流れ、なりたいイメージを丁寧にカウンセリング。豊富な経験とデザイン力を持つ専門のアーティストが、ミリ単位での微調整を行い、お客様の個性を最大限に引き出す、オーダーメイドデザインをご提案します。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('09de34c8', 'b4710627', '毎朝のメイク時間を短縮したい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4b31b783', 'b4710627', '眉毛が薄い・まばらで悩んでいる', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('bf044abb', 'b4710627', '汗や水によるメイク崩れが気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('679ac249', 'b4710627', 'すっぴんに自信を持ちたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d8a412df', 'b4710627', '眉を左右対称に描くのが苦手', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('4f81788a', 'b4710627', '2時間～3時間程度（カウンセリング、デザイン、麻酔時間を含みます）', '赤み・腫れ：施術後数時間～2日程度かさぶた：施術後3日～1週間程度', 'アートメイクは色素の定着と美しい仕上がりのために、通常2回セットで施術を行います2回目の施術は、肌のターンオーバーに合わせて、1回目から1ヶ月～3ヶ月後に受けていただくのが理想的です', '施術部位以外は当日から可能施術部位へのメイクは、かさぶたが完全に剥がれ落ちるまで（約1週間）お控えください', 'シャワー・洗顔：当日から可能ですが、施術後1週間は施術部位を濡らさないようご注意ください入浴（湯船）・サウナ・プール・激しい運動：代謝が上がり、色素の定着を妨げる可能性があるため、施術後1週間はお控えください', '妊娠中・授乳中の方、または妊娠の可能性のある方、ケロイド体質の方、重度の金属アレルギーの方、施術部位に皮膚疾患や傷、重度のアトピー症状がある方、コントロール不良の糖尿病・高血圧・心疾患のある方');

-- ソプラノアイスプラチナム
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '370ad851',
    NULL, -- subcategory_idは後で紐付け
    'ソプラノアイスプラチナム',
    'Soprano ICE Platinum',
    'soprano-ice-platinum',
    'https://ledianclinic.jp/service/soprano-ice-platinum/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('ae9130c7', '370ad851', '3つの波長を同時照射し、あらゆる毛質を逃さない', '3つの波長（アレキサンドライト・ダイオード・YAG）を同時に照射する独自の技術で、深さの異なる毛根に一度でアプローチ。太い毛から産毛まであらゆる毛質に対応し、ムラのないスピーディーな脱毛を実現します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('d96dfbb9', '370ad851', '痛みを最小限に抑えた、温かく快適な「蓄熱式脱毛」', '低出力レーザーでじっくり熱を蓄える「蓄熱式脱毛」を採用。強力な冷却機能により痛みを大幅に軽減し、まるで温かいマッサージを受けているような快適な施術を提供します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('72d77d00', '370ad851', '日焼け肌や敏感肌もOK。肌質を選ばない安全性', '肌のメラニンへの反応が穏やかなため、日焼け肌や色黒肌、敏感肌など、これまで脱毛が難しかった肌質の方でも安全に施術できます。肌トラブルが心配で脱毛を諦めていた方にも安心の脱毛です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('c915bf00', '370ad851', '痛みに弱く、これまでの医療脱毛を断念した', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('8c37b822', '370ad851', '日焼け肌や地黒肌の方', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('d2f5a1cd', '370ad851', '肌がデリケートで、赤みやヒリつきが出やすい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('7090e321', '370ad851', 'アトピー性皮膚炎などの肌悩みがある', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('b3989271', '370ad851', '細い毛や産毛が多く、脱毛効果を感じにくい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('623c3168', '370ad851', '両ワキ：5〜10分程度全身脱毛：120分程度', 'ほとんどなし', '1ヶ月半～3ヶ月に1回程度', '施術当日から可能', '長時間の入浴は施術当日は控える', '妊娠中・授乳中の方、または妊娠の可能性のある方、光線過敏症の方、またはその可能性があるお薬を服用中の方、ケロイド体質の方、てんかん発作の既往がある方、施術部位に皮膚疾患（ヘルペスなど）や傷・タトゥーがある方、過度な日焼けをされている方');

-- 肌育注射
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '190957d9',
    NULL, -- subcategory_idは後で紐付け
    '肌育注射',
    'Skin Boosting Injection',
    'skin-boosting-injection',
    'https://ledianclinic.jp/service/skin-boosting-injection/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('70d57ba7', '190957d9', '肌の再生力向上', '外部から一時的に補うのではなく、肌細胞そのものに働きかけ、コラーゲンやエラスチンといった肌のハリ・弾力の元となる成分の生成を促します。これにより、肌本来の再生力・修復力を高めます。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('6e38d03c', '190957d9', '根本的な肌質改善', '表面的なケアとは異なり、肌の土台となる真皮層に直接アプローチするため、小じわ、たるみ、乾燥、毛穴の開きなど、複数の肌悩みを根本から改善し、総合的な肌質の底上げが目指せます。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('765bf872', '190957d9', '自然で持続的な効果', '自身の肌細胞が活性化されることで、仕上がりが非常に自然であり、効果も一時的ではなく持続性が期待できます。回数を重ねるごとに肌状態が安定し、健康的で美しい肌を維持しやすくなります。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('5c5d973c', '190957d9', '肌のハリ・弾力の低下が気になる', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('b87c60d5', '190957d9', '肌質を根本から改善したい', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('ee6b02ec', '190957d9', '乾燥肌がひどく、小じわが気になる', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('fc5e3613', '190957d9', '肌のメンテナンスをしたい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('697db2d2', '190957d9', '長期的な視点で肌の老化を予防したい', 4);

-- 肌診断
INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '47c4f65f',
    NULL, -- subcategory_idは後で紐付け
    '肌診断',
    'Eve V Muse',
    'eve-v-muse',
    'https://ledianclinic.jp/service/eve-v-muse/',
    NULL,
    NULL,
    'https://ledianclinic.jp/wp-content/themes/ledian/asset/image/header-logo.svg',
    0,
    datetime('now')
);

INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('b7406fb2', '47c4f65f', 'AIが導き出す「未来の肌予測」とパーソナル提案', '現在の肌状態を詳細に分析するだけでなく、毛穴、シワ、色素沈着、油分・水分量など12項目以上の肌状態をデータ化し、一人ひとりに合わせた最適な治療プランやスキンケアの提案を導き出します。', 0);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('1b830ebd', '47c4f65f', '肌の深層まで“見える化”する、最先端の撮影技術', '肉眼では見えない肌の奥に潜む「隠れジミ（潜在シミ）」や、ニキビの原因となるアクネ菌の代謝物（ポルフィリン）、皮脂の分布などを鮮明に映し出します。', 1);
INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('7baec5ec', '47c4f65f', '納得感と信頼を高める、優れたカウンセリングツール', '診断結果を分かりやすいグラフや比較画像でレポート化します。過去の診断データと並べて表示できるため、治療による肌の変化を時系列で確認することが可能です。', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('0af387fe', '47c4f65f', '自分の肌状態を正確に知りたい', 0);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('38ab08ce', '47c4f65f', '今使っているスキンケアや施術が合っているか不安', 1);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('e19eb16e', '47c4f65f', '効果的な美容プランを立てたい', 2);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('4bdbbc0b', '47c4f65f', '肌の変化を具体的に確認したい', 3);
INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('27ba2b9e', '47c4f65f', '将来の肌トラブルを予防したい', 4);
INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('0effde8f', '47c4f65f', '撮影:約5分程度', 'なし', '【おすすめのタイミング】治療コースの開始前と終了後、肌状態の定期チェック、新しい治療やスキンケアを始める前', '撮影時は完全に落としていただきます。正確な解析のため、日焼け止めや色付き下地もオフの状態で行います。※診断終了直後からメイク可能です。', '当日から可能', '妊娠中または授乳中の方、顔に傷や、重度の皮膚炎・感染症がある方、光に対して過敏な反応（光線過敏症）が出る方');
