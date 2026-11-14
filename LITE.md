# LITE.md

Notes for the **lite** edition: GitHub Pages for the page, a Google Apps Script web app inside the owner's sheet for the backend. Common notes are in `CLAUDE.md`. In a pro repo (one with `PRO.md`), the backend and hosting notes below don't apply.

## What lite is

The lite starter (`Inggo/GS2Preorder`, private) is pushed into one **public** repo per shop, which the shop owner owns, with the developer as a collaborator. Shop repos share its history, so **everything ever committed to the starter becomes public**. It's free to host: no server.

- `web/`: the page, published by `.github/workflows/pages.yml` (which skips private repos, so the starter and pro repos never deploy to Pages). `config.js` holds the web app URL.
- `apps-script/`: the backend, `Code.gs` + `appsscript.json`, pasted into each shop's sheet. It runs as the owner.
- `photos.sh`: ImageMagick resize of the owner's photos (any watermark is the owner's own) from `photos/<SKU>.jpg` into `web/img/<SKU>.jpg` plus `web/img/index.json`.
- `docs/`: `setup.md` (operator runbook), `owner-onboarding.md` (the owner's steps; keep it in sync with `setup.md`), `owner-guide.md`, `sheet.md` (schema), `api.md` (backend contract), `hooks.md` (page extension API), `customizing.md`, `pro.md` (lite vs pro), and `web/` (notes on the `web/` files).

Lite leaves out promos (`api/quote`), the photo viewer, watermarking, ntfy and per-IP limits; those are pro.

## Rules

- **Stay compatible with pro.** The sheet layout (`docs/sheet.md`) and the JSON bodies (`docs/api.md`) must match what the Go server reads and returns, so a lite shop moves to pro without migrating data and the page works against both backends.
- **Apps Script transport**: replies are always HTTP 200, with the real status in `body.status`. POSTs are sent as `text/plain` (no `Content-Type` header), because Apps Script can't answer a CORS preflight.
- The script writes only ORDERS A–K and ORDER_ITEMS A–F. Text is written with a leading `'` (the Apps Script equivalent of `RAW`).
- `PlaceOrder` runs under `LockService.getScriptLock()`. Re-read the inventory inside the lock, and never trust client prices.
- `appsscript.json` lists the OAuth scopes explicitly (`spreadsheets.currentonly`, `script.send_mail`, `script.container.ui`). A new Apps Script service may need a new scope, which every owner then has to re-authorize, so avoid adding any.
- Settings that must stay private (`Notify Email`) are never returned by `publicSettings`.
- The lite cart and theme keys are per path because all of a GitHub account's Pages sites share one origin.

## Checking changes

Besides the frontend checks in `CLAUDE.md`:

```bash
node -e 'new Function(require("fs").readFileSync("apps-script/Code.gs","utf8"))'   # syntax only
bash -n photos.sh
python3 -m http.server -d web 8000                                                 # manual check
```

Apps Script code runs only inside Google. To test it end to end, paste it into a test copy of the template sheet, deploy a new version, and place an order.
