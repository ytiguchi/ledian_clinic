globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../../chunks/Layout_Dlq7WWaF.mjs';
export { renderers } from '../../renderers.mjs';

const $$New = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, {}, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="max-w-4xl mx-auto space-y-6"> <div> <a href="/pricing" class="text-accent hover:underline">← 料金管理に戻る</a> <h2 class="text-3xl font-bold mt-4">新規プラン追加</h2> </div> <form class="bg-white rounded-lg shadow p-6 space-y-6" id="pricePlanForm"> <!-- 基本情報 --> <div> <h3 class="text-xl font-semibold mb-4">基本情報</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">カテゴリ</label> <select name="category" id="categorySelect" class="w-full px-4 py-2 border rounded-lg" required> <option value="">選択してください</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">サブカテゴリ</label> <select name="subcategory" id="subcategorySelect" class="w-full px-4 py-2 border rounded-lg" required> <option value="">選択してください</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">施術</label> <select name="treatment" id="treatmentSelect" class="w-full px-4 py-2 border rounded-lg" required> <option value="">選択してください</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">プラン名</label> <input type="text" name="planName" placeholder="例: 1回、3回、200S" class="w-full px-4 py-2 border rounded-lg" required> </div> </div> </div> <!-- 価格情報 --> <div> <h3 class="text-xl font-semibold mb-4">価格情報</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">税抜価格（円）</label> <input type="number" name="price" placeholder="22600" class="w-full px-4 py-2 border rounded-lg" required> </div> <div> <label class="block text-sm font-medium mb-1">税込価格（円）</label> <input type="number" name="priceTaxed" placeholder="24860" class="w-full px-4 py-2 border rounded-lg" required> </div> <div> <label class="block text-sm font-medium mb-1">回数</label> <input type="number" name="sessions" placeholder="例: 3" class="w-full px-4 py-2 border rounded-lg"> </div> <div> <label class="block text-sm font-medium mb-1">プラン種別</label> <select name="planType" class="w-full px-4 py-2 border rounded-lg" required> <option value="single">単発</option> <option value="course">回数コース</option> <option value="trial">初回お試し</option> <option value="monitor">モニター価格</option> <option value="campaign">キャンペーン</option> </select> </div> </div> </div> <!-- 原価情報 --> <div> <h3 class="text-xl font-semibold mb-4">原価情報</h3> <div class="grid grid-cols-1 md:grid-cols-3 gap-4"> <div> <label class="block text-sm font-medium mb-1">原価率（%）</label> <input type="number" name="costRate" step="0.1" placeholder="9.3" class="w-full px-4 py-2 border rounded-lg"> </div> <div> <label class="block text-sm font-medium mb-1">備品原価（円）</label> <input type="number" name="supplyCost" placeholder="100" class="w-full px-4 py-2 border rounded-lg"> </div> <div> <label class="block text-sm font-medium mb-1">人件費（円）</label> <input type="number" name="staffCost" placeholder="2000" class="w-full px-4 py-2 border rounded-lg"> </div> </div> </div> <!-- アクション --> <div class="flex justify-end gap-4 pt-4 border-t"> <a href="/pricing" class="px-6 py-2 border rounded-lg hover:bg-gray-50 transition">
キャンセル
</a> <button type="submit" class="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent-light transition">
保存
</button> </div> </form> </div> ` })} ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/new.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/new.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/new.astro";
const $$url = "/pricing/new";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$New,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
