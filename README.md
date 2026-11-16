# frantend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to regenerate code

Generated files (`*.g.dart`, `*.freezed.dart`, `lib/core/database/app_database.g.dart`,
`lib/core/di/injection.config.dart`) are committed, but **never edit them by hand**.
Change the source annotations and regenerate:

```powershell
powershell -File scripts/codegen.ps1            # regenerate everything
powershell -File scripts/codegen.ps1 -Clean     # after changing generator versions
powershell -File scripts/check_generated.ps1    # CI: fails if committed files differ from generator output
```

The toolchain is pinned by `pubspec.yaml` + the committed `pubspec.lock`
(Flutter 3.47 / Dart 3.13, build_runner 2.16, freezed 4, json_serializable 6.15,
drift_dev 2.35, injectable_generator 3.1). Rules the generators impose:

* `@freezed` models are `abstract class X with _$X` (single constructor) or
  `sealed class X with _$X` (unions). Union helpers (`when`, `maybeWhen`, ...) are
  extensions, so import the file that declares the state class.
* Constructor parameters of function type on injectable classes need
  `@ignoreParam` (those cubits are registered by hand in `lib/core/di/foundation_module.dart`).
* Tolerant number reading is expressed as `@JsonKey(fromJson: JsonNum.intOr / intOrNull / stringOrNull)`.
