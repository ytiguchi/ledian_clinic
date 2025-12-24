globalThis.process ??= {}; globalThis.process.env ??= {};
export { renderers } from '../../renderers.mjs';

const GET = async () => {
  try {
    const educationList = [
      { slug: "onda-pro", name_ja: "オンダリフト", name_en: "Onda Pro", category: "スキンケア" },
      { slug: "high-intensity-focused-ultrasound", name_ja: "ハイフ（HIFU）", name_en: "HIFU", category: "スキンケア" },
      { slug: "botox", name_ja: "ボトックス注射", name_en: "Botox", category: "ボトックス" },
      { slug: "hyaluronic-acid-2", name_ja: "ヒアルロン酸注入", name_en: "Hyaluronic Acid", category: "ヒアルロン酸" },
      { slug: "potenza", name_ja: "ポテンツァ", name_en: "Potenza", category: "スキンケア" },
      { slug: "pico-laser", name_ja: "ピコレーザー", name_en: "Pico Laser", category: "スキンケア" },
      { slug: "thread-lift", name_ja: "糸リフト", name_en: "Thread Lift", category: "糸リフト" },
      { slug: "stella-m22", name_ja: "フォトフェイシャル", name_en: "Stella M22", category: "スキンケア" },
      { slug: "soprano-ice-platinum", name_ja: "医療脱毛", name_en: "Soprano Ice", category: "医療脱毛" },
      { slug: "permanent-makeup", name_ja: "アートメイク", name_en: "Permanent Makeup", category: "アートメイク" },
      { slug: "carecys", name_ja: "ケアシス", name_en: "Carecys", category: "スキンケア" },
      { slug: "ellisys-sense", name_ja: "エリシスセンス", name_en: "Ellisys Sense", category: "スキンケア" },
      { slug: "trifill-pro", name_ja: "トライフィルプロ", name_en: "Trifill Pro", category: "スキンケア" },
      { slug: "lipodissolve-injection", name_ja: "脂肪溶解注射", name_en: "Lipodissolve", category: "脂肪溶解注射" },
      { slug: "skin-boosting-injection", name_ja: "肌育注射", name_en: "Skin Boosting", category: "肌育注射" },
      { slug: "massage-peel", name_ja: "マッサージピール", name_en: "Massage Peel", category: "スキンケア" },
      { slug: "hydra-gentle", name_ja: "ハイドラジェントル", name_en: "Hydra Gentle", category: "スキンケア" },
      { slug: "v-carbon-peel", name_ja: "Vカーボンピール", name_en: "V-Carbon Peel", category: "スキンケア" },
      { slug: "subcision", name_ja: "サブシジョン", name_en: "Subcision", category: "スキンケア" },
      { slug: "roma-pink", name_ja: "ローマピンク", name_en: "Roma Pink", category: "スキンケア" },
      { slug: "lhala-10-ldm", name_ja: "LDM", name_en: "LDM", category: "LDM" },
      { slug: "eve-v-muse", name_ja: "Eve V Muse", name_en: "Eve V Muse", category: "肌診断" }
    ];
    return new Response(JSON.stringify({
      total: educationList.length,
      items: educationList
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
};

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  GET
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
