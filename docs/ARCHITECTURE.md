# Architecture

One Flutter project, two products: the Windows desktop app **PakPOS** (today)
and the mobile app **Pak Khata** (later). Both are built from the same code;
the differences live in a small set of replaceable adapters and one brand
object.

Phase status: **4a (this document) = foundations and refactor.** The offline
sync engine (Phase 4b) is *not* implemented. Until it exists the app is
online-first and says so honestly (see [Failure behavior](#failure-behavior)).

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
- `ClientIds.stamp(body)` adds `id` to create requests (customer, expense,
  expense/customer payments, return, shift); `SaleAttemptTracker.stamp` does it
  for a sale and each of its payment lines, stable across retries.
- `DeviceIdentity`: a stable `device_id` (secure storage, survives logout and
  tenant switch) and a device name (user-set or host name), for the sync engine.

> The backend must accept a client-supplied `id` on those POSTs (it ignores
> unknown fields today only if Pydantic is not set to `forbid`). If a create
> endpoint starts returning 422 for `id`, disable it in `ClientIds.stamp`.

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
  (cached reads), `PosRepositoryImpl` (error wording), and the future sync
  engine.

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

| Event          | Drift tables | cached reads | offline hashes | PIN roster |
| -------------- | ------------ | ------------ | -------------- | ---------- |
| logout         | wiped        | wiped        | wiped          | kept       |
| tenant switch  | wiped        | wiped        | wiped          | wiped      |
| branch switch  | kept         | wiped        | kept           | kept       |

- Tenant switch is detected at login by comparing the new tenant id with the
  last one stored on the device (`LocalDataLifecycle.onTenantSignedIn`).
- **Logout is refused** while `PendingWorkGuard.pendingCount() > 0`
  (`LogoutUseCase`; UI: `signOutWithGuard` shows a dialog). The shipped guard
  (`NoPendingWorkGuard`) returns 0; the sync engine replaces it.
- Side effect to know: parked (held) orders are local-only and are deleted on
  logout. They are not "pending sync" work, so the guard does not protect them.

## Local schema (Drift, v6)

Kept: `users_table` (signed-in profile and permissions), `master_data_cache_table`
(JSON read cache), `held_orders_table` (parked carts, scoped per
tenant/branch/cashier). Phase 4b adds the sync tables (outbox, per-entity
mirrors, cursors) next to these.

Removed in v6 (dropped by the `from < 6` migration): `sync_queue_table`,
`pending_sales_table`, `sales_table`, `products_table`, `customers_table`.
They only ever held mutations the server never saw and optimistic stock
numbers. The generated `app_database.g.dart` was trimmed by hand because
`build_runner` could not run; regenerate it when the toolchain allows and
expect an identical result.

## Failure behavior

There is no longer any code path that reports a mutation as done when it was
not:

- The `OfflineInterceptor` (fake `202 Queued`) is gone.
- `PosRepositoryImpl.createSale` returns `Left(NetworkFailure)` when the server
  cannot be reached ("The sale was NOT saved ..."), never a draft
  `OFFLINE-<n>` sale, and no longer decrements local stock.
- A failed sale keeps its id (`SaleAttemptTracker`), so tapping "Complete
  Sale" again is idempotent.

Consequence until Phase 4b: **a sale cannot be completed without the server.**
The UI says so (offline banner, sync chip, error text).

## UI primitives

- `SyncStatusSource` (`core/sync/sync_status.dart`) feeds `SyncStatusChip`
  (Online / Offline / Syncing / N pending / N failed), shown in the app shell
  top bar, kitchen shell and POS header. `ProbeBackedSyncStatusSource` is
  truthful about connectivity; pending/failed are stubbed to 0.
- `OfflineBanner` (app shell) is driven by `ConnectivityProbe`.
- `FailedItemsPage` (`/sync/failed`, open to any signed-in user) is a
  skeleton; the chip links to it when `failed > 0`.

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
