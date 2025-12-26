import type { APIRoute } from 'astro';

// クロールした教育コンテンツを返すAPI
// data/content/treatments/crawled/ からJSONを読み込む

export const GET: APIRoute = async ({ params }) => {
  const { slug } = params;
  
  if (!slug) {
    return new Response(JSON.stringify({ error: 'Slug is required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' }
    });
  }

  try {
    // 静的にインポートした教育コンテンツマッピング
    const educationContent = await getEducationContent(slug);
    
    if (!educationContent) {
      return new Response(JSON.stringify({ 
        error: 'Content not found',
        slug 
      }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    return new Response(JSON.stringify(educationContent), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Education content API error:', error);
    return new Response(JSON.stringify({ 
      error: 'Internal server error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// 教育コンテンツのマッピング（クロールデータから）
async function getEducationContent(slug: string) {
  // slugの正規化（URL encoded → decoded）
  const decodedSlug = decodeURIComponent(slug).toLowerCase();
  
  // 施術名からslugへのマッピング
  const contentMap: Record<string, any> = {
    'onda-pro': {
      name_ja: 'オンダリフト',
      name_en: 'Onda Pro',
      url: 'https://ledianclinic.jp/service/onda-pro/',
      description: '顔や体の気になる部分の脂肪を溶かす、最新の痩身美容治療です。世界で初めて特許を取った2.45Ghzのマイクロ波を使い、肌の表面を傷つけずに脂肪の層にだけ熱を届けます。',
      about: '～痛くない医療痩身～ 顔や体の気になる部分の脂肪を溶かす、最新の痩身美容治療です。世界で初めて特許を取った2.45Ghzのマイクロ波を使い、肌の表面を傷つけずに脂肪の層にだけ熱を届けます。マイクロ波の熱で脂肪が減り、同時に肌が引き締まります。',
      features: [
        { title: '独自技術「Coolwaves®」による高い効果と安全性', description: 'Coolwaves®は、2.45GHzという特殊な周波数のマイクロ波を使用。皮膚へのダメージを最小限に抑えながら、脂肪細胞だけを選択的に加熱・破壊します。' },
        { title: '「脂肪減少」「セルライト改善」「引き締め」のトリプルアクション', description: '脂肪細胞を選択的に破壊し、セルライトの原因である硬い線維組織に働きかけ、コラーゲン生成を促進します。' }
      ],
      overview: {
        '施術時間': '1部位10〜15分程度',
        'ダウンタイム': 'ほとんどなし',
        '施術頻度': '顔:2週間に1回 体:4週間に1回',
        'メイク': '直後から可能'
      },
      faqs: [
        { question: '痛みはありますか？', answer: 'オンダプロは、強力な冷却システムで皮膚表面を保護しながら施術を行うため、痛みはほとんどありません。' },
        { question: '何回くらい施術を受ければ効果が出ますか？', answer: '1回でも効果は実感頂けますが、より確実な効果のため4〜5回程度の施術をおすすめしています。' },
        { question: 'リバウンドの心配はありませんか？', answer: '脂肪細胞そのものを破壊するため、リバウンドの心配は非常に少ないです。' }
      ]
    },
    'high-intensity-focused-ultrasound': {
      name_ja: 'ハイフ（HIFU）',
      name_en: 'High Intensity Focused Ultrasound',
      url: 'https://ledianclinic.jp/service/high-intensity-focused-ultrasound/',
      description: '超音波エネルギーを一点に集中させ、肌の奥深くにあるSMAS層に熱を届けることで、メスを使わずにリフトアップ効果を実現する施術です。',
      features: [
        { title: '切らないフェイスリフト', description: 'メスを使わずにリフトアップが可能。ダウンタイムもほとんどありません。' },
        { title: 'SMAS層へ直接アプローチ', description: '従来の美容機器では届かなかったSMAS層まで超音波が届きます。' }
      ],
      faqs: [
        { question: '痛みはありますか？', answer: '骨に近い部分では熱感を感じることがありますが、冷却しながら施術を行うため耐えられる程度です。' },
        { question: '効果はどのくらい持続しますか？', answer: '個人差はありますが、約6ヶ月〜1年程度持続します。' }
      ]
    },
    'botox': {
      name_ja: 'ボトックス注射',
      name_en: 'Botox Injection',
      url: 'https://ledianclinic.jp/service/botox/',
      description: 'ボツリヌストキシン製剤を筋肉に注入し、表情ジワの改善やエラの縮小、多汗症の治療などに効果を発揮する施術です。',
      features: [
        { title: '表情ジワの改善', description: '眉間・目尻・額などの表情ジワを自然に改善します。' },
        { title: 'エラ縮小・小顔効果', description: '咬筋にボトックスを注入することで、エラ張りを改善し小顔効果が得られます。' }
      ],
      faqs: [
        { question: '効果はどのくらいで現れますか？', answer: '注入後2〜3日で効果が現れ始め、1〜2週間で安定します。' },
        { question: '効果はどのくらい持続しますか？', answer: '個人差はありますが、約3〜6ヶ月持続します。' }
      ]
    },
    'hyaluronic-acid-2': {
      name_ja: 'ヒアルロン酸注入',
      name_en: 'Hyaluronic Acid Injection',
      url: 'https://ledianclinic.jp/service/hyaluronic-acid-2/',
      description: 'ヒアルロン酸を注入することで、シワの改善、唇のボリュームアップ、涙袋形成など様々な部位のお悩みを解決します。',
      features: [
        { title: '即効性のある効果', description: '注入直後から効果を実感できます。' },
        { title: '自然な仕上がり', description: '熟練の技術で自然な仕上がりを実現します。' }
      ],
      faqs: [
        { question: '痛みはありますか？', answer: '麻酔クリームや笑気麻酔を使用しますので、痛みは最小限です。' },
        { question: '持続期間はどのくらいですか？', answer: '部位や製剤により異なりますが、6ヶ月〜1年半程度です。' }
      ]
    },
    'potenza': {
      name_ja: 'ポテンツァ',
      name_en: 'Potenza',
      url: 'https://ledianclinic.jp/service/potenza/',
      description: 'マイクロニードルRFで肌の奥深くにエネルギーを届け、ニキビ跡・毛穴・肝斑など様々な肌悩みに対応する最新美肌治療です。',
      features: [
        { title: 'マイクロニードルRF', description: '極細の針からRFエネルギーを照射し、ダウンタイムを抑えながら効果的に治療します。' },
        { title: '様々な肌悩みに対応', description: 'チップを変えることで、ニキビ跡・毛穴・シワ・肝斑など幅広い悩みに対応します。' }
      ],
      faqs: [
        { question: 'ダウンタイムはありますか？', answer: '赤みが1〜2日程度出ることがありますが、翌日からメイク可能です。' }
      ]
    },
    'pico-laser': {
      name_ja: 'ピコレーザー',
      name_en: 'Pico Laser',
      url: 'https://ledianclinic.jp/service/pico-laser/',
      description: 'ピコ秒（1兆分の1秒）の超短パルスレーザーで、シミ・そばかす・刺青除去など様々な色素トラブルを改善します。',
      features: [
        { title: '超短パルスで肌に優しい', description: '従来のレーザーより短いパルスで、肌へのダメージを最小限に抑えます。' },
        { title: '様々な色素に対応', description: 'シミ、そばかす、肝斑、刺青など幅広い色素トラブルに効果的です。' }
      ],
      faqs: [
        { question: '何回くらいで効果が出ますか？', answer: 'シミの種類により異なりますが、1〜5回程度で改善が期待できます。' }
      ]
    },
    'thread-lift': {
      name_ja: '糸リフト',
      name_en: 'Thread Lift',
      url: 'https://ledianclinic.jp/service/thread-lift/',
      description: '溶ける医療用の糸を皮下に挿入し、たるみを物理的に引き上げる施術です。即効性があり、自然なリフトアップ効果が得られます。',
      features: [
        { title: '即効性のあるリフトアップ', description: '施術直後からリフトアップ効果を実感できます。' },
        { title: 'コラーゲン生成促進', description: '糸の周りにコラーゲンが生成され、肌質改善効果も期待できます。' }
      ],
      faqs: [
        { question: 'ダウンタイムはありますか？', answer: '腫れや内出血が1週間程度続くことがあります。' },
        { question: '効果はどのくらい持続しますか？', answer: '糸の種類により異なりますが、1〜2年程度持続します。' }
      ]
    },
    'stella-m22': {
      name_ja: 'フォトフェイシャル（ステラM22）',
      name_en: 'Stella M22',
      url: 'https://ledianclinic.jp/service/stella-m22/',
      description: 'IPL（光治療）で、シミ・くすみ・赤ら顔・毛穴など複合的な肌悩みを1台で改善する人気の美肌治療です。',
      features: [
        { title: '複合的な肌悩みに対応', description: 'シミ、くすみ、赤ら顔、毛穴など様々な悩みを同時に改善します。' },
        { title: 'ダウンタイムがほとんどない', description: '施術後すぐにメイクが可能です。' }
      ],
      faqs: [
        { question: '痛みはありますか？', answer: 'ゴムで弾かれる程度の軽い痛みです。' },
        { question: '何回くらいの施術が必要ですか？', answer: '3〜5回の施術をおすすめしています。' }
      ]
    },
    'soprano-ice-platinum': {
      name_ja: '医療脱毛（ソプラノアイス）',
      name_en: 'Soprano Ice Platinum',
      url: 'https://ledianclinic.jp/service/soprano-ice-platinum/',
      description: '蓄熱式脱毛器「ソプラノアイスプラチナム」による、痛みの少ない医療脱毛です。',
      features: [
        { title: '痛みが少ない蓄熱式', description: 'じんわり温かい程度で、痛みが苦手な方にもおすすめです。' },
        { title: '様々な毛質・肌色に対応', description: '産毛から剛毛まで、日焼け肌にも対応可能です。' }
      ],
      faqs: [
        { question: '何回くらいで終わりますか？', answer: '部位により異なりますが、5〜8回程度で満足いく結果が得られます。' }
      ]
    },
    'permanent-makeup': {
      name_ja: 'アートメイク',
      name_en: 'Permanent Makeup',
      url: 'https://ledianclinic.jp/service/permanent-makeup/',
      description: '眉・リップ・アイラインなど、専用の色素を皮膚に定着させるメイクアップ施術です。',
      features: [
        { title: '自然な仕上がり', description: '手彫りとマシンを組み合わせ、自然で美しい仕上がりを実現します。' },
        { title: '朝のメイク時間短縮', description: '毎日のメイク時間を大幅に短縮できます。' }
      ],
      faqs: [
        { question: '痛みはありますか？', answer: '麻酔クリームを使用するため、痛みはほとんどありません。' },
        { question: '持続期間はどのくらいですか？', answer: '1〜3年程度持続しますが、定期的なリタッチをおすすめします。' }
      ]
    }
  };

  return contentMap[decodedSlug] || null;
}


