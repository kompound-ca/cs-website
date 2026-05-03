# cs-website

Static site hosting public-facing pages for the [CS2 GenCode extension](https://github.com/kompound-ca/cs-extension) and the dghq.app inspect community server.

## Pages

- `index.html` — privacy policy, served at <https://privacy.dghq.app/>

## Stack

Plain HTML + CSS. No framework, no build step, no JavaScript runtime needed. Deployed via Cloudflare Pages directly from this repo on every push to `main`.

## Local preview

Open `index.html` in a browser, or run any static file server:

```bash
python -m http.server 8000
# then visit http://localhost:8000/
```

## Deploy (Cloudflare Pages)

This repo is wired up to Cloudflare Pages. On every push to `main`, Pages
publishes `index.html` and `styles.css` to the production environment and
serves them at `privacy.dghq.app`.

Build settings (already configured in the Pages dashboard):

- **Framework preset**: None
- **Build command**: *(empty)*
- **Build output directory**: `/`
- **Root directory**: `/`

Custom security headers are defined in `_headers` (Cloudflare Pages reads
this file automatically; see [docs](https://developers.cloudflare.com/pages/configuration/headers/)).

## Editing the privacy policy

Edit `index.html`. Keep the `Effective` date at the top in sync if changes
are material. Push to `main`. Pages will redeploy in ~30 seconds.
