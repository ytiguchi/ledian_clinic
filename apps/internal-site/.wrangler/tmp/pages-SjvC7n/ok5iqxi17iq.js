// <define:__ROUTES__>
var define_ROUTES_default = {
  version: 1,
  include: [
    "/*"
  ],
  exclude: [
    "/_astro/*",
    "/favicon.png",
    "/images/*"
  ]
};

// ../../../../.nvm/versions/node/v20.19.6/lib/node_modules/wrangler/templates/pages-dev-pipeline.ts
import worker from "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/.wrangler/tmp/pages-SjvC7n/bundledWorker-0.30640314424997794.mjs";
import { isRoutingRuleMatch } from "/Users/iguchiyuuta/.nvm/versions/node/v20.19.6/lib/node_modules/wrangler/templates/pages-dev-util.ts";
export * from "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/.wrangler/tmp/pages-SjvC7n/bundledWorker-0.30640314424997794.mjs";
var routes = define_ROUTES_default;
var pages_dev_pipeline_default = {
  fetch(request, env, context) {
    const { pathname } = new URL(request.url);
    for (const exclude of routes.exclude) {
      if (isRoutingRuleMatch(pathname, exclude)) {
        return env.ASSETS.fetch(request);
      }
    }
    for (const include of routes.include) {
      if (isRoutingRuleMatch(pathname, include)) {
        const workerAsHandler = worker;
        if (workerAsHandler.fetch === void 0) {
          throw new TypeError("Entry point missing `fetch` handler");
        }
        return workerAsHandler.fetch(request, env, context);
      }
    }
    return env.ASSETS.fetch(request);
  }
};
export {
  pages_dev_pipeline_default as default
};
//# sourceMappingURL=ok5iqxi17iq.js.map
