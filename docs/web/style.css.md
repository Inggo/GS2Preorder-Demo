# web/style.css

Leave this file as the starter has it; a shop's own CSS goes in `web/shop.css`, which loads after it (see [customizing.md](../customizing.md)).

## Layout of the file

The unscoped rules at the top are the base styles and the `art-crafts` theme (washi tape, serif headings). The themes section at the end overrides them:

- `default` (SETTINGS Theme blank or `default`): clean, modern, one sans family. Its rules are scoped to `:is([data-theme="default"], [data-theme="dark"])`.
- `dark`: the default layout in dark colors. It shares the `default` rules, then recolors with `:root[data-theme="dark"]`.

app.js sets `<html data-theme>` (and `web/theme.js` sets it early from the last visit).

## :root

- Each theme sets its own default `--theme-brand`. A shop's `web/shop.css` may set `--brand` itself, and SETTINGS Primary Color overrides both.
- `--on-light` is dark text for light fills, whatever the theme. Use it for text on a `--brand` fill, never `--ink` (which is light in `dark`).

## Default theme sections

- **Masthead**: left-aligned; the shop name is the one loud thing.
- **Nav**: plain text tabs; a category's color shows as a small swatch.
- **Categories**.
- **Products**: photo on a soft tile, text below with no box.
- **Order sheet**.

## dark

The default layout on a dark page. `--brand` stays a fill with dark text, so a light or mid Primary Color works best. SETTINGS Accent Color is ignored (it's chosen for white); `--accent` is the brand lightened instead.
