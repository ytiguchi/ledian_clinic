import { defineConfig } from "astro/config";
import cloudflare from "@astrojs/cloudflare";

export default defineConfig({
  srcDir: "./src",
  outDir: "./dist",
  output: "server",
  adapter: cloudflare({
    platformProxy: {
      enabled: true
    }
  }),
  server: {
    host: true,
    port: 4321
  }
});
