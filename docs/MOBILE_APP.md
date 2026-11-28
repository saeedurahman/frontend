# PAK KHATA MOBILE APP: MASTER RULES AND LIVE STATUS

TARGET: FLUTTER (frantend repo, same project as the PakPOS Windows desktop app). The backend repo is READ-ONLY for you.

How this file works: PART A is binding and written by the product owner and architect. You must NEVER edit it. PART B is the live status that YOU update after every task (progress, decisions, blockers, change log). Read both completely before doing anything, and again at the start of every phase.

====================================================================
PART A: RULES (do not edit)
====================================================================

A1. PRODUCT
- "Pak Khata" is the Android-first mobile app of PakPOS for Pakistani shop owners (pharmacy, mart/grocery, restaurant, general retail). Same account, same data, same subscription, same backend as the desktop app. Users are owners (often not tech-savvy), managers and cashiers on cheap or mid-range Android phones, using one hand in a busy shop, often with poor internet.
- Offline-first exactly like desktop: same local database, outbox, sync, store-event refresh contract, lease/subscription rules, permissions. Online-only operations show the friendly "needs internet" notice and keep drafts.
- Scope: eventually every feature of the desktop app, with mobile-native UX. This is NOT a shrunken desktop UI.
- Brand: --dart-define=APP_BRAND=pakkhata gives the app name "Pak Khata". No hard-coded product names anywhere.
- Language: English now; Urdu/RTL later. Every user-visible string goes through the localization layer from day one; use start/end (never left/right) alignment; money uses the shared formatter (western digits, business currency label).
- Navigation target: bottom bar Home | Khata | Dashboard | Sales | More. Home has a 3-tab segmented control under the top bar: Sale (default, the POS) | Purchase (suppliers and what we owe) | Customers (customers and what they owe), and a Grid/List toggle for products at the top right of the Sale tab. Items shown per role and permission (a Cashier sees far fewer: permission-first, never role-name shortcuts).

A2. QUALITY BAR (hard, non-negotiable)
Goal: a shopkeeper judges the whole product in 5 seconds. The app must look and feel hand-crafted by a senior mobile product designer and developer, never AI-generated, never template-like. When in doubt: simpler, calmer, more spacious, more consistent.
1. One design system. Every colour, text style, spacing, radius, elevation and motion duration is a token in one place (lib/core/design). No literal colours or sizes inside screens.
2. Layout: 4-pt grid (4/8/12/16/24/32), 16 px screen side padding, 12 between cards, 24 between sections, touch targets >= 48x48, the primary action sticky in the thumb zone, safe areas respected, keyboard never hides the active field or the primary button.
3. Typography: one bundled family, at most 2 weights per screen, money and numbers in tabular figures and right-aligned in lists, hero numbers large, text >= 12 sp, AA contrast, works at text scale 1.3 without overflow.
4. Icons: a CUSTOM icon set for every primary icon (navigation, POS, khata, payment sources, statuses, empty states): one consistent SVG line style (same stroke weight, corner treatment, optical size), stored in assets/icons and used only through one AppIcon widget. Create them with your image/SVG capability. Do not mix in default Material icons; even trivial glyphs (back, close, chevron, search) must be restyled to match the set. Deliver an icon sheet for approval in M0.
5. Look: calm, confident, premium. FORBIDDEN: default Material look (default AppBar, Card shadows, switches, dropdowns, ripple colours), default blue/purple, neon or multi-colour gradients, glassmorphism, emoji as icons, stock illustrations of people, lorem ipsum, more than 5 colours on a screen, the same-rounded-card-with-same-shadow repeated everywhere, centre-everything layouts, decorative shapes, small grey-on-grey text, inconsistent paddings.
6. Motion (200-300 ms, ease-out): staggered list entry, count-up on hero numbers (once), press scale 0.97, spring bottom sheets, shared-element transitions where they help, smooth tab indicators, skeleton loaders, pull to refresh, swipe actions with haptic feedback. No looping decorative animation. Respect the OS reduce-motion setting.
7. States: every screen has loading (skeleton), empty (custom SVG illustration in the icon style, ONE sentence, ONE action), error (friendly, with retry), offline ("saved on this phone, will sync"), "Not synced yet" badges, permission denied, subscription lock.
8. Performance budgets (measure in profile mode on a low-end Android 8-10 device or an equivalent emulator profile): cold start to usable <= 2.5 s from the local database without waiting for the network; 60 fps scrolling with 5,000 products and 10,000 ledger rows (virtualised lists, cached images, const widgets); add-to-cart and calculator < 100 ms; no jank in sheet animations; stable memory; APK size reported every phase (target <= 40 MB). Profile BEFORE every phase report.
9. Business logic never lives in widgets and is never re-implemented for mobile (pricing, tax, rounding, FIFO-related display, khata allocation, receipts, statements: use the shared engines and server data).
10. Accessibility: semantic labels, colour never the only signal, tooltips or long-press hints where an icon stands alone.
11. Every screen must work from 360x640 to 412x915 with no overflow at any text scale up to 1.3.

