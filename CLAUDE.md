# CLAUDE.md

Guidance for Claude Code in this repository.

## What this is

The **lite** edition of a Google-Sheets-backed pre-order site, kept private and pushed into one public repo per shop, which the shop owner owns, with the developer as a collaborator. Shop repos share this repo's history, so they can `git pull` its updates, and **everything ever committed here becomes public**. It contains no shop-identifying data. Keep it that way: placeholders are "My Shop", and real names, URLs and photos belong only in each shop's own repo.

- `web/`: static frontend for GitHub Pages (plain HTML/CSS/vanilla JS, no build). `config.js` holds the backend URL.
- `apps-script/`: the backend. It's a container-bound Apps Script web app pasted into each shop's sheet, and runs as the owner.
- `photos.sh`: ImageMagick resize of pre-watermarked photos into `web/img/<SKU>.jpg` plus `web/img/index.json`.
- `docs/`: `setup.md` (operator runbook), `owner-guide.md`, `sheet.md` (schema), `api.md` (contract), `customizing.md`, `pro.md`.

It is derived from the first production build (the Go server repo), which is the future **pro** edition (Go server). Lite leaves out promos (`api/quote`), the photo viewer, watermarking, ntfy and per-IP limits.

## Rules

- **No tenant data, ever.** This repo is the starter that every shop repo is pushed from, and its full history is public in each one. Never commit anything that belongs to a tenant, not even temporarily, in a test or in an example:
  - shop names, logos, photos, product lists or prices
  - Apps Script deployment URLs or sheet IDs
  - owner or customer names, emails, phone numbers or Instagram handles
  - GitHub usernames or Pages URLs

  Use the placeholders ("My Shop", `<owner>`, `AKfy…`). Tenant changes go only in that tenant's repo. If tenant data was ever committed here, tell the user; deleting the file doesn't remove it from history.
- **Stay compatible with pro.** The sheet layout (`docs/sheet.md`) and the JSON bodies (`docs/api.md`) must match what the Go server reads and returns. The one known gap is Messenger (the ORDERS `Messenger` column, `contactFields`, `messenger`), which lite has and pro doesn't yet (`docs/pro.md`). The page must keep working against pro: treat a missing `contactFields` as Email + Instagram, and send `messenger` only when it's chosen, because the Go server rejects unknown fields. All backend calls in `app.js` go through the `api` object, which supports `backend: "apps-script"` and `backend: "server"`. Don't call `fetch` for the backend anywhere else.
- **Apps Script transport**: replies are always HTTP 200, with the real status in `body.status`. POSTs are sent as `text/plain` (no `Content-Type` header), because Apps Script can't answer a CORS preflight.
- **Header-row formulas**: every computed column is one `={"Header"; MAP(...)}` in row 1. The script writes only ORDERS A–K and ORDER_ITEMS A–F. Text is written with a leading `'` (the Apps Script equivalent of `RAW`), which blocks formula injection and keeps leading zeros.
- `PlaceOrder` runs under `LockService.getScriptLock()`. Re-read the inventory inside the lock, and never trust client prices.
- `appsscript.json` lists the OAuth scopes explicitly (`spreadsheets.currentonly`, `script.send_mail`, `script.container.ui`). A new Apps Script service may need a new scope, which every owner then has to re-authorize, so avoid adding any.
- Settings that must stay private (`Notify Email`) are never returned by `publicSettings`.
- Frontend: build DOM with `textContent`/`<template>`, never `innerHTML` with data. Use relative URLs only. The cart key is per path (`cart-v1:<pathname>`), because all of a GitHub account's Pages sites share one origin.
- Design: all brand colors derive from `--brand` via `color-mix`. `--brand` is only used as a fill. Washi-tape tints mark categories. Nav and cart bar use `position: fixed`, not sticky (Firefox Android bug).
- PH defaults (₱, Manila time, PH mobile numbers) are listed in `docs/customizing.md`. Change them everywhere at once.

## Checking changes

There's no test suite. Before finishing a change:

```bash
node --check web/app.js
node -e 'new Function(require("fs").readFileSync("apps-script/Code.gs","utf8"))'   # syntax only
bash -n photos.sh
python3 -m http.server -d web 8000                                                 # manual check
```

Apps Script code runs only inside Google. To test it end to end, paste it into a test copy of the template sheet, deploy a new version, and place an order.

The user makes all git commits. Suggest commit messages and don't run `git commit`.
