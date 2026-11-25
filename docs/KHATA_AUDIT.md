# Khata / Udhar Audit (customers and suppliers)

Audit of the credit ledger for a Pakistani shop. Read-only: no code was changed, no tests or builds were run. Every row below was checked in code.

- **FE** = this repo (`d:\flutter\sas\frantend`), **BE** = `D:\flutter\sas\backend` (FastAPI, read-only look).
- Status: **BUILT** = works end to end, **PARTIAL** = something important is missing, **NOT BUILT** = no code path.
- Comparisons to DigiKhata / EasyKhata in section F come from general knowledge of those apps, not from this code.

## Scorecard

| Section | BUILT | PARTIAL | NOT BUILT | Items |
|---|---|---|---|---|
| A. Customers | 7 | 5 | 10 | 22 |
| B. Suppliers | 0 | 6 | 11 | 17 |
| C. Dashboards / reports | 2 | 2 | 3 | 7 |
| **Total** | **9** | **13** | **24** | **46** |

Customers are in decent shape for "sell on udhar, take payment, see balance". Suppliers are only half-wired: the payable grows on every GRN, but **there is no screen to pay a supplier**.

---

## A. Customers

| # | Item | Status | What exists (exact) / what is missing |
|---|---|---|---|
| A1 | Credit sale at POS (credit portion) | BUILT | Payment modal has "Credit (Udhaar)" method (`FE lib/features/pos/presentation/pages/payment_modal.dart:523`). `PaymentAllocator` applies non-cash, then cash (with change), then credit takes exactly the remainder and needs a customer (`FE lib/features/pos/domain/utils/payment_allocator.dart:108-175`). Sale can complete only if lines sum to total (`canComplete`, same file :91-96). Server writes one `sale` ledger row of `-credit_amount` (`BE app/services/sale_service.py:754-765`); also for restaurant tabs (`BE app/services/restaurant_tab_service.py:803-814`). |
| A2 | Credit limit check | BUILT | `credit_limit` per customer, 0 = no limit (`BE app/models/sales.py:45`; form field `FE lib/features/customers/presentation/pages/customer_form_page.dart:193`). Client check `payment_allocator.dart:159-170`. Server check with customer row lock, so two concurrent sales cannot both pass (`BE app/services/customer_service.py:97-125`, called `sale_service.py:561-571`). Offline-synced sales are **not rejected**, only flagged `credit_limit_exceeded` + notification (`BE app/services/sync_push.py:695-699`). |
| A3 | Who can override the limit | NOT BUILT | No override permission, PIN, or flag anywhere. Over-limit is a hard block (HTTP 400). Only workaround is editing the limit (`customers.update`). |
| A4 | Ledger entry: sale | BUILT | `entry_type='sale'`, negative amount (`sale_service.py:755-765`). No notes text on the row. |
| A5 | Ledger entry: payment (receive money, no sale needed) | BUILT | Customer page, "Record Payment" (`FE lib/features/customers/presentation/widgets/record_payment_dialog.dart`, cubit `customer_ledger_cubit.dart:199-262`) calls `POST /customers/{id}/payments` (`BE app/routers/customers.py:123-160`). Row `payment`, positive, `reference_type='manual'`, `reference_id=customer_id` (`customer_service.py:305-316`). Method and ref no. are only text inside `notes`. |
| A6 | Ledger entry: return / void | BUILT | Return writes `return` row for the part not paid back in cash (`BE app/services/return_service.py:495, 639-650`). Void/cancel of a credit sale writes a positive `refund` row (`sale_service.py:880-922`). |
| A7 | Ledger entry: adjustment | NOT BUILT | Enum value exists (`BE app/models/enums.py:272-278`, label in `customer_balance_utils.dart:57`) but no code ever writes it. |
| A8 | Manual "give" entry (udhar without a sale) | NOT BUILT | Only money **received** can be entered. There is no endpoint or button to add to what a customer owes without a POS sale. |
| A9 | Opening balance (purana hisaab) | NOT BUILT | Enum `opening_balance` only. `CreateCustomerRequest` has no field (`BE app/schemas/sales.py:26-41`); customer form has none; no import column. |
| A10 | Payment allocation to specific sales | NOT BUILT | Payment row points at the customer, not a sale (`customer_service.py:312-313`). No per-bill outstanding or "unpaid bills" list. Balance exists only per customer. |
| A11 | Due dates / payment terms / promise dates | NOT BUILT | No column on `customers`, `sales`, or `customer_ledger`. `NotificationTypeEnum.payment_due` exists (`enums.py:383`) but nothing emits it. |
| A12 | Notes | PARTIAL | Free text on a payment (`notes`). No notes on credit sale rows, no customer-level note, no edit of notes. |
| A13 | Balance display + "who owes me" list | PARTIAL | Balance column and "has outstanding" filter on the customers list (`customers_data_table.dart`, `customers_list_cubit.dart:100-122`); ledger header shows balance and limit. Gaps: one request per customer to load balances (`customers_list_cubit.dart:59-72`), no total, no sort/default by amount owed, no dedicated udhar screen. Receipt can print previous balance and balance after (`BE app/services/invoice_service.py:164-186`, `FE lib/features/receipts/data/receipt_context_loader.dart:184`). |
| A14 | Aging 30/60/90 | NOT BUILT | No query, endpoint, or screen. |
| A15 | Customer statement (PDF / print / WhatsApp text) | NOT BUILT | Only CSV/XLSX export. WhatsApp and PDF exist for **sale receipts** only (`FE lib/features/sales/presentation/services/receipt_share_service.dart`), nothing for an account statement. |
| A16 | Reminders (WhatsApp / SMS / notification) | NOT BUILT | `UrlLauncherService` can open `wa.me` (`FE lib/core/platform/url_launcher_service.dart`) but is not used for customers. `NotificationChannelEnum.sms` exists in the enum, no sender. |
| A17 | Cash drawer / shift effect of a customer payment | BUILT | Cash + `register_shift_id` writes a `cash_in` register transaction (`customer_service.py:321-339`); offline equivalent `sync_push.py:1013-1025`. Non-cash writes ledger only. If no shift is open the payment is accepted into the ledger only; the dialog shows a warning (`record_payment_dialog.dart:288-300`). See E14. |
| A18 | Offline behaviour | BUILT | Customer create, credit sale, payment, return, void go through the outbox (`FE lib/core/sync/outbox_op.dart:33-40`). Balance is computed locally from pulled balance + pending credit - pending payments (`FE lib/core/sync/sync_store.dart:1160-1195`). Ledger lines need the server (`customer_ledger_cubit.dart:176-190`). Payment replay is safe: client ledger id checked (`sync_push.py:958-959`). |
| A19 | Permissions | PARTIAL | `customers.view/create/update/ledger.view` (`BE app/routers/customers.py`). Payment uses `customers.update` (:132), there is no payment-specific key. Cashier role has `view`+`create` only (`BE app/services/role_permission_seed.py:174-192`). See E9. No FE `Perm` constant for `customers.ledger.view` (`FE lib/core/permissions/permission_keys.dart:35-37`). |
| A20 | Branch scope | PARTIAL | Ledger rows carry `branch_id`; balance and ledger endpoints are branch-scoped (`customers.py:94, 111`, `branch_scope.py:82-86`). Customers themselves are business-wide. Offline credit-sale rows have no branch (E5); dashboard receivable ignores branch (E8). |
| A21 | Export | PARTIAL | `customers` (with balance) and `customer_ledger` datasets, gated by `reports.export` + `customers.view` / `customers.ledger.view` (`BE app/services/export_datasets.py:655-668`). The per-customer "Export Ledger" button does not filter by customer (E7). |
| A22 | Undo / reverse a wrong payment | NOT BUILT | No void/delete/reversal endpoint for customer payments. A mistake can only be fixed by a DB edit. |

