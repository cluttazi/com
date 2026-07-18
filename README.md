# luttazi.com

Personal portfolio site of Chris Luttazi — Lead Data Engineer. Deployed as
a static site via GitHub Pages at <https://luttazi.com/>.

## Layout

- `index.html` — the site. Fully self-contained (inline CSS/JS, vanilla
  i18n for 15 languages via `?lang=` / the language selector). Only
  external dependency: Google Fonts.
- `privacy.html` — privacy policy (EN/ES).
- `assets/` — favicon and Open Graph image (plus legacy images from an
  earlier theme, see `MODERNIZATION_PLAN.md`).
- `robots.txt`, `sitemap.xml` — SEO plumbing.

There is no build step. Edit the HTML, open it in a browser, push.

## Checks

CI (`.github/workflows/ci.yml`) runs on every push/PR:

```bash
npx --yes html-validate@10 index.html privacy.html   # HTML validation (.htmlvalidate.json)
bash scripts/check-links.sh                           # local asset + anchor existence
```

Run the same commands locally before pushing (requires Node 18+ and bash).

## License

MIT — see `LICENSE`.
