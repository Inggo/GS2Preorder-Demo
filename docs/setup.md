# Onboarding a shop (operator runbook)

This takes about an hour per shop, most of it filling in products. The owner needs a Google account (a personal Gmail is safest, see *Troubleshooting*) and a GitHub account, because the shop's repo and site live in their account. Your GitHub account needs collaborator access to their repo and you need ImageMagick for optimizing Photos.

**There is no API key.** The lite backend is an Apps Script that lives *inside the owner's sheet* and runs as the owner. In place of an API key there's a one-time **authorization** (step 4), where the owner clicks through Google's "unverified app" screens. That step is where owners get nervous, so it's covered in detail. (The pro version does use a Google Cloud service account instead; see `pro.md`.)

## 0. One time: build the master template (you)

The code lives in this repo, `Inggo/GS2Preorder`, which is **private**. It is not a GitHub template repo: owners never touch it, and you push it into each shop's repo yourself (step 5). Its Pages workflow skips private repos, so pushing the starter deploys nothing.

1. Create a blank Google Sheet named **GS2Preorder Template**. File ▸ Settings: Locale **Philippines**, Time zone **(GMT+08:00) Manila**.
2. Extensions ▸ Apps Script. Name the project **GS2Preorder**.
   - Project Settings (gear) ▸ tick **Show "appsscript.json" manifest file in editor**.
   - Replace `Code.gs` with `apps-script/Code.gs` from this repo, and `appsscript.json` with `apps-script/appsscript.json`. Save.
3. Back in the sheet, reload. A **GS2Preorder** menu appears. Run **GS2Preorder ▸ Set up sheet** and authorize it as yourself (same screens as step 4). It adds all the tabs with sample rows.
4. Share ▸ General access: **Anyone with the link: Viewer**. Copy the link and change the ending `/edit…` to **`/copy`**. That's the link you send owners: it opens "Make a copy", and the copy includes the script.

Re-do step 2 whenever `Code.gs` changes, so new shops get the latest version.

## 1. Collect from the owner

