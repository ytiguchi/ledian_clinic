globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, f as createAstro, r as renderTemplate, n as defineScriptVars, k as renderComponent, m as maybeRenderHead } from '../../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../../chunks/Layout_Dlq7WWaF.mjs';
/* empty css                                     */
export { renderers } from '../../renderers.mjs';

var __freeze = Object.freeze;
var __defProp = Object.defineProperty;
var __template = (cooked, raw) => __freeze(__defProp(cooked, "raw", { value: __freeze(raw || cooked.slice()) }));
var _a;
const $$Astro = createAstro();
const $$slug = createComponent(async ($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro, $$props, $$slots);
  Astro2.self = $$slug;
  const { slug } = Astro2.params;
  return renderTemplate(_a || (_a = __template(["", "  <script>(function(){", `
  async function loadEducationContent() {
    const loadingState = document.getElementById('loadingState');
    const contentContainer = document.getElementById('contentContainer');
    const notFoundState = document.getElementById('notFoundState');

    try {
      const res = await fetch(\`/api/education/\${slug}\`);
      
      if (!res.ok) {
        loadingState.style.display = 'none';
        notFoundState.style.display = 'block';
        return;
      }

      const data = await res.json();
      
      if (!data || data.error) {
        loadingState.style.display = 'none';
        notFoundState.style.display = 'block';
        return;
      }

      // Populate content
      document.getElementById('treatmentName').textContent = data.name_ja || '';
      document.getElementById('treatmentNameEn').textContent = data.name_en || '';
      document.getElementById('categoryLabel').textContent = data.category || '\u65BD\u8853';
      
      if (data.url) {
        document.getElementById('sourceLink').href = data.url;
      }

      // About
      const aboutSection = document.getElementById('aboutSection');
      if (data.about || data.description) {
        document.getElementById('aboutText').textContent = data.about || data.description;
      } else {
        aboutSection.style.display = 'none';
      }

      // Features
      const featuresSection = document.getElementById('featuresSection');
      const featuresGrid = document.getElementById('featuresGrid');
      if (data.features && data.features.length > 0) {
        featuresGrid.innerHTML = data.features.map(f => \`
          <div class="feature-card">
            <h4 class="feature-title">\${escapeHtml(f.title)}</h4>
            <p class="feature-desc">\${escapeHtml(f.description)}</p>
          </div>
        \`).join('');
      } else {
        featuresSection.style.display = 'none';
      }

      // Overview
      const overviewSection = document.getElementById('overviewSection');
      const overviewTable = document.getElementById('overviewTable');
      if (data.overview && Object.keys(data.overview).length > 0) {
        overviewTable.innerHTML = Object.entries(data.overview)
          .filter(([key]) => key !== '\u9805\u76EE' && key !== '\u5185\u5BB9')
          .map(([key, value]) => \`
            <div class="overview-row">
              <div class="overview-label">\${escapeHtml(key)}</div>
              <div class="overview-value">\${escapeHtml(value)}</div>
            </div>
          \`).join('');
      } else {
        overviewSection.style.display = 'none';
      }

      // FAQ
      const faqSection = document.getElementById('faqSection');
      const faqList = document.getElementById('faqList');
      if (data.faqs && data.faqs.length > 0) {
        faqList.innerHTML = data.faqs.map(faq => \`
          <div class="faq-item">
            <h4 class="faq-question">\${escapeHtml(faq.question)}</h4>
            <p class="faq-answer">\${escapeHtml(faq.answer)}</p>
          </div>
        \`).join('');
      } else {
        faqSection.style.display = 'none';
      }

      loadingState.style.display = 'none';
      contentContainer.style.display = 'block';

    } catch (error) {
      console.error('Error loading education content:', error);
      loadingState.style.display = 'none';
      notFoundState.style.display = 'block';
    }
  }

  function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  document.addEventListener('DOMContentLoaded', loadEducationContent);
})();<\/script>`], ["", "  <script>(function(){", `
  async function loadEducationContent() {
    const loadingState = document.getElementById('loadingState');
    const contentContainer = document.getElementById('contentContainer');
    const notFoundState = document.getElementById('notFoundState');

    try {
      const res = await fetch(\\\`/api/education/\\\${slug}\\\`);
      
      if (!res.ok) {
        loadingState.style.display = 'none';
        notFoundState.style.display = 'block';
        return;
      }

      const data = await res.json();
      
      if (!data || data.error) {
        loadingState.style.display = 'none';
        notFoundState.style.display = 'block';
        return;
      }

      // Populate content
      document.getElementById('treatmentName').textContent = data.name_ja || '';
      document.getElementById('treatmentNameEn').textContent = data.name_en || '';
      document.getElementById('categoryLabel').textContent = data.category || '\u65BD\u8853';
      
      if (data.url) {
        document.getElementById('sourceLink').href = data.url;
      }

      // About
      const aboutSection = document.getElementById('aboutSection');
      if (data.about || data.description) {
        document.getElementById('aboutText').textContent = data.about || data.description;
      } else {
        aboutSection.style.display = 'none';
      }

      // Features
      const featuresSection = document.getElementById('featuresSection');
      const featuresGrid = document.getElementById('featuresGrid');
      if (data.features && data.features.length > 0) {
        featuresGrid.innerHTML = data.features.map(f => \\\`
          <div class="feature-card">
            <h4 class="feature-title">\\\${escapeHtml(f.title)}</h4>
            <p class="feature-desc">\\\${escapeHtml(f.description)}</p>
          </div>
        \\\`).join('');
      } else {
        featuresSection.style.display = 'none';
      }

      // Overview
      const overviewSection = document.getElementById('overviewSection');
      const overviewTable = document.getElementById('overviewTable');
      if (data.overview && Object.keys(data.overview).length > 0) {
        overviewTable.innerHTML = Object.entries(data.overview)
          .filter(([key]) => key !== '\u9805\u76EE' && key !== '\u5185\u5BB9')
          .map(([key, value]) => \\\`
            <div class="overview-row">
              <div class="overview-label">\\\${escapeHtml(key)}</div>
              <div class="overview-value">\\\${escapeHtml(value)}</div>
            </div>
          \\\`).join('');
      } else {
        overviewSection.style.display = 'none';
      }

      // FAQ
      const faqSection = document.getElementById('faqSection');
      const faqList = document.getElementById('faqList');
      if (data.faqs && data.faqs.length > 0) {
        faqList.innerHTML = data.faqs.map(faq => \\\`
          <div class="faq-item">
            <h4 class="faq-question">\\\${escapeHtml(faq.question)}</h4>
            <p class="faq-answer">\\\${escapeHtml(faq.answer)}</p>
          </div>
        \\\`).join('');
      } else {
        faqSection.style.display = 'none';
      }

      loadingState.style.display = 'none';
      contentContainer.style.display = 'block';

    } catch (error) {
      console.error('Error loading education content:', error);
      loadingState.style.display = 'none';
      notFoundState.style.display = 'block';
    }
  }

  function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  document.addEventListener('DOMContentLoaded', loadEducationContent);
})();<\/script>`])), renderComponent($$result, "Layout", $$Layout, { "data-astro-cid-ug3wqzng": true }, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="education-page" data-astro-cid-ug3wqzng> <!-- Breadcrumb --> <div class="breadcrumb" data-astro-cid-ug3wqzng> <a href="/treatments" class="breadcrumb-link" data-astro-cid-ug3wqzng> <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-ug3wqzng> <path d="M19 12H5M12 19l-7-7 7-7" data-astro-cid-ug3wqzng></path> </svg>
施術管理に戻る
</a> </div> <!-- Loading State --> <div id="loadingState" class="loading-container" data-astro-cid-ug3wqzng> <div class="loading" data-astro-cid-ug3wqzng>教育コンテンツを読み込み中...</div> </div> <!-- Content Container --> <div id="contentContainer" style="display: none;" data-astro-cid-ug3wqzng> <!-- Header --> <div class="education-header" data-astro-cid-ug3wqzng> <div class="header-info" data-astro-cid-ug3wqzng> <span class="header-label" id="categoryLabel" data-astro-cid-ug3wqzng></span> <h1 class="header-title" id="treatmentName" data-astro-cid-ug3wqzng></h1> <p class="header-subtitle" id="treatmentNameEn" data-astro-cid-ug3wqzng></p> </div> <a id="sourceLink" href="#" target="_blank" class="source-link" data-astro-cid-ug3wqzng>
公式サイトで見る
<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-ug3wqzng> <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6M15 3h6v6M10 14L21 3" data-astro-cid-ug3wqzng></path> </svg> </a> </div> <!-- About Section --> <section class="content-section" id="aboutSection" data-astro-cid-ug3wqzng> <div class="section-header" data-astro-cid-ug3wqzng> <h2 class="section-title" data-astro-cid-ug3wqzng> <span class="section-icon" data-astro-cid-ug3wqzng>📝</span>
施術について
</h2> </div> <div class="section-body" data-astro-cid-ug3wqzng> <p class="about-text" id="aboutText" data-astro-cid-ug3wqzng></p> </div> </section> <!-- Features Section --> <section class="content-section" id="featuresSection" data-astro-cid-ug3wqzng> <div class="section-header" data-astro-cid-ug3wqzng> <h2 class="section-title" data-astro-cid-ug3wqzng> <span class="section-icon" data-astro-cid-ug3wqzng>✨</span>
特徴・こだわり
</h2> </div> <div class="section-body" data-astro-cid-ug3wqzng> <div class="features-grid" id="featuresGrid" data-astro-cid-ug3wqzng></div> </div> </section> <!-- Overview Section --> <section class="content-section" id="overviewSection" data-astro-cid-ug3wqzng> <div class="section-header" data-astro-cid-ug3wqzng> <h2 class="section-title" data-astro-cid-ug3wqzng> <span class="section-icon" data-astro-cid-ug3wqzng>📋</span>
施術概要
</h2> </div> <div class="section-body" data-astro-cid-ug3wqzng> <div class="overview-table" id="overviewTable" data-astro-cid-ug3wqzng></div> </div> </section> <!-- FAQ Section --> <section class="content-section" id="faqSection" data-astro-cid-ug3wqzng> <div class="section-header" data-astro-cid-ug3wqzng> <h2 class="section-title" data-astro-cid-ug3wqzng> <span class="section-icon" data-astro-cid-ug3wqzng>❓</span>
よくある質問（スタッフ学習用）
</h2> </div> <div class="section-body" data-astro-cid-ug3wqzng> <div class="faq-list" id="faqList" data-astro-cid-ug3wqzng></div> </div> </section> <!-- Training Tips --> <section class="content-section training-section" data-astro-cid-ug3wqzng> <div class="section-header" data-astro-cid-ug3wqzng> <h2 class="section-title" data-astro-cid-ug3wqzng> <span class="section-icon" data-astro-cid-ug3wqzng>💡</span>
カウンセリングポイント
</h2> </div> <div class="section-body" data-astro-cid-ug3wqzng> <div class="training-tips" data-astro-cid-ug3wqzng> <div class="tip-card" data-astro-cid-ug3wqzng> <h4 data-astro-cid-ug3wqzng>患者様への説明ポイント</h4> <ul data-astro-cid-ug3wqzng> <li data-astro-cid-ug3wqzng>施術の効果とメリットを分かりやすく説明</li> <li data-astro-cid-ug3wqzng>ダウンタイムや副作用についても正直に伝える</li> <li data-astro-cid-ug3wqzng>期待値を適切に設定（過度な期待を避ける）</li> </ul> </div> <div class="tip-card" data-astro-cid-ug3wqzng> <h4 data-astro-cid-ug3wqzng>よくある質問への対応</h4> <ul data-astro-cid-ug3wqzng> <li data-astro-cid-ug3wqzng>FAQの内容を理解し、自分の言葉で説明できるようにする</li> <li data-astro-cid-ug3wqzng>不明点は医師に確認することを忘れずに</li> </ul> </div> <div class="tip-card" data-astro-cid-ug3wqzng> <h4 data-astro-cid-ug3wqzng>クロスセル・アップセル</h4> <ul data-astro-cid-ug3wqzng> <li data-astro-cid-ug3wqzng>関連施術との組み合わせ提案を検討</li> <li data-astro-cid-ug3wqzng>コース契約のメリットを説明</li> </ul> </div> </div> </div> </section> </div> <!-- Not Found State --> <div id="notFoundState" style="display: none;" class="not-found" data-astro-cid-ug3wqzng> <div class="not-found-icon" data-astro-cid-ug3wqzng>📭</div> <h2 data-astro-cid-ug3wqzng>教育コンテンツが見つかりません</h2> <p data-astro-cid-ug3wqzng>この施術の教育コンテンツはまだ登録されていません。</p> <a href="/treatments" class="btn btn-primary" data-astro-cid-ug3wqzng>施術一覧に戻る</a> </div> </div> ` }), defineScriptVars({ slug }));
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/education/[slug].astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/education/[slug].astro";
const $$url = "/education/[slug]";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$slug,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
