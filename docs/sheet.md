# The Google Sheet

The sheet is the whole database and the owner's admin screen. **GS2Preorder ▸ Set up sheet** (`setupSheet` in `apps-script/Code.gs`) builds every tab below with its headers, formulas and formatting. The layout matches the Go "pro" server's, so a shop can move to pro without changing its sheet (see `pro.md`).

## Tabs

### INVENTORY: the catalog (owner edits)

`SKU | Category | Product Name | Description | Price | Inventory | New | Photo | Reserved | Sold | Available`

- Columns are found **by header name**, so the owner may reorder them or add their own (the formulas in I–K refer to A and F by letter, though: move those only together with the formulas).
- `SKU`: the product key, e.g. `stickers-001`. Orders refer to it, so **never change a SKU once orders exist**. Renaming the product is fine.
- `Price`: in pesos. `Inventory`: total stock for the pre-order.
- `Description`: optional, one or two lines on the card.
- `New`: checkbox. Ticked products get a "New" badge and also appear in a "New" section at the top.
- `Photo`: optional. Blank uses `web/img/<SKU>.jpg` if `photos.sh` made one; a filename uses `web/img/<that file>`; a full `https://` URL is used as is.
- `Reserved` / `Sold` / `Available` (grey): computed, never typed in. Reserved = Pending + Verified quantities, Sold = Paid quantities, Available = Inventory − Reserved − Sold.

### ORDERS: one row per order (owner works here)

`Order ID | Timestamp | Name | Contact Via | Email | Instagram | Mobile | Items | Total | Status | Subject | Message | Contact Link`

- The website writes A–J. The owner changes only `Status` (a dropdown): `Pending` → `Verified` → `Paid`, or `Cancelled` / `Out of Stock`.
- Only Pending and Verified reserve stock and only Paid counts as sold, so cancelling an order frees its stock automatically, and changing a status back undoes it.
- `Subject` / `Message` / `Contact Link` (grey) fill in from TEMPLATES for the row's status. The link is a "✉️ Send email" mailto (prefilled) or "💬 Open Instagram DM" (Instagram can't prefill; paste `Message`).

### ORDER_ITEMS: one row per product per order (website only)

`Order ID | SKU | Product Name | Quantity | Unit Price | Line Total | Status`

`Status` is looked up from ORDERS, which is what drives the stock columns. Nobody edits this tab (it's protected with a warning).

### TEMPLATES: the messages the owner sends

`Status | Subject | Body`, one row per status. Body placeholders: `{name} {order_id} {items} {total}`; subject: `{order_id} {name}`. Add a row for a status to give it a message (even `Pending`).

### SETTINGS: storefront text and switches

`Setting | Value | What it does`. Names are case-insensitive; blank values are ignored.

| Setting | Value |
|---|---|
| Subheading | Line under the shop name |
| Note | One bullet under the subheading; repeat the row for more |
| Instagram | Username, shown as a link |
| Form Note | Text above the order form fields |
| Order Note | Small text under the order button |
| Orders Open | Checkbox; untick to close now |
| Close At | Date-time to close by itself (sheet timezone) |
| Closed Message | Shown once closed |
| Notify Email | Where new-order emails go (blank or `off`: none). Never sent to the page |
| Theme / Accent / Submit Color | `#rrggbb` |

Text values may use `**bold**` and `__underline__`.

## Rules for anyone changing the sheet or the script

- **Every computed column is one formula in its header cell** (`={"Header"; MAP(...)}`), covering the whole column. Typing anything below it, even a space, breaks the whole column with `#REF!`. The script therefore writes only ORDERS A–J and ORDER_ITEMS A–F.
- Customer text is written with a leading apostrophe, so it's stored as typed: a name like `=IMPORTXML(...)` stays text, and mobile numbers keep their leading 0.
- Rows are appended after the last non-blank cell in column A; the grid grows by 500 rows when needed.
- The sheet's timezone (File ▸ Settings) is used for timestamps and `Close At`.
- To clear test orders, delete the contents of **ORDERS A2:J** and **ORDER_ITEMS A2:F** only.