A3. IMAGE-FIRST AND VISUAL QA (mandatory every phase)
- Design source: Saeed puts chosen design references (images/exports, or through MCP) in docs/mobile/design/<phase-or-screen>/. If a reference exists for a screen, follow it faithfully (adapt to Flutter, never redesign it). If not, you design it yourself under A2.
- BEFORE writing any UI code for a phase: use your image-generation capability to create high-fidelity mockups (390x844) of EVERY screen of the phase, plus key states (loading, empty, error, offline) and a 360x640 variant for the 3 most complex screens, consistent with the design system and any references. Save them to docs/mobile/mockups/<phase>/. Then STOP and wait for Saeed's approval or change requests. Revise until approved. Record the approval in Part B. No UI code before approval.
- AFTER coding: capture screenshots (golden tests or device/emulator captures) of every screen at 360x640, 390x844, 412x915 and at text scale 1.3 into docs/mobile/screenshots/<phase>/. Compare against the approved mockups and fix visible differences (spacing, hierarchy, alignment, colour, icon style, typography) BEFORE reporting. List any remaining deviation honestly.
- SCREEN CHECKLIST (report the result for every screen): hierarchy clear (one hero, one primary action), spacing on grid, alignment, custom icons only, tabular money, all states built, motion applied, 360-wide ok, text scale 1.3 ok, offline state ok, performance ok.
- A phase is NOT done while any screen has placeholder styling, default Material widgets or inconsistent spacing.

A4. ARCHITECTURE RULES
1. Same Flutter project and same data layer. Shared code: models, repositories, local DB, outbox/sync, cubits and use cases, permissions, subscription/lease, pricing/tax engine, receipt/statement builders, formatters. If a cubit or use case is desktop-shaped, refactor it into shared code WITH tests and identical desktop behaviour.
2. Mobile UI lives separately (for example lib/mobile/... or presentation/mobile per feature) with its own entry point (main_mobile.dart) and a shared bootstrap. The desktop entry point and desktop screens stay untouched. Use adaptive helpers only where a screen is truly shared.
3. Platform adapters, never plugin calls in features: BarcodeScannerService (camera, e.g. mobile_scanner), PrinterService (Bluetooth ESC/POS), file save/share (share_plus: share PDFs straight to WhatsApp and other apps), secure key store, haptics, connectivity probe.
4. Backend is read-only for you. If something is missing or wrong in the backend, follow the blocker protocol (A7) with a ready backend prompt. Never work around it silently.
5. Android: minSdk 24 (report if a dependency needs more), targetSdk as required by Play, package id per brand, no secrets in the repo. Android SDK and caches are on D: (ANDROID_HOME, GRADLE_USER_HOME, PUB_CACHE, ANDROID_USER_HOME already set). Emulator images and builds must not fill C:.
6. Never hand-edit generated files: use scripts/codegen.ps1 and scripts/check_generated.ps1.
7. Desktop must not regress: the full desktop test suite stays green at the end of every phase.

