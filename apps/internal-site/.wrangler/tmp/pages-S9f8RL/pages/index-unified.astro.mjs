globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../chunks/Layout_Dlq7WWaF.mjs';
export { renderers } from '../renderers.mjs';

const $$IndexUnified = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, {}, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="space-y-8"> <div> <h2 class="text-3xl font-bold mb-4">ダッシュボード</h2> <p class="text-gray-600">レディアンクリニックのメニュー・料金管理システム</p> </div> <!-- Stats Cards --> <div class="grid grid-cols-1 md:grid-cols-3 gap-6"> <div class="bg-white rounded-lg shadow p-6"> <h3 class="text-lg font-semibold mb-2">カテゴリ数</h3> <p class="text-3xl font-bold text-accent" id="categoryCount">-</p> <p class="text-sm text-gray-500 mt-2">管理中のカテゴリ</p> </div> <div class="bg-white rounded-lg shadow p-6"> <h3 class="text-lg font-semibold mb-2">施術数</h3> <p class="text-3xl font-bold text-accent" id="treatmentCount">-</p> <p class="text-sm text-gray-500 mt-2">登録済み施術</p> </div> <div class="bg-white rounded-lg shadow p-6"> <h3 class="text-lg font-semibold mb-2">プラン数</h3> <p class="text-3xl font-bold text-accent" id="planCount">-</p> <p class="text-sm text-gray-500 mt-2">料金プラン</p> </div> </div> <!-- Quick Actions --> <div class="bg-white rounded-lg shadow p-6"> <h3 class="text-xl font-semibold mb-4">クイックアクション</h3> <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4"> <a href="/pricing" class="block p-4 border-2 border-accent rounded-lg hover:bg-accent-light transition text-center"> <span class="text-2xl mb-2 block">💰</span> <span class="font-semibold">料金管理</span> </a> <a href="/campaigns" class="block p-4 border-2 border-accent rounded-lg hover:bg-accent-light transition text-center"> <span class="text-2xl mb-2 block">🎁</span> <span class="font-semibold">キャンペーン</span> </a> <a href="/treatments" class="block p-4 border-2 border-accent rounded-lg hover:bg-accent-light transition text-center"> <span class="text-2xl mb-2 block">✨</span> <span class="font-semibold">施術管理</span> </a> <a href="/before-afters" class="block p-4 border-2 border-accent rounded-lg hover:bg-accent-light transition text-center"> <span class="text-2xl mb-2 block">📸</span> <span class="font-semibold">症例写真</span> </a> </div> </div> <!-- Recent Activity --> <div class="bg-white rounded-lg shadow p-6"> <h3 class="text-xl font-semibold mb-4">最近の更新</h3> <div class="text-center text-gray-500 py-8"> <p>機能実装予定</p> </div> </div> </div> ` })} ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/index-unified.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/index-unified.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/index-unified.astro";
const $$url = "/index-unified";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$IndexUnified,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
