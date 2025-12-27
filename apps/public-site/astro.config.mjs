import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  srcDir: './src',
  outDir: './dist',
  output: 'server',
  adapter: cloudflare({
    platformProxy: {
      enabled: true,
      persist: {
        path: '../internal-site/.wrangler/state/v3'
      }
    }
  }),
  integrations: [
    tailwind()
  ],
  server: {
    host: true,
    port: 4320
  },
  site: 'https://ledianclinic.jp',
});
