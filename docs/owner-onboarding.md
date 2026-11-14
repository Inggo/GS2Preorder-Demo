# Setting up your pre-order shop

**What you need:** 

1. A personal Google (Gmail) account
2. An email address or account for GitHub
3. Your product photos (JPG, PNG, WebP or HEIC). Watermarks are up to you: if you want one, add it before sending, because I don't add one.
4. Your shop logo (PNG with a transparent background if you have one) and your primary brand color

## 1. Send your shop details

- Your shop name
- Your shop logo and brand color (item 4 above)

That's all I need for now. Everything else, like your tagline, Instagram and Messenger usernames and products, you type into the sheet yourself in step 3.

## 2. Copy the shop sheet

1. Open the **copy link** that I will send you, then click **Make a copy**. You can rename it, e.g. "My Shop Pre-orders".
2. Click **Share**, enter `inggo.espinosa@gmail.com`, choose **Editor**, and click **Send**. This lets me set things up and fix things later.

## 3. Fill in the sheet

Grey columns fill themselves in. Never type in them. For more detail on every tab, see the [owner guide](owner-guide.md).

- **INVENTORY**: delete the three sample rows, then add one row per product:
  - **SKU**: a short code you make up, e.g. `stickers-001`. Don't change it once orders come in.
  - **Category**, **Product Name**, a short **Description**, **Price** (in pesos) and **Inventory** (how many you can sell)
  - Tick **New** for products you want to show at the top with a "New" badge.
- **SETTINGS**: fill the **Value** column:
  - **Subheading** and **Note** rows: the text at the top of your site
  - **Instagram** / **Messenger**: your usernames, shown as links. Leave one blank to hide it.
  - **Contact Fields**: how customers can ask you to reach them. Delete the rows you don't want (Email, Messenger, Instagram).
  - **Close At**: when orders close by themselves, e.g. `2026-12-01 00:00`
  - **Notify Email**: where your new-order alerts go
  - **Theme**: the look of your site, `default` (clean and simple) or `art-crafts` (washi tape, playful)
  - Colors are optional.
- **TEMPLATES**: replace "(your payment details here)" and "(Pickup or delivery details here.)" with your own details.

**Photos:** name each photo after its SKU, e.g. `stickers-001.jpg`, and send them all to me in a zip file or Google Drive share.

## 4. Turn on the shop's connection

This lets the website read your products and save orders into your sheet. It runs as *your* Google account, so you do it yourself.

1. In your sheet: **Extensions ▸ Apps Script**. The **GS2Preorder** project opens; **don't change the code**.
2. Click **Deploy ▸ New deployment**. Click the gear next to "Select type" and choose **Web app**.
   - Description: `v1`
   - Execute as: **Me**
   - Who has access: **Anyone**. Your customers don't sign in, so it can't be "Anyone with Google account".
3. Click **Deploy**, then **Authorize access**, and pick your account. Google now shows warnings. **They're expected**, because this script belongs only to your sheet and was never sent to Google for review:
   - **"Google hasn't verified this app"**: click **Advanced**, then **Go to GS2Preorder (unsafe)**. "Unsafe" just means "not reviewed by Google".
   - **"GS2Preorder wants to access your Google Account"**: tick **Select all**, then click **Continue** (or **Allow**). Here's what each permission is for:
     - *See, edit, create and delete only the specific Google Sheets you use this app with*: only this one sheet, not the rest of your Drive.
     - *Send email as you*: only the new-order alerts to your Notify Email.
     - *Display and run third-party web content in prompts and sidebars*: the GS2Preorder menu in your sheet.
4. Copy the **Web app URL** (it starts with `https://script.google.com/macros/s/` and ends in `/exec`) and send it to me. This isn't a password, so it's fine to send by chat or email.

You can see this access anytime at <https://myaccount.google.com/permissions>. **Don't remove GS2Preorder there**, or your shop stops taking orders. Right after this, Google emails you a **"Security alert"** from `no-reply@accounts.google.com` saying *"GS2Preorder was granted access to your Google Account"*. That one is expected. If an alert names any other app, don't ignore it: tell me.

## 5. Create the website's home on GitHub

Your website lives in your own GitHub account for free.

1. Sign up at <https://github.com/signup> (the free plan is all you need) and verify your email address. Pick your username carefully: it becomes part of your site's address, `https://<username>.github.io/<repository>/`.
2. Click **+** (top right) ▸ **New repository**:
   - Repository name: your shop's name, e.g. `myshop-preorder`
   - **Public**: the free plan only publishes public repositories. Only the website's code goes in it, never your orders or customers.
   - Leave everything else **off**: no README, no .gitignore, no license. Then click **Create repository**.
3. In the new repository: **Settings ▸ Collaborators ▸ Add people**, type **`Inggo`**, and click **Add Inggo to this repository**. This lets me update the site.
4. Still in **Settings**: **Pages ▸ Build and deployment ▸ Source**: choose **GitHub Actions**. If you don't see that option yet, do this step after I tell you the code is uploaded.

## 6. Done

I will:

- finish the website and send you its link
- place a test order, confirm if you can see it, and then delete it
- go through the owner guide with you: how to handle an order from **Pending** to **Verified** to **Paid**

After that, you run everything from your sheet. You never need to edit anything on GitHub.
