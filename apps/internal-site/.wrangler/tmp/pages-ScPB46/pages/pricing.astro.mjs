globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_DMabXZY_.mjs';
import { $ as $$Layout } from '../chunks/Layout_Da37j1AH.mjs';
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, {}, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="space-y-6"> <div class="flex justify-between items-center"> <h2 class="text-3xl font-bold">料金管理</h2> <a href="/pricing/new" class="bg-accent text-white px-4 py-2 rounded-lg hover:bg-accent-light transition">
+ 新規プラン追加
</a> </div> <!-- Search & Filter --> <div class="bg-white rounded-lg shadow p-6"> <div class="grid grid-cols-1 md:grid-cols-3 gap-4"> <input type="text" placeholder="施術名で検索..." class="px-4 py-2 border rounded-lg" id="searchInput"> <select class="px-4 py-2 border rounded-lg" id="categoryFilter"> <option value="">すべてのカテゴリ</option> </select> <button class="bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary-light transition">
検索
</button> </div> </div> <!-- Price Table --> <div class="bg-white rounded-lg shadow overflow-hidden"> <table class="w-full"> <thead class="bg-gray-50"> <tr> <th class="px-4 py-3 text-left font-semibold">カテゴリ</th> <th class="px-4 py-3 text-left font-semibold">施術名</th> <th class="px-4 py-3 text-left font-semibold">プラン</th> <th class="px-4 py-3 text-right font-semibold">税抜価格</th> <th class="px-4 py-3 text-right font-semibold">税込価格</th> <th class="px-4 py-3 text-right font-semibold">キャンペーン価格</th> <th class="px-4 py-3 text-center font-semibold">操作</th> </tr> </thead> <tbody id="priceTableBody"> <tr> <td colspan="7" class="px-4 py-8 text-center text-gray-500">
データを読み込み中...
</td> </tr> </tbody> </table> </div> </div> ` })} ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/index.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/index.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/index.astro";
const $$url = "/pricing";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
