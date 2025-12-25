/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />
/// <reference types="@cloudflare/workers-types" />

// Cloudflare bindings
interface Env {
  DB: D1Database;
  STORAGE: R2Bucket;  // 症例写真・カウンセリング資料保管用
  // Cloudflare Access headers (if using Access)
  CF_Access_Auth_Email?: string;
  CF_Access_Auth_Groups?: string;
}

declare namespace App {
  interface Locals {
    runtime: {
      env: Env;
      cf?: IncomingRequestCfProperties;
      ctx?: ExecutionContext;
    };
  }
}

