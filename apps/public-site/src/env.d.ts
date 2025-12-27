/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

type D1Database = import('@cloudflare/workers-types').D1Database;
type R2Bucket = import('@cloudflare/workers-types').R2Bucket;

type Runtime = import('@astrojs/cloudflare').Runtime<{
  DB: D1Database;
  STORAGE: R2Bucket;
}>;

declare namespace App {
  interface Locals extends Runtime {}
}

