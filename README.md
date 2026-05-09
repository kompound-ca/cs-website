# cs-website

Static site hosting public-facing pages for the [CS2 GenCode extension](https://github.com/kompound-ca/cs-extension) and the dghq.app inspect community server.

## Pages

- `index.html` — install / landing page, served at <https://cs2inspect.dghq.app/>
- `privacy/index.html` — privacy policy, served at <https://cs2inspect.dghq.app/privacy/>

The site previously had a second hostname, `privacy.dghq.app`, which served only the privacy policy. That project has been retired and the privacy policy now lives at `/privacy/` on the install hostname.

## Stack

Plain HTML + CSS. No framework, no build step, no JavaScript runtime needed. Deployed via Cloudflare Pages directly from this repo on every push to `main`.

## Local preview

Open `index.html` in a browser, or run any static file server:

```bash
python -m http.server 8000
# then visit http://localhost:8000/
```

## Deploy (Cloudflare Pages)

This repo is wired up to Cloudflare Pages. On every push to `main`, Pages publishes the repo root to production and serves it at `cs2inspect.dghq.app` (with the privacy policy at `cs2inspect.dghq.app/privacy/`).

Build settings (already configured in the Pages dashboard):

- **Framework preset**: None
- **Build command**: *(empty)*
- **Build output directory**: `/`
- **Root directory**: `/`

Custom security headers are defined in `_headers` (Cloudflare Pages reads this file automatically; see [docs](https://developers.cloudflare.com/pages/configuration/headers/)).

## Editing the privacy policy

Edit `privacy/index.html`. Keep the `Effective` date at the top in sync if changes are material. Push to `main`; Pages redeploys in ~30 seconds.

## Bumping the install zip

When the extension ships a new version:

1. Build it in the cs-extension repo (`npm run pack`).
2. Copy the new `cs2-gencode-<version>.zip` into this repo's root.
3. Delete the old zip.
4. Update the version references in `index.html` and `install.ps1`.
5. Commit and push.
