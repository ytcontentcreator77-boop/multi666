# Implementation status

## Included in this update

- Generic standard-SMM-API provider add, edit, enable/disable and removal controls.
- Provider catalog import with category selection, platform selection, service search and multi-select import.
- Imported-service order routing and scheduled status polling.
- Provider cancellation and refill actions for imported orders when the provider advertises those capabilities.
- Admin pages for provider services, service/category icons, currency rates, payment-method configuration and editable Telegram bot message templates.
- Message overrides for welcome, order lifecycle, refunds, top-ups, help and referral messages. Blank fields use built-in translated defaults.
- First-run setup no longer asks for a single supplier's API key; connect suppliers in Admin → Providers after setup.
- Legacy provider-specific catalogue sync and provider-balance alert are disabled. Existing legacy services are disabled by migration `0018_provider_first.sql`.
- Professional responsive styles for the new admin screens; existing customer UI and theme system are preserved.

## Not included / needs a separate implementation

- Non-Stars payment checkout and payment verification (UPI, Paytm, eSewa, Khalti, bank transfer, bKash, Binance and crypto). The admin screen clearly warns that enabling a method only saves its configuration; it does not create a live gateway.
- Customer top-up method/currency checkout. The existing Telegram Stars top-up remains the only live customer top-up.
- Automatic cheapest-provider selection per category and provider price refresh scheduling. Imported services can be re-imported to update them; there is no automated cross-provider price optimizer yet.
- Full visual redesign of every customer screen. Existing customer screens and styles are retained; the new admin pages use a consistent responsive card layout.
- Full removal of the old internal adapter code. It remains isolated for historical provider_id=0 order compatibility, but its branding and key setup are removed from the visible app flow.

## Validation

- All SQL migrations were applied to an in-memory SQLite database successfully.
- All TypeScript/TSX source files passed TypeScript parser syntax checks.
- Full typecheck, unit tests and production build were not run because dependencies are not installed in this environment. Run `npm ci`, then `npm run typecheck && npm test && npm run build` before deployment.

## Currency catalog extension (2026-11-18)

- Added migration `0019_currency_catalog.sql` with additional currencies including USDT (₮) and 37 further codes. The catalog now contains 61 entries after the migrations.
- Added an admin form to add a currency (code, name, symbol, units per USD), and validation/duplicate handling in the admin API.
- Currency rates are editable; the seeded rates are reference values and must be refreshed by the admin.

## Still not implemented in this update

- Per-user currency selection and app-wide conversion/display of balances, order costs, refunds and bot messages.
- Free-service claims, reset windows, multi-channel membership checks and the corresponding customer menu/admin editor.
- Live manual-payment checkout (QR uploads, payment proof/approval, fees/bonus crediting) and multi-method top-up flow.
- Ticket-system UI redesign and new TOS workflow beyond the existing Terms page.

## Validation of this update

- SQLite migrations `0001` through `0019` were applied in order to an in-memory database successfully; currency catalog count is 61.
- `npm ci` did not finish in the available time, and the environment is Node 22 while this project requires Node 24; typecheck, tests and build remain unverified.

## Customer feature API foundation (2026-11-18)

- Added migration `0020_customer_features.sql`: per-user currency preference (default USDT), free-service campaign/channel/claim tables, support ticket/message tables and manual-payment request records.
- Added authenticated customer API endpoints for enabled currency listing and preference updates, free-service campaign listing and required-channel membership checks, support ticket creation/replies/history, manual payment method listing and manual payment requests.
- Added owner-only admin API endpoints to create/update/delete free-service campaigns (provider-imported service IDs, min/max, reset interval and up to 20 required channels), review support tickets and approve/reject manual payment requests. Approval credits the internal USD balance and records a ledger entry idempotently.
- These are backend APIs, not a completed customer/admin UI. Free-service claim fulfillment is not wired to provider order submission; manual payment proof upload/QR asset workflow, full payment UI, customer currency formatting across every screen and bot notification, ticket UI, and complete TOS page workflow remain unfinished. Telegram Stars checkout is still the only complete payment gateway.
- Validation: full TypeScript/build/test checks remain unavailable because the installed `node_modules` is incomplete (missing `@cloudflare/workers-types` and `vite/client`) and runtime is Node 22 while project requires Node 24. Migration validation is performed separately.

## Customer-facing implementation pass (2026-11-18)

- Added currency preference fields to the authenticated `/me` response and changed app-wide micro-USD amount/balance formatting to the selected currency symbol and configured currency rate.
- Added customer currency settings screen, free-services screen, support ticket inbox/thread/create/reply UI, and manual top-up screen; linked these from Profile and Wallet.
- Connected free-service claim submission to the existing provider order lifecycle with zero customer charge, configured quantity bounds, per-user reset window, and Telegram membership enforcement for all campaign channels.
- Added admin screens for free-service campaigns, support tickets, and manual payment review.
- Added manual-payment method max amount, bonus percentage and QR image URL fields; exposed these in admin configuration and customer checkout, and included the configured bonus in the credited amount.
- Added migration `0021_manual_payment_options.sql`.
