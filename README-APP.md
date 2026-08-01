# PullScrew Invoice

One file. Double-click it. That's the whole install.

`PullScrewInvoice.html` — 130 KB, opens in any browser on macOS, Windows, Linux or iPad.
No Node, no Rust, no build step, no internet connection, ever.

## Two ways to run it

**Double-click `PullScrewInvoice.html`** — simplest. Everything works except live-file
saving. Turn on *daily automatic backup* in Settings.

**Double-click `Start PullScrew Invoice.command`** (macOS) or `.bat` (Windows) — serves
the app at `http://localhost:8777` and opens it. Same app, but now
**Settings → Link a file on disk** works, and every change writes straight to a `.json`
file the instant you make it. Leave the small terminal window open while you work;
closing it stops the app. Needs Python, which macOS has.

> **The two are separate.** Browsers key storage to the origin, so data entered by
> double-clicking is *not* visible when launched via localhost, and vice versa. Pick one
> and stay with it. To switch: Export backup from the old one, Import into the new one.

---

## Using it

Double-click `PullScrewInvoice.html`. It opens in your default browser.

First run: go to **Settings** and fill in your business name, logo, address and bank
details. Everything there prints on your documents. Then add a client and make an invoice.

**To get a PDF:** open a document and hit **Print / PDF**, then choose *Save as PDF*
as the destination in the print dialog. That is a real, properly paginated PDF — the
print stylesheet strips the app chrome and lays the page out at Letter or A4.

Tip: bookmark the file, or drag it to your Dock / taskbar.

---

## Where your data lives

On your machine only. Nothing is uploaded anywhere — there is no server to upload to.

The app saves to browser storage (IndexedDB where available, otherwise localStorage —
Chrome blocks IndexedDB on `file://`, which is handled automatically). The sidebar shows
which one is in use.

**Browser storage can be wiped** by clearing site data, and it is per-browser: open the
file in Safari and you won't see data you entered in Chrome. So:

There are three levels of safety net, weakest to strongest:

1. **Export backup** (Settings → Export backup) — manual, writes a `.json` you keep.
   Works everywhere, always. The app nags you if it's been more than two weeks.
2. **Daily automatic backup** (Settings → Automatic backup) — downloads a backup by
   itself the first time you save each day. One file per day into Downloads, so tidy it
   out occasionally. Your browser may ask permission the first time it fires.
   Works when double-clicked.
3. **Live copy on disk** — every change writes straight to a `.json` you choose. Put it
   in Dropbox or iCloud and it backs itself up continuously. **Requires the launcher**
   (see below). This is the strongest option and switches off the daily download, since
   it makes it redundant.

### About "Link a file on disk"

There is a second option that writes every change straight to a `.json` file you choose
— put it in Dropbox or iCloud and your data backs itself up continuously. **It does not
work when you open the app by double-clicking**, and that is not a bug in the app.

Browsers give `file://` pages no origin, and the File System Access API refuses pages
without one. Nothing the app can do changes that. Settings → Your data explains this in
place rather than offering a button that fails.

To use it, run the app through **`Start PullScrew Invoice.command`** (macOS) or
**`.bat`** (Windows) instead. Those serve the file at `http://localhost:8777`, which
gives the page a real origin and unlocks the feature. Chrome or Edge only — Safari and
Firefox don't implement the API at all.

The port is fixed at 8777 deliberately. Storage is keyed to the origin and the origin
includes the port, so changing it would make the app look empty.

Once linked, the app remembers the file across reloads. Browsers still drop write
permission on every page load, so Settings shows a one-click **Reconnect** button; after
that the file is treated as the source of truth and read back on startup.

If a browser blocks storage entirely (private windows sometimes do), the app says so in
a red banner across the top rather than silently losing your work.

---

## What it does

- **Clients** — details entered once, reused on every document
- **Invoices** and **Estimates** — line items, fractional quantities, notes, terms
- **GCT / tax** — configurable name and rate, per-line taxable toggle, charged after discount
- **Discounts** — percentage or fixed amount
- **Estimate → Invoice** — one click, carries items, tax and discount, links both ways
- **Payments** — record part payments; Paid / Part paid / Overdue are derived, not typed
- **Multi-currency** — JMD and USD by default, more available in Settings
- **Numbering** — patterns like `INV-{YYYY}-{####}` with automatic counters
- Light and dark themes, works on phones

---

## Two deliberate design decisions

**Money is never a float.** Amounts are stored as integer cents and quantities as
integer thousandths, so `2.5 hours × 180,000.00` is exact rather than
`449999.99999999994`. Every total is computed in integers and rounded once.

**There are no exchange rates.** Each document keeps its own currency and totals are
reported per currency. A rate you could edit later would silently rewrite the value of
invoices you already sent; this design makes that impossible.

---

## Editing it

It's one plain HTML file — no framework, no bundler, no `npm install`. Open it in any
editor. CSS is at the top, the app is one `<script>` at the bottom, organised as:
utils → money math → storage → state → views → boot.

To change the invoice layout, edit `paperHTML()` and the `.pp-*` CSS rules.

---

## Not included

Recurring invoices, emailing from the app, multi-user access, expense tracking,
and accounting reports. Ask if you want any of them.
