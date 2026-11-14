# web/app.js

## Constants

- `CONFIGURED`: the page counts as connected when `backend` is `"server"`, or when `api` is an Apps Script URL (`https://script.google.com/…`). Otherwise it shows "not connected".
- `THEMES`: the first entry is used when settings name no theme (or an unknown one). `web/theme.js` lists them too; keep them in step with `Code.gs` and pro's `shop.Themes`.
- `THEME_KEY`: read early by `web/theme.js`, before app.js runs, to avoid a theme flash.

## HANDLE_LINK

The shop's own links under the notes: maps a SETTINGS handle kind to `[href, text]` for its value. A Messenger value that's already an `https://` URL is linked as is; otherwise it's treated as a page name for `m.me`.

## applyHandles

Shows the filled-in handles in SETTINGS row order. Older pro servers send no `handles`; then only Instagram is shown.

## DEFAULT_CONTACTS / applyContactFields

Shows only the contact options the shop offers, in its order. With a single option there's no choice to make, so the chooser is hidden.

Older pro servers don't send `contactFields`; they take Email and Instagram, so a missing list falls back to `DEFAULT_CONTACTS`. `applyContactFields()` is also called once at startup with no list, so the form is usable until the settings arrive.

## submitOrder

`messenger` is added to the body only when Messenger is the chosen contact method: older pro servers reject fields they don't know.

## applySettings

SETTINGS Accent Color is chosen for a white page, so it's ignored in the `dark` theme (see [style.css.md](style.css.md#dark)).