---

## B. Suppliers

| # | Item | Status | What exists (exact) / what is missing |
|---|---|---|---|
| B1 | Pay at GRN: full cash / partial / all credit | NOT BUILT | `CreatePurchaseReceiptRequest` has no payment fields (`BE app/schemas/inventory.py:99-106`). GRN screen only has supplier invoice no. and lines (`FE lib/features/purchases/presentation/pages/goods_receipt_page.dart:129`). Everything received is booked as payable. |
| B2 | Same in Quick Add (purchase mode) | NOT BUILT | Request carries `supplier_id` + lines only (`FE lib/features/quick_add/domain/quick_add_models.dart:152-163`, `BE app/schemas/quick_add.py:109-114`). Quick Add calls `create_purchase_receipt` (`BE app/services/quick_add_service.py:648`), so the full value goes on the supplier's account. |
| B3 | Ledger entry: purchase | PARTIAL | One negative row **per GRN line** (`BE app/services/purchase_service.py:447-461`) with `entry_type='sale'` (wrong label; the enum has no `purchase`). Not per GRN, no invoice no. on the row. |
| B4 | Ledger entry: payment | PARTIAL | `POST /supplier-ledger/{id}/payment` (`BE app/routers/supplier_ledger.py:73-90`, perm `suppliers.ledger.payment`, idempotent). **No UI calls it.** `Perm.suppliersLedgerPayment` is defined and never used (`permission_keys.dart:41`). |
| B5 | Purchase returns / credit notes | NOT BUILT | `purchase_return` exists only as an enum value (`enums.py:117`). No router, service, or screen. |
| B6 | Ledger entry: adjustment / manual | NOT BUILT | No writer. |
| B7 | Supplier payment screen | NOT BUILT | `FE lib/features/suppliers/` has list + form only. No ledger page, no route (`FE lib/core/router/app_router.dart:398-420`). |
| B8 | Effect of supplier payment on cash register / shift / bank | NOT BUILT | `record_supplier_payment` writes one ledger row; `payment_method` is accepted and then dropped, no `RegisterTransaction`, no bank account (`BE app/services/supplier_ledger_service.py:105-126`). Compare customer side `customer_service.py:321-339`. |
| B9 | Allocation to specific purchases / GRNs | NOT BUILT | Payment row has no reference to a GRN (`supplier_ledger_service.py:115-124`). |
| B10 | Due dates / payment terms | PARTIAL | `payment_terms_days` (default 30) stored and editable (`BE app/models/inventory.py:43`, `FE supplier_form_page.dart:204`), exported and searched. Never used to compute a due date or overdue. |
| B11 | "Who do I owe" list | PARTIAL | Suppliers list has "Outstanding Balance" column (`suppliers_data_table.dart:19`) showing the raw signed string (negative = we owe, `:99`). Dashboard "Payables" card (`FE dashboard_page.dart:254`). No filter/sort for owed-only, no total. |
| B12 | Aging | NOT BUILT | No code. |
| B13 | Supplier statement | NOT BUILT | No code. |
| B14 | Opening balance | NOT BUILT | No code. |
| B15 | Offline behaviour | NOT BUILT | Suppliers, POs, GRN, Quick Add purchase, supplier payment are not in `OpTypes` (`outbox_op.dart:33-40`) and not handled in `sync_push.py`. Online only. |
| B16 | Permissions | PARTIAL | API is gated: `suppliers.ledger.view` / `suppliers.ledger.payment` (`supplier_ledger.py:33, 59, 80`); owner/manager have them, cashier does not (`role_permission_seed.py:119-120`). Payment branch is checked (`assert_branch_access`). No UI, so effectively unused. No audit log (E11). |
| B17 | Export | PARTIAL | Datasets `suppliers` (with balance) and `supplier_ledger` exist (`export_datasets.py:671-683`). UI only exports the suppliers list (`suppliers_list_toolbar.dart:36`). No per-supplier ledger export. |