- Shop name, logo (PNG, transparent if possible) and brand color: these go into `web/index.html`. The tagline and the Instagram and Messenger usernames the owner types into SETTINGS.
- Product photos, one per product (watermarking is optional and up to the owner; lite doesn't add one), named by the SKUs they enter in INVENTORY (step 3). They're the only content that comes to you, because `photos.sh` runs in the shop's repo.

Everything else the owner types straight into their sheet: the product list, payment and pickup text, closing date and alert email.

## 2. The owner copies the template

Send the owner the `/copy` link. They click **Make a copy**, keep the name or rename it, and then:

- Share it with you as **Editor** (Share ▸ your email ▸ Editor). That lets you set it up and fix things later.
- Customer data stays in the owner's Drive. You only have the access they give you.

## 3. The owner fills the sheet

The owner does this in their copy, using `owner-guide.md` as the reference. You only review it.

- **INVENTORY**: delete the sample rows and add one row per product: SKU (their own code, e.g. `stickers-001`; it names the photo file), category, name, short description, price and stock. Leave the grey columns alone.
- **SETTINGS**: Subheading, Notes, Instagram, Messenger, Contact Fields (delete the rows for contact options the shop doesn't want), Close At, Notify Email, and colors (optional).
- **TEMPLATES**: replace "(your payment details here)" and "(Pickup or delivery details here.)".
- They then send you the photos, named by SKU.

You check it by running **GS2Preorder ▸ Check setup**. It should report the products and "Orders are OPEN". Look for photos whose name doesn't match a SKU, and for SKUs that have no photo.

## 4. Deploy the web app and authorize it: "the API key step"

The owner does this in their own account, because the web app runs as whoever deploys it. That person's account reads and writes the sheet and sends the alert emails. If you deploy it yourself, everything runs as you, and the shop breaks if your access is ever removed.

In the owner's sheet:

1. **Extensions ▸ Apps Script**. The **GS2Preorder** project opens; the code is already there.
2. **Deploy ▸ New deployment**. Click the gear next to "Select type" and choose **Web app**.
   - Description: `v1`
   - Execute as: **Me (owner@gmail.com)**
   - Who has access: **Anyone** (not "Anyone with Google account"; customers don't sign in)
3. Click **Deploy**, then **Authorize access**, and pick the owner's account. Google now shows its warning screens. They're expected, because the script is private to this sheet and was never submitted to Google for review:
   - **"Google hasn't verified this app"**: click **Advanced**, then **Go to GS2Preorder (unsafe)**. "Unsafe" only means "not reviewed by Google". The developer is the owner's own copy of the script.
   - **"GS2Preorder wants to access your Google Account"**: it asks for three permissions. Tell the owner what each one is for:
     - *See, edit, create and delete only the specific Google Sheets you use this app with*: this one sheet only, not the rest of their Drive.
     - *Send email as you*: only the new-order alert to their Notify Email.
     - *Display and run third-party web content in prompts and sidebars*: the GS2Preorder menu and its pop-ups.
   - If Google shows a checkbox for each permission, tick **Select all**. All three are needed. Then click **Continue** (or **Allow**).
4. Copy the **Web app URL** (`https://script.google.com/macros/s/AKfy…/exec`). That's the "key" the website needs. It isn't secret: anyone can place orders through it, the same as through the website.
5. Check it: open `<URL>?action=ping` in a browser. You should see `{"status":200,"ok":true,"api":1}`.

Owners can see and revoke access anytime at <https://myaccount.google.com/permissions>. Revoking it stops the shop.

## 5. The website (owner's GitHub, you build it)

The repo and the site belong to the owner, so the shop keeps working and stays theirs even if you stop maintaining it. You work on it as a collaborator.

**The owner** does this:

1. Sign up at <https://github.com/signup> (free plan) and verify the email address. The username becomes part of the site address: `https://<username>.github.io/<repo>/`.
2. Click **+ ▸ New repository**:
   - Owner: their own account. Repository name: after the shop, e.g. `myshop-preorder`.
   - Visibility: **Public**, which free GitHub Pages requires.
   - Leave it **empty**: no README, no .gitignore, no license. You push the starter into it.
3. Go to **Settings ▸ Collaborators ▸ Add people**, enter **`Inggo`**, and click **Add Inggo to this repository**.
4. Go to **Settings ▸ Pages ▸ Build and deployment ▸ Source: GitHub Actions**. Only the owner can do this, because collaborators can't change a repo's Pages settings. If the page doesn't offer it while the repo is still empty, come back to it after your first push.

The starter repo (this one) is **private**, so the owner never sees or needs access to it. **You** accept the invitation, from the email or at <https://github.com/notifications>, and push the starter into the owner's repo:

```bash
git clone git@github.com:Inggo/GS2Preorder.git myshop-preorder
cd myshop-preorder
git remote rename origin starter                        # the starter stays a remote, for updates later
git remote add origin git@github.com:<owner>/myshop-preorder.git
git push -u origin master
```

Because the shop repo shares the starter's history, you can pull starter updates later (see *Updating a shop's site later*). It also means the starter's **whole commit history becomes public** in every shop repo. That's one more reason the starter must never contain shop data, secrets or anything else you wouldn't publish.

Then:

1. Edit:
   - `web/config.js`: paste the Web app URL into `api`.
   - `web/index.html`: the `<title>`, description and `og:` tags, and "My Shop" in `.shop-name` and `.nav-logo`. For a logo, see `customizing.md`.
   - `web/favicon.svg`: optional; swap it for the shop's icon.
   - `web/shop.css`: optional; the shop's own styles (brand color default, background, logo sizing). Don't edit `style.css`. See `customizing.md`.
2. Photos: put them in `photos/` named `<SKU>.jpg` (or `.png`, `.webp`, `.heic`), then run `./photos.sh`. It writes small JPEGs to `web/img/` (1000px, about 100–200 KB each, location data stripped). `photos/` is git-ignored, so only the web copies are published.
3. Commit and push. The **Deploy to GitHub Pages** workflow runs on every push, and the site is at `https://<owner>.github.io/<repo>/`. If a run failed because Pages wasn't on yet, re-run it once the owner has turned Pages on: `gh workflow run pages.yml`, or Actions ▸ Deploy to GitHub Pages ▸ Run workflow.
   - A custom domain is optional. The owner sets it in Settings ▸ Pages ▸ Custom domain (admin only), plus a CNAME record at their DNS host.

## 6. Test before going live

1. Open the site on a phone. The products, photos, notes and colors should show.
2. Place a test order with your own email. Check that:
   - ORDERS and ORDER_ITEMS each get rows, and INVENTORY's Reserved and Available change;
   - the owner gets the alert email;
   - setting Status to **Verified** fills Subject, Message and the yellow Contact Link, and the link opens a prefilled email.
3. Test closing: untick **Orders Open**, reload the site (allow 30 s for the cache), then tick it again.
4. Delete the test rows: clear only **ORDERS A2:K** and **ORDER_ITEMS A2:F**.

## 7. Hand over

Send the owner `owner-guide.md` (or a copy of it as a Google Doc) and the site link. Walk them through one order's status changes.

## Updating a shop's site later

To bring starter changes (`web/app.js`, `style.css`, the workflow) into a shop:

```bash
cd myshop-preorder
git pull starter master          # merges the starter into the shop's own edits
git push                       # redeploys the site
```

Conflicts usually show up only in files the shop customized (`web/index.html`, `web/config.js`). Keep the shop's values. For a shop repo cloned somewhere else, first add the remote: `git remote add starter git@github.com:Inggo/GS2Preorder.git`.

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
