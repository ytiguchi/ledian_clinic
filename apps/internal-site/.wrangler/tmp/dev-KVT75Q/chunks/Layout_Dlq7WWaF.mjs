globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, f as createAstro, h as addAttribute, al as renderHead, am as renderSlot, r as renderTemplate, k as renderComponent, l as renderScript, m as maybeRenderHead } from './astro/server_BRXg5whf.mjs';
/* empty css                        */

const $$Astro$1 = createAstro();
const $$BaseLayout = createComponent(($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro$1, $$props, $$slots);
  Astro2.self = $$BaseLayout;
  const { title, description = "\u30EC\u30C7\u30A3\u30A2\u30F3\u30AF\u30EA\u30CB\u30C3\u30AF \u793E\u5185\u7BA1\u7406\u30B5\u30A4\u30C8" } = Astro2.props;
  return renderTemplate`<html lang="ja"> <head><meta charset="UTF-8"><meta name="description"${addAttribute(description, "content")}><meta name="viewport" content="width=device-width, initial-scale=1.0"><link rel="icon" type="image/png" href="/favicon.png"><meta name="generator"${addAttribute(Astro2.generator, "content")}><title>${title}</title>${renderHead()}</head> <body> ${renderSlot($$result, $$slots["default"])} </body></html>`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/layouts/BaseLayout.astro", void 0);

const $$Astro = createAstro();
const $$Layout = createComponent(($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro, $$props, $$slots);
  Astro2.self = $$Layout;
  const currentPath = Astro2.url.pathname;
  const navItems = [
    { href: "/", icon: "\u{1F4CA}", label: "\u30C0\u30C3\u30B7\u30E5\u30DC\u30FC\u30C9" },
    { href: "/pricing", icon: "\u{1F4B0}", label: "\u6599\u91D1\u7BA1\u7406" },
    { href: "/campaigns", icon: "\u{1F381}", label: "\u30AD\u30E3\u30F3\u30DA\u30FC\u30F3" },
    { href: "/treatments", icon: "\u2728", label: "\u65BD\u8853\u7BA1\u7406" },
    { href: "/before-afters", icon: "\u{1F4F8}", label: "\u75C7\u4F8B\u5199\u771F" }
  ];
  function isActive(href) {
    if (href === "/") return currentPath === "/";
    return currentPath.startsWith(href);
  }
  return renderTemplate`${renderComponent($$result, "BaseLayout", $$BaseLayout, { "title": "\u30EC\u30C7\u30A3\u30A2\u30F3\u30AF\u30EA\u30CB\u30C3\u30AF \u7BA1\u7406\u30B5\u30A4\u30C8", "data-astro-cid-dmqsi53g": true }, { "default": ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="app-layout" data-astro-cid-dmqsi53g> <!-- Sidebar --> <aside class="sidebar" data-astro-cid-dmqsi53g> <div class="sidebar-header" data-astro-cid-dmqsi53g> <a href="/" class="logo" data-astro-cid-dmqsi53g> <img src="/images/header-logo.svg" alt="Ledian Clinic" class="logo-image" data-astro-cid-dmqsi53g> </a> <span class="logo-badge" data-astro-cid-dmqsi53g>管理システム</span> </div> <nav class="sidebar-nav" data-astro-cid-dmqsi53g> <ul class="nav-list" data-astro-cid-dmqsi53g> ${navItems.map((item) => renderTemplate`<li data-astro-cid-dmqsi53g> <a${addAttribute(item.href, "href")}${addAttribute(["nav-item", { active: isActive(item.href) }], "class:list")} data-astro-cid-dmqsi53g> <span class="nav-icon" data-astro-cid-dmqsi53g>${item.icon}</span> <span class="nav-label" data-astro-cid-dmqsi53g>${item.label}</span> ${isActive(item.href) && renderTemplate`<span class="nav-indicator" data-astro-cid-dmqsi53g></span>`} </a> </li>`)} </ul> </nav> <div class="sidebar-footer" data-astro-cid-dmqsi53g> <div class="user-info" data-astro-cid-dmqsi53g> <div class="user-avatar" data-astro-cid-dmqsi53g>👤</div> <div class="user-details" data-astro-cid-dmqsi53g> <span class="user-name" data-astro-cid-dmqsi53g>管理者</span> <span class="user-role" data-astro-cid-dmqsi53g>Administrator</span> </div> </div> </div> </aside> <!-- Main Content --> <div class="main-wrapper" data-astro-cid-dmqsi53g> <!-- Top Bar --> <header class="topbar" data-astro-cid-dmqsi53g> <button class="mobile-menu-btn" id="mobileMenuBtn" data-astro-cid-dmqsi53g> <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-dmqsi53g> <line x1="3" y1="6" x2="21" y2="6" data-astro-cid-dmqsi53g></line> <line x1="3" y1="12" x2="21" y2="12" data-astro-cid-dmqsi53g></line> <line x1="3" y1="18" x2="21" y2="18" data-astro-cid-dmqsi53g></line> </svg> </button> <div class="topbar-right" data-astro-cid-dmqsi53g> <div class="current-time" id="currentTime" data-astro-cid-dmqsi53g></div> <button class="notification-btn" data-astro-cid-dmqsi53g> <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-dmqsi53g> <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" data-astro-cid-dmqsi53g></path> <path d="M13.73 21a2 2 0 0 1-3.46 0" data-astro-cid-dmqsi53g></path> </svg> <span class="notification-dot" data-astro-cid-dmqsi53g></span> </button> </div> </header> <!-- Page Content --> <main class="main-content" data-astro-cid-dmqsi53g> ${renderSlot($$result2, $$slots["default"])} </main> </div> </div>  <div class="mobile-overlay" id="mobileOverlay" data-astro-cid-dmqsi53g></div> ` })}  ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/components/Layout.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/components/Layout.astro", void 0);

export { $$Layout as $ };
