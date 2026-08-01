# PullScrew Invoice

One file. Double-click it. That's the whole install.

`PullScrewInvoice.html` — 119 KB, opens in any browser on macOS, Windows, Linux or iPad.
No Node, no Rust, no build step, no internet connection, ever.

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

- **Export a backup** (Settings → Export backup) — writes a `.json` file you keep.
  The app nags you if it's been more than two weeks. This works everywhere, always.

### About "Link a file on disk"

There is a second option that writes every change straight to a `.json` file you choose
— put it in Dropbox or iCloud and your data backs itself up continuously. **It does not
work when you open the app by double-clicking**, and that is not a bug in the app.

Browsers give `file://` pages no origin, and the File System Access API refuses pages
without one. Nothing the app can do changes that. Settings → Your data explains this in
place rather than offering a button that fails.

If you want it, the file has to be *served* rather than double-clicked. From the folder
holding the file:

```
python3 -m http.server 8000
```

then open `http://localhost:8000/PullScrewInvoice.html`. Chrome or Edge only — Safari
and Firefox don't implement the API at all.

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
