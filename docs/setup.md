# Onboarding a shop (operator runbook)

This takes about an hour per shop, most of it filling in products. The owner needs a Google account (a personal Gmail is safest, see *Troubleshooting*) and a GitHub account, because the shop's repo and site live in their account. You need a GitHub account (`Inggo`) with collaborator access to their repo and, for photos, ImageMagick.

**There is no API key.** The lite backend is an Apps Script that lives *inside the owner's sheet* and runs as the owner. In place of an API key there's a one-time **authorization** (step 4), where the owner clicks through Google's "unverified app" screens. That step is where owners get nervous, so it's covered in detail. (The pro version does use a Google Cloud service account instead; see `pro.md`.)

## 0. One time: build the master template (you)

1. Create a blank Google Sheet named **Pre-order Template**. File ▸ Settings: Locale **Philippines**, Time zone **(GMT+08:00) Manila**.
2. Extensions ▸ Apps Script. Name the project **Pre-order**.
   - Project Settings (gear) ▸ tick **Show "appsscript.json" manifest file in editor**.
   - Replace `Code.gs` with `apps-script/Code.gs` from this repo, and `appsscript.json` with `apps-script/appsscript.json`. Save.
3. Back in the sheet, reload. A **Pre-order** menu appears. Run **Pre-order ▸ Set up sheet** and authorize it as yourself (same screens as step 4). It adds all the tabs with sample rows.
4. Share ▸ General access: **Anyone with the link: Viewer**. Copy the link and change the ending `/edit…` to **`/copy`**. That's the link you send owners: it opens "Make a copy", and the copy includes the script.

Re-do step 2 whenever `Code.gs` changes, so new shops get the latest version.

## 1. Collect from the owner

- Shop name, one-line tagline, Instagram username, logo (PNG, transparent if possible) and brand color.
- Product photos, **already watermarked**, one per product, named by the SKUs they enter in INVENTORY (step 3). They're the only content that comes to you, because `photos.sh` runs in the shop's repo.

Everything else the owner types straight into their sheet: the product list, payment and pickup text, closing date and alert email.

## 2. The owner copies the template

Send the owner the `/copy` link. They click **Make a copy**, keep the name or rename it, and then:

- Share it with you as **Editor** (Share ▸ your email ▸ Editor). That lets you set it up and fix things later.
- Customer data stays in the owner's Drive. You only have the access they give you.

## 3. The owner fills the sheet

The owner does this in their copy, using `owner-guide.md` as the reference. You only review it.

- **INVENTORY**: delete the sample rows and add one row per product: SKU (their own code, e.g. `stickers-001`; it names the photo file), category, name, short description, price and stock. Leave the grey columns alone.
- **SETTINGS**: Subheading, Notes, Instagram, Close At, Notify Email, and colors (optional).
- **TEMPLATES**: replace "(your payment details here)" and "(Pickup or delivery details here.)".
- They then send you the photos, named by SKU.

You check it by running **Pre-order ▸ Check setup**. It should report the products and "Orders are OPEN". Look for photos whose name doesn't match a SKU, and for SKUs that have no photo.

## 4. Deploy the web app and authorize it: "the API key step"

The owner should do this in their own account, on a call with you sharing their screen, because the web app runs as whoever deploys it. That person's account reads and writes the sheet and sends the alert emails. If you deploy it yourself, everything runs as you, and the shop breaks if your access is ever removed.

In the owner's sheet:

