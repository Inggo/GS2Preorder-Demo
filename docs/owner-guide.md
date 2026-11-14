# Running your pre-order shop

Your shop runs on one Google Sheet. The website reads your products from it and writes every order into it. There's nothing else to log in to.

## The tabs

| Tab | What it's for | You… |
|---|---|---|
| **INVENTORY** | Your products and stock | Edit freely (except the grey columns) |
| **ORDERS** | One row per order | Change **Status** only |
| **TEMPLATES** | The messages you send customers | Edit the wording |
| **SETTINGS** | Website text, closing date, colors | Edit the Value column |
| **ORDER_ITEMS** | Behind-the-scenes order details | Don't touch |

**Grey columns are automatic.** Never type in them, not even a space. If one shows `#REF!`, something was typed below its header: delete it and the column fixes itself.

## Products (INVENTORY)

- You enter your own products. When setting up, delete the sample rows first.
- **SKU** is the product's code that you make up (e.g. `stickers-001`). Name each product photo after it. Don't change a SKU after orders come in. You can rename the product itself anytime.
- **Inventory** is your total stock for this pre-order. **Available** works itself out from the orders.
- Tick **New** to show a "New" badge and list the product at the top.
- For a new photo, send it to your developer, named by SKU.
- Changes show on the website within 30 seconds.

## Handling an order (ORDERS)

Every order arrives as **Pending**. You'll get an email if *Notify Email* is set in SETTINGS.

1. **Check it**, then set Status to **Verified**. The **Message** column fills in with your payment instructions, and a yellow button appears:
   - **✉️ Send email**: opens a ready-to-send email. In Chrome, if it doesn't work, copy **Subject** and **Message** into an email by hand.
   - **💬 Open Messenger** or **💬 Open Instagram DM**: opens a chat with the customer, or their Facebook profile if they gave a link (tap **Message** there). Paste the **Message** in.
2. When they've paid, set Status to **Paid** and send the receipt message the same way.
3. If you can't fill it, set **Cancelled** or **Out of Stock**. Their items go back into stock automatically.

Pending and Verified orders **hold** stock. Paid orders count as **sold**. If you pick the wrong status, change it back; nothing is lost.

## Messages (TEMPLATES)

One row per status. These words get replaced automatically:

- `{name}`: the customer's name
- `{order_id}`: the order number, e.g. PO-7KQ2MX
- `{items}`: the list of what they ordered
- `{total}`: the total

## Website text and closing (SETTINGS)

- **Subheading** and **Note** rows are the text at the top of the site. Add more Note rows for more bullet points. Put `**two stars**` around words for **bold**, and `__two underscores__` for underlined.
- **Contact Fields**: how customers can ask you to reach them: Email, Messenger and Instagram, one row each. Delete a row to stop offering that option, and reorder the rows to change their order on the form. Keep at least one row (with none, all three come back).
- **Orders Open**: untick it to close the shop right away.
- **Close At**: the shop closes by itself at this date and time.
- **Closed Message**: what visitors see after closing.

## Your Google account and the shop

The website works through a small script inside your sheet, which you approved when the shop was set up ("Google hasn't verified this app" → Advanced → Allow). It can only open **this one sheet** and send you order alerts.

- **Don't** remove "GS2Preorder" from <https://myaccount.google.com/permissions>, or the shop stops taking orders.
- **Don't** rename the tabs or the column headers.
- You can make a backup anytime: File ▸ Make a copy.

If the website shows "unavailable", contact your developer. Your orders are safe in the sheet.

## Your GitHub account and the website

The website lives in a repository in **your** GitHub account, and you own it. Your developer (`Inggo`) is a collaborator who updates it for you.

- **Don't** delete the repository, make it private, or remove `Inggo` from Settings ▸ Collaborators while you still want updates. A private repo turns the free site off.
- **Don't** change Settings ▸ Pages. It must stay on **Source: GitHub Actions**.
- You don't need to edit anything on GitHub yourself. Products, prices and text all come from the sheet.
