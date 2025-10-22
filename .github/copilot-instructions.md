## Repository quick guide for AI coding agents

This repository is a small Flutter application (template-style) named `holoo_assistant_widget`.
The guidance below focuses on the concrete, discoverable patterns and developer workflows so an AI agent can be immediately productive.

1) Big-picture architecture
 - Flutter app (Dart) at the repo root; main entry: `lib/main.dart` (standard MaterialApp).  Use this file to find app-level routing, theme, and the initial widget tree.
 - Platform hosts: Android (`android/`), iOS (`ios/`), macOS, Linux, Windows. Android native configuration lives under `android/app/build.gradle` and `android/` Gradle files.
 - No custom platform channels or native plugin code detected in the repo; treat this as a pure Flutter UI app unless new files are added.

2) Build / run / test workflows (explicit commands)
 - Run on device or emulator: `flutter run` (standard Flutter CLI). Use `-d <deviceId>` for a specific target.
 - Build Android release: `flutter build apk` or use Android Studio Gradle tasks.
 - Run tests: `flutter test` (there is a `test/widget_test.dart` example).
 - Fetch packages / get dependencies: `flutter pub get`.
 - Linting: this project includes `analysis_options.yaml` and `flutter_lints` in dev_dependencies — run `flutter analyze` to check.

3) Project-specific conventions and patterns
 - This repo follows the Flutter default project layout. Expect UI code under `lib/` and platform configuration under platform folders.
 - The `pubspec.yaml` pins minimal dependencies (only `cupertino_icons`). New feature code should add dependencies to `pubspec.yaml` and run `flutter pub get`.
 - Versioning: `version:` is set in `pubspec.yaml`. Android Gradle reads Flutter-managed variables in `android/app/build.gradle` (see `versionCode`, `versionName` mapping to Flutter values).

4) Integration points and external dependencies to watch
 - No network clients, authentication, or backend integrations detected in current sources. If adding HTTP or native integrations, add packages (e.g., `http`, `dio`) and update platform manifests (AndroidManifest, Info.plist) accordingly.
 - Native configuration: Android uses Gradle plugin `dev.flutter.flutter-gradle-plugin`. When adding native dependencies, ensure Gradle versions and Kotlin JVM target remain compatible (`jvmTarget = 1.8`).

5) Files you should inspect when making changes
 - `lib/main.dart` — root widget and app entry.
 - `pubspec.yaml` — dependencies, Flutter settings, assets, and versioning.
 - `android/app/build.gradle` and `android/build.gradle` — Android build configuration and signing basics.
 - `analysis_options.yaml` — lint rules used by this repo.

6) Examples of concrete code patterns (from this repo)
 - Material app creation: see `MaterialApp(title: 'Flutter Demo', theme: ThemeData(...), home: MyHomePage(...))` in `lib/main.dart`.
 - State management in this repo: local StatefulWidget (`MyHomePage` / `_MyHomePageState`) with `setState` for updates — follow this style for small local state changes.

7) Agent behavior and pull-request suggestions
 - Prefer small, focused changes with tests where possible. For UI changes, include screenshots or steps to reproduce visual differences in PR descriptions.
 - When adding packages, update `pubspec.yaml` and run `flutter pub get`; include a short note in PR about why the dependency was added and any platform changes required (e.g., Android manifest permissions).
 - Avoid adding platform channel code unless the change includes native stubs under the corresponding `android/` or `ios/` directories and clear build instructions.

8) Common pitfalls observed / things to verify
 - Keep Kotlin and Gradle compatibility: `android/app/build.gradle` expects Java 1.8 compatibility; do not upgrade to newer JVM targets without testing builds on CI.
 - If changing version or build settings, ensure `version` in `pubspec.yaml` matches Android `versionCode/versionName` expectations.

If any part of the repository's intended function is missing (for example: widget-specific behavior, platform channels, CI configs), tell me what you'd like to add and I will update these instructions and the repo accordingly.