---

## C. Dashboards and reports

| # | Item | Status | Where / gap |
|---|---|---|---|
| C1 | Total receivable | BUILT | Dashboard "Receivables" card = sum of negative customer balances (`BE app/services/analytics_service.py:297-306, 2192-2201`; `FE dashboard_page.dart:247`). Not branch-aware (E8). |
| C2 | Total payable | BUILT | Dashboard "Payables" card (`analytics_service.py:308-317`; `FE dashboard_page.dart:254`). Not branch-aware (E8); inflated by E2/E3. |
| C3 | Overdue amounts | NOT BUILT | No due dates exist. |
| C4 | Top debtors | PARTIAL | `GET /analytics/customer-insights?sort_by=balance` returns `outstanding_balance` (`BE app/routers/analytics.py:261-271`, `analytics_service.py:1251-1323`). Shown only as a sortable "Outstanding" column in the Top Customers table (`FE reports_data_tables.dart:379-430`). No dedicated top-debtors view; capped at 50; includes customers with zero balance. |
| C5 | Collection this month | NOT BUILT | No query over `payment` ledger rows. |
| C6 | Month-end summary | NOT BUILT | No code. |
| C7 | Present in reports / export datasets | PARTIAL | Export datasets: `customers`, `customer_ledger`, `suppliers`, `supplier_ledger`. Reports tab "Customer Balances" is only a link card to Customers (`FE reports_tab_views.dart:168-173`). No receivable/payable/aging dataset. |

