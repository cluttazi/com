# Modernization audit & plan — luttazi.com

Audit date: 2026-07-18. Scope: conservative modernization of this static
personal site (GitHub Pages). No redesign, no content/appearance changes,
no build system.

## Inventory

- `index.html` (2374 lines) — single-page portfolio. Self-contained:
  inline `<style>` + inline `<script>` (vanilla JS i18n with 15 languages,
  typewriter, intro interaction). No `<img>` tags, no external JS.
  External resources: Google Fonts only (HTTPS, with `preconnect`).
- `privacy.html` — standalone privacy policy (EN/ES toggle), same
  self-contained pattern.
- `css/styles.css` — vendored Start Bootstrap "Agency" v7.0.11 theme
  (compiled Bootstrap 5.2-era CSS, ~220 KB). **Not referenced by any HTML
  page** — dead weight from a previous iteration of the site.
  `robots.txt` even disallows `/css/`.
- `assets/` — only `favicon.ico` and `og-image.png` are referenced by the
  live pages. Everything else (`img/team`, `img/portfolio`, `img/logos`,
  `img/about`, `mov/datacenter.mp4`, `header-bg*.{png,jpg}`,
  `map-image.png`, `navbar-logo.svg`, `close-icon.svg`) is only referenced
  by the unused `css/styles.css` or by nothing at all.
- `GDPR` — plain-text bilingual AdSense policy, superseded by
  `privacy.html`; not linked from anywhere.
- `robots.txt`, `sitemap.xml`, `LICENSE` (MIT) — fine.
- No README, no `.gitignore`, no `.editorconfig`, no CI.

## Audit findings

### HTML validity (html-validate v10, `html-validate:recommended`)

Baseline: 9 errors across both pages.

| Finding | Severity | Action |
| --- | --- | --- |
| 3× `<button>` without `type` attribute (nav hamburger; privacy lang toggle) | genuine, trivially safe | fix: add `type="button"` |
| `<style>` inside `<noscript>` in `<body>` (index) — not permitted content per spec | genuine, safe | fix: move the `<noscript><style>` no-JS fallback into `<head>` (valid there; styles use `!important`, so cascade unaffected) |
| `long-title` (title is 76 chars) | intentional SEO title | disable rule in config |
| 4× `no-inline-style` | intentional design of a self-contained page | disable rule in config |

### Links & assets

- No `http://` links anywhere (only `data:` URIs and XML namespaces, which
  are correct as-is). No mixed content.
- All locally referenced assets exist (`assets/favicon.ico`,
  `assets/og-image.png`). All in-page anchors (`#hero`, `#about`,
  `#expertise`, `#clients`, `#portfolio`, `#contact`) resolve.
- External links: GitHub repos, LinkedIn, Google Fonts — all HTTPS.

### Vendored libraries

- Only `css/styles.css` (Start Bootstrap Agency 7.0.11 / Bootstrap ~5.2).
  It is **unused**, and CSS has no meaningful security surface — so no
  update needed. Removal is the right long-term move but is deferred
  (see below) to keep this pass strictly non-destructive.

### Accessibility basics

- `lang="en"` on both pages, viewport meta present, `aria-label` /
  `aria-expanded` on the hamburger, `aria-label` on the language select,
  semantic headings. No `<img>` elements, so no alt-text gaps.
- Minor (deferred): `lang-btn` toggle on privacy.html could carry
  `aria-pressed`; `hero_role` uses `<br>` inside heading (stylistic).

## Prioritized checklist

1. [x] Write this audit plan.
2. [x] Fix genuine HTML validity errors (button `type`, `<noscript>`
   style block placement). No visual/behavioral change.
3. [x] Add `.htmlvalidate.json` (recommended preset, with the two
   intentional-pattern rules disabled).
4. [x] Add `.gitignore` (OS junk, editor files, node_modules).
5. [x] Add minimal `README.md` describing the site and how to check it.
6. [x] Add `.editorconfig`.
7. [x] Add `scripts/check-links.sh` — verifies every local `href`/`src`
   and in-page anchor referenced by the HTML actually exists.
8. [x] Add CI (`.github/workflows/ci.yml`): html-validate + link check,
   npm-only, no build step. Commands verified locally first.

## Deferred (documented, not done — needs owner decision)

- **Delete unused `css/styles.css` and unused `assets/` files**
  (~1.5 MB incl. `mov/datacenter.mp4`). Safe from the repo's point of
  view, but old URLs may be hotlinked externally (e.g. the former
  `header-bg` or logo images). Recommend deleting after checking
  GitHub Pages/analytics logs; git history keeps them recoverable.
- **Remove the `GDPR` text file** — superseded by `privacy.html` and not
  linked; kept for now since it is referenced in the site's legal history.
- **Shorten `<title>`** below 70 chars — current title is a deliberate
  SEO choice; left alone.
- **`aria-pressed` on privacy language toggle**; `hero_role` `<br>`
  markup — cosmetic accessibility polish, not worth churn now.
- No build system, bundler, minification, or framework — intentionally
  out of scope for a hand-maintained static page.
