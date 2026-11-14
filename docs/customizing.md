# Customizing a shop

Most of a shop's look is set by the owner in SETTINGS (text, colors). Everything else below is a per-site change in the shop's own repo, never in the starter.

## Keeping shops easy to update

Shops pull starter updates with `git pull starter master`. Git merges them automatically unless the starter and the shop changed the same lines. So, in a shop repo:

- **CSS goes only in `web/shop.css`.** It loads after `style.css`, so it can override anything, e.g. `:root { --brand: #ffb700; }`, a different `body::before` background, or logo sizing. Leave `style.css` exactly as the starter has it.
- **`web/index.html`**: edit only what has to be per shop: `<head>` (title, description, `og:` tags, icons) and the name or logo in the masthead and top bar.
- **New files** (logo, icons, `share.jpg`, background images) never conflict.
- **Don't change `app.js` or `Code.gs` per shop.** If a shop needs a behavior, add it to the starter behind a SETTINGS row, so every shop gets it.

## Name and logo

- The name appears in `web/index.html` in `<title>`, `meta description`, the `og:` tags, `.shop-name` (masthead) and `.nav-logo` (the small name in the top bar once you scroll).
- To use a logo image instead of the text, add `web/logo.png` and:
  - masthead: `<h1><img class="logo" src="logo.png" alt="My Shop" width="280" height="…"></h1>`
  - top bar: `<a class="nav-logo" href="#" aria-label="Back to top"><img src="logo.png" alt="" width="44" height="…"></a>`
  
  Set the real height so the page doesn't jump while the logo loads. Trim and resize it first (around 560px wide is plenty).
- Favicon: replace `web/favicon.svg`, or add PNG/ICO icons and update the `<link rel="icon">`.
- Link previews (Facebook, Messenger): add `og:image` with an **absolute** URL, e.g. `https://<account>.github.io/<repo>/share.jpg` (1200×630).

## Colors and design

- All brand tones derive from `--brand` (fills: buttons, stepper, cart bar). Its default is in `web/style.css`; a shop's own default goes in `web/shop.css`. SETTINGS **Theme Color** overrides both. `--accent` (links, Add buttons) is derived from it to stay readable on white, unless SETTINGS **Accent Color** sets it.
- Category tapes cycle through `--tape-1…6`. The "New" section uses `--tape-new`.
- The background is a light dot grid (`body::before`, `--pattern`).
- Fonts: Young Serif (headings, prices) and Hanken Grotesk (everything else), from Google Fonts.
- The footer credits the developer and keeps its own colors (`--dev-*`).

## Philippines-specific defaults

These are hard-coded in three places. Change all of them together:

| What | `apps-script/Code.gs` | `web/app.js` | Sheet |
|---|---|---|---|
| Currency ₱ | `CURRENCY`, `MONEY_FORMAT`, and `"₱"` in `FORMULAS.message` | `peso()` | Existing sheets: edit the ORDERS `Message` header formula and the money number formats |
| Mobile numbers | `MOBILE_RE` and its error message | placeholder in `index.html` | — |
| Timezone | `appsscript.json` `timeZone` | — | File ▸ Settings ▸ Time zone (used for timestamps and Close At) |

## Contact options

The form can offer Email, Messenger and Instagram. Each shop picks which ones in SETTINGS ▸ **Contact Fields**, so no code change is needed. Adding a *new* method (e.g. Viber) touches `index.html` (radio, icon and field), `CONTACT_METHODS` and `normalize()` in `Code.gs`, `CONTACT_PHRASE` in `app.js`, the ORDERS columns and the Contact Link formula, so plan it as a starter change, not a per-shop tweak.
