# Customizing a shop

Most of a shop's look is set by the owner in SETTINGS (text, colors). These changes are per site and go in the shop's own repo.

## Name and logo

- The name appears in `web/index.html` in `<title>`, `meta description`, the `og:` tags, `.shop-name` (masthead) and `.nav-logo` (the small name in the top bar once you scroll).
- To use a logo image instead of the text, add `web/logo.png` and:
  - masthead: `<h1><img class="logo" src="logo.png" alt="My Shop" width="280" height="…"></h1>`
  - top bar: `<a class="nav-logo" href="#" aria-label="Back to top"><img src="logo.png" alt="" width="44" height="…"></a>`
  
  Set the real height so the page doesn't jump while the logo loads. Trim and resize it first (around 560px wide is plenty).
- Favicon: replace `web/favicon.svg`, or add PNG/ICO icons and update the `<link rel="icon">`.
- Link previews (Facebook, Messenger): add `og:image` with an **absolute** URL, e.g. `https://<account>.github.io/<repo>/share.jpg` (1200×630).

## Colors and design

- All brand tones derive from `--brand` in `web/style.css` (fills: buttons, stepper, cart bar). The owner overrides it with SETTINGS **Theme Color**. `--accent` (links, Add buttons) is derived from it to stay readable on white, unless SETTINGS **Accent Color** sets it.
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

The form offers Email or Instagram. Adding another method (e.g. Messenger) touches `index.html` (radio and field), `normalize()` in `Code.gs`, the ORDERS columns and the Contact Link formula, so plan it as a starter change, not a per-shop tweak.