A5. PHASE PLAN (strict order, one phase at a time)
M0 Foundations and design system: verify an Android debug build on a physical device; main_mobile entry and brand flavor; package id; temporary icon/splash; design tokens; bundled fonts; component library (buttons, cards, chips, inputs, list tiles, bottom sheets, dialogs, snackbars with undo, skeletons, empty states, status chips, calculator keypad, quantity stepper, aging bar, sync pill, offline banner, segmented tabs, search field); custom SVG icon set + icon sheet; component gallery debug screen with golden tests; localization scaffolding; haptics and motion helpers. Mockups to approve: style tile, component sheet, icon sheet, Home shell.
M1 App shell and access: splash, 3-card onboarding, login (phone and password, PIN, offline login), session and idle lock, permission-driven bottom navigation, top bar (shop and branch chip, sync pill, bell), offline and subscription banners, expired-subscription screen, permission-denied screen, More menu, branch selector, error mapper, basic sync center.
M2 Home / POS: Sale, Purchase, Customers tabs; product grid and list with toggle; search; category chips; camera barcode scan; quantity calculator sheet; cart sheet; customer selection; payment sheet (split payments, credit-limit warning and owner override, change due); complete sale; receipt preview and share; hold and resume; returns entry; everything offline.
M3 Khata: hub (To receive / To pay, tabs, aging chips, search, sort), customer and supplier detail with ledger, receive and pay flows (payment sources), reversal, opening balance, manual entries, promises, WhatsApp reminders, statements (PDF via share sheet, text, link), payment details, offline.
M4 Dashboard and Sales: dashboard (summary cards, trend chart, top products, alerts, branch and date range), sales list and detail, returns, re-share receipts, export share.
M5 Catalog, stock, purchases: products list/detail/edit (camera/gallery images), Quick Add by Scan (camera, continuous), basic import, inventory with low-stock and expiry, stock adjust, price lists, purchases/GRN with paid-now, supplier management.
M6 More: expenses, cash register and shifts, reports hub (PDF share), staff and roles/permissions, settings (business profile, tax and prices, receipt layouts with live preview, payment details, Khata messages, language), subscription page, sync center (pending, failed, flags), help/about.
M7 Printing: Bluetooth thermal printer (ESC/POS, 58/80 mm), pairing, reconnect, receipt layouts including Urdu image rendering, cash drawer pulse, test print, fallback to PDF share. Needs a physical printer: if none is available build against a simulator, mark "needs hardware test" in Part B, and continue.
M8 Polish and hardening: profiling on a low-end device, animation pass, accessibility, small screens, dark theme, RTL/Urdu readiness preview, crash and log handling, secure storage, permission UX, battery and data use, app size, empty/error audit, final visual QA of ALL screens.
M9 Release: final icon and splash, versioning, R8/ProGuard, Android signing setup (instructions for creating the keystore; the keystore and passwords are never committed; Saeed keeps backups), APK for pilot clients, AAB, Play Store checklist and listing drafts, privacy policy placeholder, in-app update-check design.

A6. PHASE PROTOCOL (the loop)
1. Read Part A and Part B and the design references.
2. Write the phase plan in Part B (tasks, screens, risks).
3. Create mockups, STOP, wait for approval (A3).
4. Build task by task. After each task: run related tests, flutter analyze (0 errors), update Part B.
5. Visual QA, performance profile, full desktop suite once. 
6. Write the phase report (A8) and STOP. Do NOT start the next phase or next task until Saeed replies. If Saeed asks for changes, do only those, re-run QA, report again.
Ask questions in chat ONLY at the STOP points (mockups approved? report). Everything else: decide the safest option, record it under Decisions in Part B, and continue.

A7. BLOCKER PROTOCOL
When you cannot proceed correctly: do not hack, do not band-aid, do not skip a requirement, do not change the backend. Add an entry to Part B > Blockers (ID, phase, task, what is blocked, evidence, options considered, your recommendation, what you need from Saeed). Continue only with tasks that are independent of the blocker; if none, STOP and report. If the fix needs backend work, also write a ready-to-run backend prompt to docs/mobile/blockers/<ID>-backend.md (first line "TARGET: BACKEND (FastAPI repo)", tests limited to new/related ones, no migrations on the dev database, disk check before tests). Saeed will bring blockers to the architect and return decisions; record each decision in Part B.

A8. PHASE REPORT FORMAT (short, plain English)
1. Phase and status. 2. What was built (bullets, by screen). 3. HOW TO TEST: numbered steps for a non-technical tester with the expected result of each step. 4. Evidence: screenshot paths, screen checklist results, performance numbers (cold start, scroll, APK size), tests run and NOT run. 5. Decisions made and deviations from the approved mockups. 6. Blockers (IDs). 7. NEXT TASK: one line plus what will visibly change. Then STOP.

A9. SAFETY AND HONESTY RULES
- Never commit or push; Saeed does that.
- Never run alembic or any migration against the dev database. Live tests only against the pakpos_test database through the backend's own scripts. Never touch the backend server on port 8000.
- Before any test run check C: free space with the backend's scripts/disk_check.py (needs > 3 GB), run tests from one place only, and clean the test database afterwards (scripts/cleanup_test_db.py --apply). Never delete files outside this project: report disk problems instead.
- No secrets, keystores or passwords in the repo or in logs.
- Root causes only: no delays, no timers, no "refresh later" hacks.
- Never claim something works that you did not run; state exactly what was not tested.

====================================================================
PART B: LIVE STATUS (you maintain this; keep it short and current)
====================================================================

B1. Phase status
| Phase | Status | Mockups approved | Report delivered | Saeed tested/approved |
| M0 | not started | | | |
(M1 to M9 the same)

B2. Current task
(phase, task, next step)

B3. Decisions (date, phase, decision, reason)

B4. Blockers
| ID | Phase | Task | What | Needs | Status | Decision |

B5. Design references received (path, date, which screens)

B6. Performance log (date, phase, device, cold start, scroll fps, APK size)

B7. Change log (date, phase, task, files or areas touched)