1. **Extensions ▸ Apps Script**. The **Pre-order** project opens; the code is already there.
2. **Deploy ▸ New deployment**. Click the gear next to "Select type" and choose **Web app**.
   - Description: `v1`
   - Execute as: **Me (owner@gmail.com)**
   - Who has access: **Anyone** (not "Anyone with Google account"; customers don't sign in)
3. Click **Deploy**, then **Authorize access**, and pick the owner's account. Google now shows its warning screens. They're expected, because the script is private to this sheet and was never submitted to Google for review:
   - **"Google hasn't verified this app"**: click **Advanced**, then **Go to Pre-order (unsafe)**. "Unsafe" only means "not reviewed by Google". The developer is the owner's own copy of the script.
   - **"Pre-order wants to access your Google Account"**: it asks for three permissions. Tell the owner what each one is for:
     - *See, edit, create and delete only the specific Google Sheets you use this app with*: this one sheet only, not the rest of their Drive.
     - *Send email as you*: only the new-order alert to their Notify Email.
     - *Display and run third-party web content in prompts and sidebars*: the Pre-order menu and its pop-ups.
   - Click **Allow**.
4. Copy the **Web app URL** (`https://script.google.com/macros/s/AKfy…/exec`). That's the "key" the website needs. It isn't secret: anyone can place orders through it, the same as through the website.
5. Check it: open `<URL>?action=ping` in a browser. You should see `{"status":200,"ok":true,"api":1}`.

Owners can see and revoke access anytime at <https://myaccount.google.com/permissions>. Revoking it stops the shop.

## 5. The website (owner's GitHub, you build it)

The repo and the site belong to the owner, so the shop keeps working and stays theirs even if you stop maintaining it. You work on it as a collaborator.

**The owner** does this, on the same call or with screenshots:

1. Sign up at <https://github.com/signup> (free plan) and verify the email address. The username becomes part of the site address: `https://<username>.github.io/<repo>/`.
2. Open the starter repo link you send them, then click **Use this template ▸ Create a new repository**.
   - Owner: their own account. Repository name: after the shop, e.g. `myshop-preorder`.
   - Visibility: **Public**, which free GitHub Pages requires.
3. In the new repo, go to **Settings ▸ Pages ▸ Build and deployment ▸ Source: GitHub Actions**. Only the owner can do this, because collaborators can't change a repo's Pages settings. The first workflow run, from the template's initial commit, may already show a red ✗. That's expected, and your first push redeploys.
4. Go to **Settings ▸ Collaborators ▸ Add people**, enter **`Inggo`**, and click **Add Inggo to this repository**.

**You** accept the invitation, from the email or at <https://github.com/notifications>, and then:

1. Clone it (`gh repo clone <owner>/<repo>`) and edit:
   - `web/config.js`: paste the Web app URL into `api`.
   - `web/index.html`: the `<title>`, description and `og:` tags, and "My Shop" in `.shop-name` and `.nav-logo`. For a logo, see `customizing.md`.
   - `web/favicon.svg`: optional; swap it for the shop's icon.
2. Photos: put them in `photos/` named `<SKU>.jpg` (or `.png`, `.webp`, `.heic`), then run `./photos.sh`. It writes small JPEGs to `web/img/` (1000px, about 100–200 KB each, location data stripped). `photos/` is git-ignored, so only the web copies are published.
3. Commit and push. The **Deploy to GitHub Pages** workflow runs on every push, and the site is at `https://<owner>.github.io/<repo>/`.
   - A custom domain is optional. The owner sets it in Settings ▸ Pages ▸ Custom domain (admin only), plus a CNAME record at their DNS host.

## 6. Test before going live

1. Open the site on a phone. The products, photos, notes and colors should show.
2. Place a test order with your own email. Check that:
   - ORDERS and ORDER_ITEMS each get rows, and INVENTORY's Reserved and Available change;
   - the owner gets the alert email;
   - setting Status to **Verified** fills Subject, Message and the yellow Contact Link, and the link opens a prefilled email.
3. Test closing: untick **Orders Open**, reload the site (allow 30 s for the cache), then tick it again.
4. Delete the test rows: clear only **ORDERS A2:J** and **ORDER_ITEMS A2:F**.

## 7. Hand over

Send the owner `owner-guide.md` (or a copy of it as a Google Doc) and the site link. Walk them through one order's status changes.

## Updating a shop's script later

Every shop has its own copy of the script, so a change in `Code.gs` has to be applied to each shop:

1. In the shop's Apps Script editor, paste the new `Code.gs`.
2. **Deploy ▸ Manage deployments ▸ (pencil) ▸ Version: New version ▸ Deploy**. Editing the existing deployment keeps the same URL. A *New deployment* would make a new URL, which would then have to go into `config.js`.

With clasp (`npm i -g @google/clasp`, `clasp login`), you can do it from this repo instead: put a `.clasp.json` with `{"scriptId": "<id from Project Settings>", "rootDir": "apps-script"}` in the repo root (it's git-ignored), then run `clasp push` and `clasp deploy -i <deploymentId>`.

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| Page says "This shop isn't connected yet" | `web/config.js` still has the placeholder URL. |
| Page says "The shop is unavailable right now" | The script threw an error. Open Apps Script ▸ **Executions** to see it. It's usually a renamed tab or a missing header (`Check setup` names it). |
| Page stuck on "Loading…", and the browser console shows a CORS or 302 error | The deployment's access isn't **Anyone**, or the URL ends in `/dev` instead of `/exec`. |
| "Anyone" isn't offered under Who has access | The owner uses a Google Workspace account whose admin blocks public web apps. Use a personal Gmail account. |
| A sheet edit doesn't show on the site | Products and settings are cached for 30 s. |
| A code change doesn't show | You saved but didn't deploy a **new version** of the existing deployment. |
| `#REF!` in a grey column | Something was typed under a header formula. Delete it. |
| No alert emails | Notify Email is blank, or the daily quota was hit (consumer Gmail: 100 recipients/day). |