---

## D. Data model facts

| Topic | Fact |
|---|---|
| Tables | `customer_ledger` (`BE app/models/sales.py:68-129`, DDL `BE schema/006_group5_sales.sql:41-63`) and `supplier_ledger` (`BE app/models/expense.py:180-`, DDL `BE schema/008_group7_expenses.sql:97-118`). |
| Columns | `id, business_id, branch_id (nullable), customer_id/supplier_id, entry_type (ledger_entry_type_enum), amount NUMERIC(15,2), reference_type, reference_id, entry_at, notes, sync_status, created_at, updated_at, deleted_at, created_by`. DDL has `CHECK (amount <> 0)`. |
| `entry_type` values | `sale, payment, return, opening_balance, adjustment, refund` (`enums.py:272-278`), shared by both ledgers. Supplier purchases reuse `sale`. |
| Sign convention | Both ledgers: **negative = owed** (customer owes us / we owe supplier), **positive = money paid or credit**. Documented in `sales.py:71-76`, `expense.py:183-188`. Comment in `schema/006_group5_sales.sql:46` says the opposite (E12). |
| Balance | **Computed, not stored**: `SUM(amount) WHERE deleted_at IS NULL` per request (`customer_service.py:188-205`, `supplier_ledger_service.py:21-38`). No balance column on `customers` / `suppliers`. `balance_owed` (positive = owes) is derived only in the sync pull feed (`BE app/services/sync_feed.py:343, 352`). FE keeps a local copy of the balance (`local_customers` via pull, plus pending ops). |
| Indexes | Customer: `idx_customer_ledger_customer (business_id, customer_id, entry_at)` and `..._reference (business_id, reference_type, reference_id)` (`schema/006:62-63`); partial `idx_customer_ledger_customer_bal (business_id, customer_id) WHERE deleted_at IS NULL` and `_export_date` (`BE alembic/versions/022_export_performance_indexes.py:67-76`); `idx_customer_ledger_business_branch_date` (`024_platform_hardening.py:88-92`). Supplier: same pattern (`schema/008:117-118`, `022:77-86`, `024:103-107`). No index on `(customer_id, amount)`; no per-sale outstanding table. |
| Reversals | Append-only. Void/cancel adds a positive `refund` row for the credit part (`sale_service.py:880-922`). Return adds a `return` row for the non-cash part (`return_service.py:639-650`). Customer payment, GRN, supplier payment: **no reversal path**. |
| Idempotency | Online: `Idempotency-Key` on `POST /customers/{id}/payments` (`BE customers.py:146-160`) and `POST /supplier-ledger/{id}/payment` (`supplier_ledger.py:77-90`); unique per `(business_id, key)`, request hash checked, 24 h retention (`BE app/core/idempotency.py:34-35, 60-90`). FE stamps the key for customer payments only (`FE lib/core/network/interceptors/retry_interceptor.dart:20-30`). Offline: client-generated ledger id + `_exists` check (`sync_push.py:958-959`). |
| Audit log | Sales and returns call `log_audit` (`sale_service.py:781`, `return_service.py:652`). Customer payments and supplier payments/ledger writes do **not** (`customer_service.py:270-355`, `supplier_ledger_service.py:105-126`). |
| Reference link | Payments use `reference_type='manual'`, `reference_id=customer_id`; `entry` rows for sales/returns link to the sale/return; GRN rows link to `purchase_receipt_line`. |

