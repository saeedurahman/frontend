# Architecture

One Flutter project, two products: the Windows desktop app **PakPOS** (today)
and the mobile app **Pak Khata** (later). Both are built from the same code;
the differences live in a small set of replaceable adapters and one brand
object.

Phase status: **4a** (foundations and refactor) and **4b** (offline-first data
layer, sync engine, offline POS flows) are both in. The local database is the
source of truth for POS work; the network only moves data in the background.
See [Offline-first data layer](#offline-first-data-layer-phase-4b).

## Layers

```
presentation  widgets, pages, cubits      -> call use cases only
domain        use cases, policies, ports  -> pure Dart, no plugins, no Drift/Dio
data          repositories, data sources  -> Dio, Drift, secure storage
core          platform adapters, DI, identity, reachability, lifecycle
```

Rules:

- A **cubit** holds UI state and calls use cases. It does not read Drift,
  evaluate permissions, build ids, or contain pricing/validation rules.
- A **use case / policy** in `features/<x>/domain` owns a business rule and is
  unit-tested without Flutter widgets (`test/pos/pos_local_usecases_test.dart`).
- A **repository interface** (domain) hides the store. `HeldOrdersRepository`
  and `BarcodeCacheRepository` are the Drift-backed examples; the Drift
  implementations live in `features/pos/data/repositories`.
- A **widget** never calls a plugin. It uses an adapter from `core/platform`.

### POS example (what moved out of the cubit)

| Concern                                   | Now lives in                                   |
| ----------------------------------------- | ---------------------------------------------- |
| Who may sell / open shift / edit tax      | `ResolvePosSessionUseCase`                     |
| "Can this shift be opened?", request body | `ShiftPolicy`                                  |
| Held orders: park, list, resume, discard  | `HeldOrdersUseCases` + `HeldOrdersRepository`  |
| Re-pricing a parked cart on resume        | `HeldOrdersUseCases.refreshItems`              |
| Barcode: memory -> cache -> server        | `ResolveBarcodeUseCase` + `BarcodeCacheRepository` |
| Same cart + payments => same sale id      | `SaleAttemptTracker`                           |
| Payments must equal the total             | `PaymentCoverage`                              |
| Payment dialog: credit, due, prefill      | `PaymentPlanner`                               |
| Low-stock warning                         | `LowStockPolicy`                               |
| Totals, discounts, tax                    | `pos_calculations.dart`, `payment_allocator.dart` |

`PosCubit` and its mixins (`features/pos/presentation/cubit`) keep only state
transitions and orchestration (which use case, then which `emit`). The
add-to-cart flow still sequences several lookups inside the cubit because it
interleaves them with state updates; its decisions (stock warning, price
validity) are delegated.

## Platform adapters (`lib/core/platform`)

| Interface               | Windows implementation                 | Mobile (later)             |
| ----------------------- | -------------------------------------- | -------------------------- |
| `PrinterService`        | `WindowsPrinterService` (`printing`)   | Bluetooth / ESC-POS        |
| `BarcodeScannerService` | `KeyboardWedgeBarcodeScanner`          | camera (`mobile_scanner`)  |
| `FileSaverService`      | `WindowsFileSaverService`              | share sheet / app storage  |
| `AppWindowService`      | `WindowsAppWindowService` (channel)    | `NoopAppWindowService`     |
| `SecureKeyStore`        | `FlutterSecureKeyStore` (DPAPI)        | Keystore / Keychain        |
| `ConnectivityProbe`     | `HttpConnectivityProbe` (`core/connectivity`) | same                |

All are registered in one place, `core/di/foundation_module.dart`. To add the
mobile app, swap the registrations there; no feature code changes.

Not yet behind an adapter (documented gaps): `image_picker` (product/business
photos) and `url_launcher` (support contact links).

`AppWindowService.setTitle` talks to an `app/window` method channel. The
Windows runner does not implement it yet, so the window title comes from the
runner (`windows/runner/main.cpp`, now "PakPOS"); the service ignores a
missing channel. Dynamic titles need a small native handler.

## Brand (`lib/core/brand/app_brand.dart`)

`AppBrand` is the only place a product name may appear: `appName`,
`shortName`, `supportLabel`, `packageName`/`executableName` placeholders and
the receipt "Powered by" line. Default is `PakPOS`; build the other product
with `--dart-define=APP_BRAND=pakkhata`. A test fails if "Frantend" reappears
in `lib/`.

The Dart package is still named `frantend` (renaming touches every import);
the Windows executable is now `pakpos.exe` (`windows/CMakeLists.txt`). The
SQLite file is still `frantend_pos.db` on purpose, to keep existing installs'
local data. Android/iOS/macOS/Linux/web folders were not rebranded (no
desktop-only requirement; do it with the mobile app).

## Identity

- `IdGenerator` (`UuidIdGenerator`): UUIDv4 for sale, payment, customer,
  expense, shift, return, held order and operation ids.
- Client ids are sent **only** where the sync contract accepts them: the `id`
  of `customer.create`, `shift.open`, `sale.create` (+ each sale line) and the
  optional ledger `id` of `customer.payment`. Ordinary online endpoints
  (`POST /customers`, `/expenses`, ...) never receive a client id (the Phase 4a
  `ClientIds` stamping was removed).
- `DeviceIdentity`: a stable `device_id` (secure storage, survives logout and
  tenant switch) and a device name. Sent as `X-Device-ID` (and `device_id`)
  on every request; devices register server-side on their first pull/push.

## Reachability (`core/connectivity`)

`ConnectivityProbe` answers "can I reach the backend?" - not "is there a
network adapter?".

- Probe: `GET /time`, 3 s timeout, bare Dio (no auth/retry/interceptors).
- `connectivity_plus` is only a *hint*: an adapter change schedules a
  (debounced) re-probe sooner; it never decides the verdict.
- Verdict stream `online | offline | degraded`, emitted only on change.
  Slow (>= 1.5 s) or 5xx answers are `degraded` (calls are still attempted).
- Debounce: 2 consecutive failures before `offline`.
- Backoff while offline: 2, 4, 8 ... capped at 60 s; steady 30 s while online.
- Consumers: `SyncStatusSource`, `OfflineBanner`, auth/product repositories
  (cached reads) and the sync engine (skips automatic cycles while offline,
  syncs the moment the probe turns online).

HTTP timeouts (`TimeoutInterceptor`): 5 s connect/send/receive for everything,
including POS-critical calls; 60 s only for `/analytics`, `/reports`,
`/export`, `/upload`, `/dashboard`. POS-critical paths (`/sales`, `/shifts`,
`/registers`, `/returns`, `/expenses`, `/customers`, `/stock`, `/time`, ...)
are **never auto-retried**, so a dead link fails in ~5 s instead of freezing
for four attempts. Other GET/PUT/DELETE get one retry. Money POSTs still carry
an `Idempotency-Key`, so a manual retry cannot double-post.

## Offline sign-in (`features/auth/domain/offline`)

- On every successful **online** login, `OfflineCredentialVerifier.enroll`
  stores a random 16-byte salt and a PBKDF2-HMAC-SHA256 hash
  (100 000 iterations, computed in a short-lived isolate) in `SecureKeyStore`.
  Passwords and PINs have separate records. Nothing reversible is stored.
- If the login request cannot reach the server (`NetworkFailure`), the
  repository verifies against that hash. A server *answer* (401, 429, ...)
  never falls back. Offline sign-in also requires the session tokens to still
  be on the device.
- 5 wrong attempts lock the record (persisted); only an online login
  re-enrolls and unlocks it.
- The idle-lock PIN screen goes through the same path: online it calls the PIN
  endpoint; offline it verifies the PIN hash stored at the last online PIN
  login.
- The hash is wiped on logout, tenant switch and password change.

## Local data lifecycle (`core/lifecycle`)

| Event          | Drift + sync tables | cached reads | offline hashes | PIN roster |
| -------------- | ------------------- | ------------ | -------------- | ---------- |
| logout         | wiped               | wiped        | wiped          | kept       |
| tenant switch  | wiped               | wiped        | wiped          | wiped      |
| branch switch  | kept                | wiped        | kept           | kept       |
| device revoked | wiped               | wiped        | wiped          | kept       |

- **Logout is refused** while `PendingWorkGuard` reports work (`LogoutUseCase`;
  UI: `signOutWithGuard`). The real guard (`OutboxPendingWorkGuard`) counts
  outbox ops that are pending, sending, failed or rejected, plus parked
  (held) orders, which exist only on the device. The dialog lists the counts;
  the **owner** can still sign out after a second confirmation
  (`LogoutUseCase(force: true)`).
- **Tenant switch** is detected at login (`onTenantSignedIn`). If the previous
  business still has unsent work the login is refused with the same counts
  (`PendingWorkException` -> `PendingWorkFailure`); nothing is wiped.
- `403 device_revoked` -> `SessionServices.forceSignOut`: wipe, end the
  session, tell the user why (no guard: the server will not accept anything
  from this device any more).
- The per-device receipt counter and device id survive every wipe.

## Local schema (Drift v7)

Drift table classes (generated code, unchanged): `users_table`,
`master_data_cache_table`, `held_orders_table`.

Hand-written SQL (`core/sync/sync_schema.dart`, created through
`customStatement` in `onCreate` / `onUpgrade(from < 7)`, **no codegen**):

| table              | purpose |
| ------------------ | ------- |
| `entities`         | generic mirror of every pulled entity: `entity, id, business_id, branch_id, parent_id, data (JSON), search_text, barcode, category_id, active, is_deleted, seq`; indexes for name search, barcode, category, parent |
| `stock_levels`     | server balances per product/variation/branch (pending local sales are subtracted at read time) |
| `deferred_changes` | pulled rows held back because a local op for the same entity is unfinished |
| `outbox`           | `op_id` PK, `type, payload, status, attempts, next_attempt_at, error_code, error_message, retryable, created_at, occurred_at, depends_on, entity, entity_id` |
| `local_sales`      | client sale id, `op_id`, device `receipt_no` (e.g. `DA1B2-0001`), `official_number`, status, `sync_state` (pending/synced/failed/discarded), totals, `flags`, lines + payments as JSON, `server_synced_at` |
| `local_shifts`     | client shift id, register, user, status, float, actual cash, `sync_state`, open/close op ids |
| `sync_meta`        | key/value: `cursor`, `last_pull_at`, `last_push_at`, `permissions_fingerprint`, `lease`, `monotonic_last_seen`, `receipt_counter`, `snapshot_*`, settings cache, discard log |

History: v6 dropped the Phase-3 fake-offline tables; v7 adds the tables above
(additive; `held_orders`, `users`, `master_data_cache` untouched).
`wipeTenantData()` clears all of them except the receipt counter.

## Failure behavior

Nothing pretends. A sale is saved on the device in one transaction together
with its outbox op, so it **cannot fail because of the network**; what the UI
may say about it is exactly what is true:

- the receipt shows the **device receipt number**; the official number appears
  only after the server confirmed (`sync_state = synced`), and reprints show
  both;
- a sale is never marked "synced" before the server answered `applied` or
  `duplicate`;
- rejected items stay visible (chip "N failed", Sync page, Failed items page)
  until retried or discarded by the owner/manager.

See [Failure handling](#failure-handling) for every server answer.

## UI primitives

- `SyncStatusChip` (Online / Offline / Syncing / N pending / N failed) in the
  app shell, kitchen shell and POS header is driven by
  `EngineSyncStatusSource` (probe + live outbox counters). Tap: Sync page, or
  the failed-items page when something failed.
- `OfflineBanner` (probe), `LeaseBanner` (grace / clock), "Preparing your data"
  (`DataPreparationGate`, first snapshot or resync).
- Pages: `/sync` (`SyncPage`: waiting list, last synced, **Sync now**),
  `/sync/failed` (`FailedItemsPage`: plain-language reason, **Retry**,
  **Discard** for owner/manager with confirmation and a log entry),
  `/sync/flags` (`FlagsPage`: `GET /sync/flags`, owner/manager).
- A snackbar announces "Sync finished: N sale(s) flagged for review".
- Settings > Offline: allow selling below stock, show sync details, **Resync
  all data** (refused while anything is unsent).

## Responsive foundation (`utils/responsive/adaptive_layout.dart`)

`Breakpoints` (compact < 600, medium < 1024, expanded >= 1024) and
`AdaptiveLayout`. `AppShell` uses a permanent sidebar when wide; below 1024 it
switches to a drawer plus a compact top bar, and below 600 adds a bottom
navigation bar (Dashboard / POS / Sales, filtered by permission, + More).
Individual screens were not redesigned.

## Data flow

```
Widget --> Cubit --> UseCase --> Repository (interface)
                                     |
                      +--------------+---------------+
                      v                              v
             Remote data source (Dio)        Local store (Drift / SecureKeyStore)
                      |
        interceptors: timeouts -> auth -> subscription -> forbidden -> retry -> log
```

Reachability and sync status flow sideways: `ConnectivityProbe` ->
`SyncStatusSource` -> chip/banner; the sync engine (4b) will consume the same
probe.

## Offline-first data layer (Phase 4b)

Contract: backend README, "Offline sync" (`/sync/pull`, `/sync/snapshot`,
`/sync/push`, `/sync/flags`, lease). Code: `lib/core/sync`, `lib/core/offline`.

```
 UI -> cubit -> use case -> repository ---read---> LocalCatalog (entities, stock_levels)
                                       \--write--> OfflineWriter
                                                     |  ONE transaction
                                                     v
                                    local record (local_sales / local_shifts / entities)
                                    + outbox row (op_id, type, payload, depends_on)
                                                     |  store.enqueued
                                                     v
                           SyncEngine  (single flight)  push -> pull -> extras
                               |                |
                          PushService      PullService  -> AccessCubit (permissions)
                               |                |
                           HttpSyncApi  <---- server (authoritative: FIFO, costing,
                                               ledgers, official numbers)
```

### Single write path

`OfflineWriter` is the only way POS data changes: `saveSale`, `createCustomer`,
`recordCustomerPayment`, `createExpense`, `openShift`, `closeShift`,
`createReturn`, `voidSale`. Each writes the local record and the outbox op in
one `SyncStore.transaction`; a crash can leave neither half. There is no online
branch: `POST /sales` and friends are no longer called from the app.
Management screens (customers, expenses, returns, cash register, sales) keep
their remote reads; the writes the counter needs use the same writer
(`offline_decorators.dart`), registered over the generated repositories in
`foundation_module.dart`.

### Op lifecycle

```
              enqueue
                 v
   +-------> pending --(in a batch)--> sending --+-- applied | duplicate --> applied (done)
   |            ^  ^                              |
   |            |  +-- 5xx / offline / 429 / 413 -+   (released, attempt not counted)
   |            |                                 +-- retryable error --> pending (+backoff)
   |            |                                 |      5s 15s 60s 5m 15m, then failed
   |   Retry    |                                 +-- rejected / conflict --> rejected (final)
   +-- failed / rejected <------------------------+
        (a rejected op is re-sent under a NEW op_id: the server remembers final answers)
```

- `depends_on` (customer -> sale -> payment, shift.open -> sales -> shift.close)
  is honoured: an op is sent only after its dependencies are applied or earlier
  in the same batch; one whose dependency needs attention is parked as
  `failed / dependency_failed` and released when the dependency is retried.
- Batch size `SYNC_MAX_OPS` (default 200, `--dart-define=SYNC_MAX_OPS`), halved on 413.
- On start, `sending` ops are reset to `pending` (the response may have been
  lost; the server answers `duplicate`).

### Pull

First install / `full_resync_required` / `invalid_cursor` / "Resync all data":
paged `GET /sync/snapshot` (progress UI); the cursor from the snapshot is
adopted only after the last page, and an interrupted snapshot resumes from the
stored page token. Then `GET /sync/pull` while `has_more`. Each page and the
cursor are written in **one transaction** (a crash re-delivers the page;
upserts are idempotent). Rows with an unfinished local op for the same entity
go to `deferred_changes` and are applied once that op is done. The user's
permissions/branches are derived from the pulled `user` + `role` rows and
applied to `AccessCubit` live. The cursor never depends on the device clock.

### Scheduler

Triggers: app start, resume, probe offline -> online, immediately after any
enqueue (150 ms debounce), a timer (30 s while work is waiting, 5 min
otherwise), manual **Sync now**. Single flight (overlaps coalesce into one
re-run). Server unreachable: exponential backoff 5 s -> 5 min; 429 honours
`Retry-After`. Automatic cycles skip a probe that says "offline"; manual sync
does not. After a successful sync the engine refreshes best-effort extras:
`/settings` (cached; default tax etc.), `/shifts/my-active` (a shift opened
elsewhere becomes the local shift) and `/subscription/status` (fresh lease).

### POS from local data

Products: `LocalCatalog.products` uses indexed `search_text` / `barcode` /
`category_id` columns (10 001 products: name/sku/barcode search ~20 ms, exact
barcode and category page a few ms). Prices from the default price list (tiers
by `min_qty`, variation prices win), tax from pulled `tax_rate`, totals with
the shared `PricingEngine`. Stock shown = pulled `stock_levels` minus
quantities of this device's unsynced sales. Selling below stock is a warning
(owner switch in Settings, else the business `allow_negative_stock`, else
allowed). Customer balance uses the app's convention (negative = owes):
server balance - unsynced credit sales + unsynced payments; the credit limit
check (`PaymentAllocator`) runs on that figure. Held orders stay local only.

### Lease and subscription offline

`LeaseService` stores the signed lease (from `/subscription/status`), verifies
the Ed25519 signature locally against `--dart-define=LEASE_PUBLIC_KEY`
(unpadded base64url, 32 bytes) over the canonical JSON of the four fields,
checks the business, and guards the clock: refused if the device time is more
than 5 minutes before the lease's `server_time` **or** before a time already
seen (`monotonic_last_seen`); a fresh online lease resets that reference.
Until `valid_until` the POS works; after it a warning banner for `GRACE_DAYS`
(default 3, `--dart-define=GRACE_DAYS`); then `AuthGuard.setLeaseBlocked` routes
to `/subscription-expired`. No key configured = not enforced. Online 402
handling is unchanged.

### Failure handling

| server answer | what the app does |
| ------------- | ----------------- |
| `applied` / `duplicate` | op `applied`; sale gets official number + flags + `synced` |
| `rejected` / `conflict`, not retryable | op `rejected` (final), plain-language reason; sale `failed`; user: Retry (new op id) or Discard (owner/manager, confirmed, logged) |
| retryable error | back to `pending`, backoff 5s,15s,60s,5m,15m; after `SYNC_MAX_ATTEMPTS` (10) -> `failed` |
| `subscription_*` retryable | stays `pending`, retried every 15 min without using up attempts |
| `dependency_failed` | the dependant is parked `failed` until its parent is retried |
| 403 `device_revoked` | ops stay safe, then wipe + forced logout + message |
| 413 `batch_too_large` | halve the batch; a single oversized op -> `rejected payload_too_large` |
| 429 | wait `Retry-After`, everything stays pending |
| 5xx / timeout / offline | everything stays pending; backoff; status "Offline" / last error |
| 400 `invalid_cursor`, `full_resync_required` | new snapshot (once per cycle) |
| `restricted: true` (expired subscription) | only `settings` arrive; the cursor does not move |

### Hand-edited generated code (cumulative)

`app_database.g.dart` (Phase 4a trim; Phase 4b needs no change: the new tables
are hand-written SQL), `injection.config.dart` (4a edits + removal of
`PosRepositoryImpl`), localization `appTitle`. Phase 4b registrations live in
`foundation_module.dart`, which also *replaces* generated registrations
(`PosRepository`, `CustomersRepository`, `CashRegisterRepository`,
`ExpensesRepository`, `ReturnsRepository`, `SalesRepository`, `PosCubit`), so a
future `build_runner` run keeps working.
