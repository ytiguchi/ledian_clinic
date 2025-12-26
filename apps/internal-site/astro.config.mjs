import { defineConfig } from "astro/config";
import cloudflare from "@astrojs/cloudflare";

export default defineConfig({
  srcDir: "./src",
  outDir: "./dist",
  output: "server",
  adapter: cloudflare({
    // Cloudflare Workers runtime can't use `sharp`. Allow build by passing through images.
    imageService: "passthrough",
    platformProxy: {
      enabled: true
    }
  }),
  server: {
    host: true,
    port: 4321
  }
});