---

## E. Gaps and risks

Severity: **High** = money wrong or feature unusable, **Med** = wrong in some flows, **Low** = cosmetic or design.

| # | Sev | Finding | Where |
|---|---|---|---|
| E1 | High | Supplier payment never leaves the cash drawer or a bank account; `payment_method` is discarded; no overpay check. Shift close will not match cash actually paid out. | `BE app/services/supplier_ledger_service.py:105-126` |
| E2 | High | Expense with a `supplier_id` books the full amount+tax as payable but its own payments do not offset the supplier ledger, so a paid expense still shows as owed. | `BE app/services/expense_service.py:419-431` (payments at :384-417) |
| E3 | High | Payable can only go up in the app: GRN and Quick Add always book 100% credit, and no screen can record a payment. Cash purchases (most Pakistani wholesale) leave a permanently wrong payable. | `BE purchase_service.py:447-461`; `FE lib/features/suppliers/`; B1, B2, B7 |
| E4 | Med | Server accepts a sale whose payments are less than the total, marks it `partially_paid`, and puts the remainder nowhere (no ledger row). The POS UI blocks this, the API and sync path do not. | `BE sale_service.py:559-626`, `settlement.py:43-123`, `sync_push.py:621, 741`, `pricing_engine.py:216-226` |
| E5 | Med | Offline-synced credit sales create the ledger row with no `branch_id`, so branch-filtered balances and ledger miss them, while the unfiltered balance includes them. | `BE app/services/sync_push.py:864-877` (the payment row at :989-1000 does set it) |
| E6 | Med | Ledger "running balance" starts from 0 at the oldest loaded row. After 50 entries (page size 50, newest first) the running balance column is wrong. | `FE customer_ledger_cubit.dart:338-365` |
| E7 | Med | "Export Ledger (customer name)" passes no customer filter, so the file contains every customer's ledger for the date range. | `FE customer_ledger_header.dart:53-57`; `BE export_datasets.py:360-371` |
| E8 | Med | Dashboard receivable/payable ignore the selected branch although other cards use it (`params` has `branch_id`). | `BE analytics_service.py:297-318, 2192-2213` |
| E9 | Med | Default cashier role lacks `customers.ledger.view` and `customers.update`. The POS balance call then fails, and for a customer with a credit limit the sale is blocked with "balance could not be loaded". Cashier also cannot take a customer payment. | `BE role_permission_seed.py:174-192`; `BE customers.py:95, 132`; `FE pos_cubit_cart_mixin.dart:777-784`, `payment_allocator.dart:152-158` |
| E10 | Med | Customers and suppliers lists fire one balance request per row (N+1). Slow with hundreds of parties; no server-side total or sort by balance. | `FE customers_list_cubit.dart:59-72`, `suppliers_list_cubit.dart:63-77` |
| E11 | Med | No audit log and no reversal for customer/supplier payments, so a wrong payment cannot be traced or undone. | `BE customer_service.py:270-355`, `supplier_ledger_service.py:105-126`; A22 |
| E12 | Low | Sign comment in the DDL is inverted vs the model; supplier list shows the raw signed number under "Outstanding Balance" ("-5000.00"). | `BE schema/006_group5_sales.sql:46`; `FE suppliers_data_table.dart:99` |
| E13 | Low | Supplier purchases and supplier expenses are stored as `entry_type='sale'`, so exports and any future UI label them "sale". | `BE purchase_service.py:454`, `expense_service.py:425` |
| E14 | Med | A cash customer payment with no open shift is accepted into the ledger but not the drawer; only the UI warns. The API accepts `register_shift_id = null`. | `BE customer_service.py:280, 321-323`; `FE record_payment_dialog.dart:288-300` |
| E15 | Low | Customer payment method is only text inside `notes`; "cash vs bank collected" cannot be reported. | `BE customer_service.py:295-302` |
| E16 | Low | Over-limit offline sales are accepted and flagged only (by design), so the owner learns after the goods left. | `BE sync_push.py:695-699` |

