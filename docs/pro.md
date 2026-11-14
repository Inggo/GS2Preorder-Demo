# Lite and pro

| | **Lite** (this repo) | **Pro** (Go server) |
|---|---|---|
| Hosting | GitHub Pages + Apps Script, free | VPS: nginx + one systemd instance per tenant |
| Google access | Script inside the owner's sheet; owner authorizes it once | Service account (JSON key); sheet shared with its email |
| Promos / bundle pricing | — | PROMOS tab, `POST api/quote` |
| Photos | Owner pre-watermarks; `photos.sh` resizes | `cmd/watermark`: watermark, thumbnails, share card |
| Big photo viewer | — | ✓ |
| Owner alerts | Email (MailApp) | ntfy push |
| Abuse limits | Honeypot + 20 orders/min shop-wide | Honeypot + per-IP limit + fail2ban |
| Latency | 1–3 s on a cold call, under 1 s warm | ~100 ms |

## What keeps the upgrade path open

1. **Same sheet, except Messenger.** Lite's ORDERS has a `Messenger` column (F) that the Go server doesn't know yet: it writes ORDERS by position (A–J, with Instagram in F), so it would put data in the wrong columns. Before a lite shop moves to pro, the Go server needs the Messenger column, `contactFields` in settings and the `messenger` order field (see `api.md`). Otherwise the lite tabs and columns are what the Go server reads, so a lite shop moves to pro without migrating data: add a PROMOS tab and share the sheet with the service account. Headers are matched by name, and the Go server ignores settings it doesn't know (`Instagram`, `Notify Email`).
2. **Same API bodies** (`api.md`). The page talks to the backend only through the `api` object in `web/app.js`, which already supports `backend: "server"`. Switching a shop to pro means changing `web/config.js`, not the page.
3. **Same frontend.** The page's markup, CSS and order flow are the pro page with features removed, not a rewrite.

## Plan for building pro

1. **One frontend, feature flags.** Port the promo quote and the photo viewer from the pro `web/app.js` into this repo's `app.js`, switched on by `SHOP_CONFIG.features = { promos: true, viewer: true }` (only valid with `backend: "server"`). Lite keeps them off, so its behavior doesn't change. Then the pro shops move onto this frontend, and both lines share one `web/`.
2. **Generalize the Go server** (currently in its own repo, tied to one shop) into a tenant-neutral module:
   - Currency, timezone and the mobile-number rule come from env instead of constants (lite has the same three hard-coded in `Code.gs` and `app.js`; see `customizing.md`).
   - Add `instagram` to `GET api/settings`.
   - Optional: `GET api/shop`, returning products and settings in one call like lite.
   - Optional: CORS (`Access-Control-Allow-Origin` for the tenant's Pages origin), if a pro shop should keep its frontend on GitHub Pages. The simpler default is to serve the frontend from the VPS, as the first shop does, so everything stays same-origin under the strict CSP.
3. **Repo layout**: either a `server/` directory here (Go module, `deploy/`) or a separate `gs2preorder-server` repo that pulls `web/` from this one. A separate repo keeps lite clones free of Go and VPS scripts.

## Pro onboarding: the Google Cloud service account

This is the "API key" step for pro. You do it, not the owner: **one Google Cloud project that you own, with one service account per shop**. The owner only shares their sheet with that shop's service-account email.

### Why one service account per shop

The Sheets API is free, but it has rate limits (check the current numbers in Console ▸ APIs & Services ▸ Google Sheets API ▸ Quotas):

- about **60 reads and 60 writes per minute per service account**;
- about **300 reads and 300 writes per minute per project**, shared by all its service accounts.

An order costs the server about 2–3 reads and 1–2 writes. Products, settings and promos are cached, which adds a few background reads per minute. If shops shared one service account, one shop's launch rush could use up everyone's per-minute allowance, and other shops' orders would fail with 503. A shared key would also be able to open every shop's sheet. With one service account per shop, each shop has its own allowance and a key that opens only its own sheet. The project limit is far above what a handful of shops use, and Google raises it for free on request. If a shop ever needs full isolation, give it its own project; the steps are the same.

### Once: the project

1. <https://console.cloud.google.com> ▸ create a project, e.g. `preorder-shops`. No billing is needed for the Sheets API.
2. APIs & Services ▸ Library ▸ **Google Sheets API** ▸ Enable.

### Per shop

3. IAM & Admin ▸ Service Accounts ▸ **Create service account**, named after the tenant (e.g. `shop-<tenant>`). Skip the roles; sheet access comes from sharing.
4. Open it ▸ Keys ▸ **Add key ▸ JSON**, and download the key. Keep it out of git. It goes to `/etc/gs2preorder/<tenant>-service-account.json` via `deploy.sh setup`.
   - If key creation is blocked ("iam.disableServiceAccountKeyCreation"), the project is under an organization policy. Use a project under a personal account instead.
5. The owner shares the sheet with `shop-<tenant>@<project>.iam.gserviceaccount.com` as **Editor**. Then `go run ./cmd/sheetcheck` confirms access.

A project holds up to 100 service accounts by default.

Moving a lite shop to pro: do steps 3–5, deploy the tenant on the VPS, point the site at it, and then (optional) remove the lite web app under Apps Script ▸ Deploy ▸ Manage deployments ▸ Archive, so the old URL stops accepting orders.
