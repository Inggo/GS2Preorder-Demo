# GS2Preorder Starter

A pre-order website for small shops, where a **Google Sheet is the database and the admin screen**. Customers browse the catalog, fill a cart and send a pre-order. The owner gets an email, sees the order as a row in the sheet, and moves it through **Pending → Verified → Paid**. Each status change fills in a ready-to-send message. Stock updates by itself.

This is the **lite** edition: free to host, no server.

```
customer ── GitHub Pages (web/: HTML/CSS/JS) ──► Apps Script web app ──► the owner's Google Sheet
                                                 (apps-script/, inside the sheet)   └─► email alert to the owner
```

## Layout

```
web/                  the site (no build step); published by .github/workflows/pages.yml
  config.js           ← the shop's Apps Script web app URL goes here
  img/                resized product photos + index.json (made by photos.sh)
apps-script/          the backend: Code.gs + appsscript.json, pasted into the sheet's script editor
photos.sh             resizes the owner's photos/<SKU>.jpg into web/img/ (needs ImageMagick)
docs/
  setup.md            onboarding runbook for the operator, incl. the Google authorization step
  owner-onboarding.md for the shop owner: their setup steps (copy the sheet, fill it, authorize, GitHub)
  owner-guide.md      for the shop owner: running the shop from the sheet
  sheet.md            the tabs, columns and formula rules
  api.md              the backend contract shared with the pro (Go) server
  customizing.md      names, logo, colors, currency and other per-shop changes
  pro.md              lite vs pro and the upgrade path
```

## Quick start

1. Build the master template sheet once: [setup.md §0](docs/setup.md#0-one-time-build-the-master-template-you).
2. For each shop, follow [setup.md](docs/setup.md): the owner copies the template, deploys the web app and authorizes it. The owner then creates an empty public repo, adds you as a collaborator and turns on Pages. You push this (private) starter into it, paste the URL into `web/config.js` and add the photos.

To preview locally: `python3 -m http.server -d web 8000`. The page loads its data from the web app URL in `config.js`.

## What lite leaves out

Lite has no promos or bundle pricing, no watermarking (owners add their own if they want one) and no full-size photo viewer. Those are in the **pro** edition, a Go server on a VPS that uses the same sheet and the same page. See [docs/pro.md](docs/pro.md).