---

## F. What to build next (priority order)

Goal: simpler than DigiKhata / EasyKhata for a small shop, but tied to real stock, POS, and cash drawer, which those apps lack.

### P0 (money must be right, and core khata)
1. **Pay the supplier.** Supplier ledger page with a "Pay" button (cash / bank / cheque), store `payment_method`, post a drawer `cash_out` when paid in cash, optional overpay warning. Closes B4, B7, B8, E1, E3.
2. **"Paid now" at receiving.** In GRN and Quick Add purchase mode add Cash / Part / All on credit; post a payment row in the same transaction. Closes B1, B2.
3. **Opening balance + manual entries for both ledgers.** "Give" and "Receive" buttons, date, note; opening balance on the customer/supplier form. Closes A7, A8, A9, B6, B14.
4. **Reverse a wrong payment** (reversal row, reason, permission) **and audit-log every ledger write.** Closes A22, E11.
5. **Fix reconciliation bugs:** E2 (expense supplier), E4 (reject under-paid sales server-side), E5 (branch on offline credit rows), E7 (customer export filter), E14 (require a shift for cash payments).
6. **One "Udhar" screen:** a single `GET` returning all customers with balance, total receivable, sorted by amount owed (removes the N+1 in E10). Same for suppliers ("Who I owe").

### P1 (what shop owners actually use daily)
7. **Customer statement** as PDF + a WhatsApp message with one tap (`wa.me` prefilled, Urdu/English), reusing the receipt renderer. Closes A15, B13. Also a "payment received" WhatsApp message.
8. **Due date / promise date** on a credit sale and on the customer, an overdue list, aging 30/60/90, and an "Overdue" dashboard card. Reminders by WhatsApp deep link, no paid SMS gateway needed. Closes A11, A14, A16, B10, B12, C3.
9. **Credit-limit override** with a manager permission (e.g. `sales.credit_limit.override`) and a log line; give cashiers a minimal "balance + limit" read and a `customers.ledger.payment` key so they can take payments. Closes A3, E9.
10. **Auto-allocate payments to oldest bills** (FIFO, no user effort), show unpaid bills per customer; manual pick optional. Closes A10, B9.
11. **Purchase returns / supplier credit notes.** Closes B5.

### P2 (nice to have)
12. Collection this month, month-end summary, top debtors view (C4-C6).
13. Supplier module offline (outbox op types for GRN and supplier payment) (B15).
14. Post-dated cheque tracking (common in Pakistan).
15. Server-computed running balance and paging for the ledger (E6); payment method as a column (E15); proper `purchase` entry type (E13).
16. Customer notes / tags / photo of the khata page.
