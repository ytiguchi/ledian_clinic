globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, f as createAstro, h as addAttribute, o as renderHead, p as renderSlot, r as renderTemplate, k as renderComponent, m as maybeRenderHead } from './astro/server_DMabXZY_.mjs';
/* empty css                        */

const $$Astro = createAstro();
const $$BaseLayout = createComponent(($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro, $$props, $$slots);
  Astro2.self = $$BaseLayout;
  const { title, description = "\u30EC\u30C7\u30A3\u30A2\u30F3\u30AF\u30EA\u30CB\u30C3\u30AF \u793E\u5185\u7BA1\u7406\u30B5\u30A4\u30C8" } = Astro2.props;
  return renderTemplate`<html lang="ja"> <head><meta charset="UTF-8"><meta name="description"${addAttribute(description, "content")}><meta name="viewport" content="width=device-width, initial-scale=1.0"><link rel="icon" type="image/svg+xml" href="/favicon.svg"><meta name="generator"${addAttribute(Astro2.generator, "content")}><title>${title}</title>${renderHead()}</head> <body class="bg-bg text-gray-900 antialiased"> ${renderSlot($$result, $$slots["default"])} </body></html>`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/layouts/BaseLayout.astro", void 0);

const $$Layout = createComponent(($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "BaseLayout", $$BaseLayout, { "title": "\u30EC\u30C7\u30A3\u30A2\u30F3\u30AF\u30EA\u30CB\u30C3\u30AF \u7BA1\u7406\u30B5\u30A4\u30C8" }, { "default": ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="min-h-screen bg-bg"> <!-- Header --> <header class="bg-primary text-white shadow-md"> <div class="container mx-auto px-4 py-4"> <div class="flex items-center justify-between"> <h1 class="text-2xl font-bold">Ledian Clinic 管理サイト</h1> <nav class="flex gap-4"> <a href="/" class="hover:text-accent transition">ダッシュボード</a> <a href="/pricing" class="hover:text-accent transition">料金管理</a> <a href="/campaigns" class="hover:text-accent transition">キャンペーン</a> <a href="/treatments" class="hover:text-accent transition">施術管理</a> <a href="/before-afters" class="hover:text-accent transition">症例写真</a> </nav> </div> </div> </header> <!-- Main Content --> <main class="container mx-auto px-4 py-8"> ${renderSlot($$result2, $$slots["default"])} </main> <!-- Footer --> <footer class="bg-primary text-white mt-auto"> <div class="container mx-auto px-4 py-4 text-center text-sm"> <p>&copy; 2024 Ledian Clinic. All rights reserved.</p> </div> </footer> </div> ` })}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/components/Layout.astro", void 0);

export { $$Layout as $ };
