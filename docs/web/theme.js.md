# web/theme.js

Runs before the page draws (it's loaded without `defer`): it applies the SETTINGS Theme this page last saw, so a returning visitor doesn't see the default theme flash while settings load.

- It reads the same key app.js writes (`THEME_KEY`, `theme-v1:<pathname>`). app.js then sets the real theme from settings and saves it.
- Its theme list must match `THEMES` in app.js (and `Code.gs`, pro's `shop.Themes`).
- It's a separate file, not an inline `<script>`, so a strict CSP (as pro serves) allows it.
