# SEO Roadmap (AIO/LLMO focus)

Purpose: improve organic discovery and AI retrieval quality for the public site.
Scope: public site pages, metadata, structured data, content structure, and trust signals.

## Principles

- Entity clarity: keep clinic, services, doctors, locations, and pricing consistent.
- Retrieval friendly: clear headings, summaries, and stable URLs.
- Trust and evidence: show policies, safety notes, and citations where possible.

## Phase 0 - Baseline (week 0-1)

Deliverables
- Confirm canonical URLs, sitemap presence, and robots settings.
- Capture current rankings and AI-answer appearances (baseline).
- List indexable pages and mark noindex for internal-only pages.

Notes
- Use Google Search Console and Lighthouse reports.

## Phase 1 - Technical foundation (week 1-2)

Site-wide
- Ensure unique title and description per page.
- Add canonical links everywhere (already in layout, verify pages pass).
- Keep OG and Twitter tags consistent and valid.
- Ensure `hreflang` if multi-lingual is planned.

Page structure
- Single H1 per page, consistent H2/H3 hierarchy.
- Add short "summary" block near the top of each page for AI snippet reuse.

## Phase 2 - Structured data (week 2-4)

Add JSON-LD per page type:
- `MedicalOrganization` or `MedicalClinic` (site-wide).
- `LocalBusiness` + address + phone + opening hours (if public).
- `WebSite` + `SearchAction` (if on-site search exists).
- `BreadcrumbList` for all pages with breadcrumb.
- `Service` for each service page (price and details).
- `FAQPage` where questions are present.
- `Article` / `NewsArticle` for news posts.

## Phase 3 - Content and entity enrichment (week 3-6)

Service pages
- Add structured sections: overview, benefits, contraindications, duration,
  aftercare, recommended intervals, and pricing.
- Provide exact numbers and clear units for LLM extraction.
- Add cross-links: related services and top FAQs.

Clinic trust pages
- Expand doctor/staff bios with credentials and experience.
- Clear policies: cancellation, privacy, pricing notes, and safety disclaimers.

## Phase 4 - LLMO content packaging (week 4-8)

LLM-friendly assets
- Publish a clinic facts page (NAP, locations, hours, specialties).
- Provide a pricing summary table with consistent naming.
- Provide a glossary for procedure terms.

External consistency
- Align NAP and service naming with GBP and directories.
- Add citations or references for medical claims when possible.

## Phase 5 - Monitoring and iteration (ongoing)

KPIs
- Impressions and clicks by page and query group.
- LLM snippet coverage (AI Overviews, Bing, Perplexity).
- CTR improvements for top pages.

Cadence
- Monthly SEO review, quarterly content refresh.

## Backlog (when ready)

- Implement internal linking rules (service -> price -> FAQ).
- Add images with descriptive alt text and captions.
- Evaluate page speed improvements after CSS/JS refactors.
- Consider multi-location pages if clinic expands.
