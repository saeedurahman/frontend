Before writing any code, stop at the FIRST rung below that holds. Do not skip ahead, do not go further than you need to.

## The ladder (Flutter/Dart specific)

1. **Does this need to exist?** → No: skip it (YAGNI). Don't add a feature, parameter, or abstraction the task didn't ask for.
2. **Does Dart's stdlib already do it?** → Use it. (`dart:core`, `dart:async`, `dart:convert`, `dart:math` before reaching for a package — e.g. don't pull in a package for basic string/number formatting, JSON encode/decode, or simple collection ops.)
3. **Does Flutter SDK already give this natively?** → Use it. Check Material/Cupertino widgets, `Form` + `TextFormField` validators, `showDatePicker`/`showTimePicker`, `Hero`, `AnimatedContainer`/implicit animations, `ValueListenableBuilder`, `Theme.of(context)`, before writing custom widgets or custom animation controllers.
4. **Is it already in `pubspec.yaml`?** → Use it, don't add a new package for an overlapping job. Before reaching for a new dependency, check what this project already has for: state management, HTTP/networking, local storage/caching, and navigation/routing. Whatever is already wired in for each of these jobs is the answer — not a second package doing the same thing.
5. **Is it a one-line widget/call?** → Write the one line. Don't wrap a single `Text()` or `Icon()` in a custom component "for reusability" unless it's actually reused.
6. **Only then:** write the minimum custom widget/logic that satisfies the task.

## Never cut corners on (regardless of which rung you land on)

- **Input validation** at form/API boundaries — validate user-submitted data (search queries, form fields, payment amounts, etc.) before it hits a network call.
- **Error handling** for network calls — every HTTP call must handle timeouts, no-connection, and non-2xx responses; never let a failed API call silently crash or hang the UI.
- **Null-safety correctness** — no `!` bang operators to silence the analyzer without an actual guarantee.
- **Accessibility** — `Semantics` labels on icon-only buttons, sufficient tap target sizes, readable contrast against the app's actual theme colors.
- **RTL/locale correctness** if the project supports RTL languages (e.g. Arabic, Urdu) — don't hardcode `Alignment.left`/`right` or `EdgeInsets` with manual left/right; use the directional equivalents (`AlignmentDirectional`, `EdgeInsetsDirectional`) so RTL layouts aren't broken by a "shortcut."
- **Local-storage schema/migration steps** — if the project's storage layer needs a schema bump, type adapter, or migration step, never skip it to save time; a shortcut here corrupts cached data on the next app update.

## Mark every shortcut

When you take a shortcut up the ladder (rungs 2–5), leave a comment naming what was skipped and what the upgrade path is:

```dart
// ponytail: using the storage layer directly here instead of a repository wrapper — promote if this read pattern appears in >1 place
```

```dart
// ponytail: native date picker instead of a custom calendar widget — revisit if design needs something the native picker can't do
```

## Flutter-specific anti-patterns to flag, not silently write

- Don't add a second state-management package (e.g. introducing Riverpod or Bloc alongside whatever this project already standardized on) "just for this screen" — find out what's already in use and follow it.
- Don't add a second HTTP client package alongside the one already wired in for networking — route everything through the existing client/interceptor setup instead of one-off calls with a different library.
- Don't write a custom JSON serializer when `dart:convert` + a manually written `fromJson`/`toJson` (or whatever existing pattern is already in the codebase) already does the job — don't reach for code-gen serialization unless the model is genuinely complex or the project already uses that approach elsewhere.
- Don't introduce a new local-storage mechanism when the project already has one covering local persistence — check what's already there before adding another storage package on top of an existing solution.

## Commands (if using a skill-capable host: Claude Code, Codex, OpenCode, Gemini)

| Command | What it does |
|---|---|
| `/ponytail [lite\|full\|ultra\|off]` | Set intensity, or turn off. No argument reports current level. |
| `/ponytail-review` | Review current diff for over-engineering, hand back a delete-list. |
| `/ponytail-audit` | Audit the whole Flutter app for over-engineering, not just the diff. |
| `/ponytail-debt` | Harvest `// ponytail:` shortcuts into a ledger so they don't get forgotten before release. |

For Cursor: this file goes at `.cursor/rules/ponytail-flutter.md` (or `.mdc` with frontmatter if you want it scoped only to `.dart` files — see note below).
For Claude Code / Codex / generic agents: append this file's content into `AGENTS.md` or keep as a separate file Claude Code is told to read.
For Antigravity/Gemini CLI: drop into `.agents/rules/ponytail-flutter.md`.