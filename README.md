# Phrases to Share

English README for the "Phrases to Share" Flutter app.

## Overview

"Phrases to Share" is a small Flutter application that provides a collection of ready-made phrases and images for sharing. The project includes mobile (Android/iOS), desktop (macOS, Linux, Windows) scaffolding, Firebase integration, and scripts to generate Play Store assets (icons, screenshots, feature graphic).

## Technologies Used

- Flutter (Dart) — UI and cross-platform app framework
- Android toolchain (Gradle, Android SDK, NDK) — Android builds (APK, AAB)
- iOS/macOS toolchain (Xcode project files) — iOS and macOS builds
- Kotlin — Android embedding / MainActivity
- CMake — Linux desktop build
- Firebase (google-services) — authentication and other services
- Python + Pillow — scripts to generate launcher icons and Play Store assets
- flutter_launcher_icons — launcher icon generation
- Git — source control

## Project Structure (high level)

- `lib/` — Flutter app source code (main.dart and features)
- `android/` — Android-specific project files and Gradle build
- `ios/`, `macos/`, `linux/`, `windows/` — platform-specific projects
- `scripts/` — helper scripts used to create icons and screenshots
- `release/` — generated Play Store assets (512 icon, feature graphic, screenshots)
- `android/keystore/` — local release keystore (if present)
- `key.properties` — local signing config used by Gradle (do NOT commit secrets)
- `build/` — generated build outputs (APK, AAB, intermediates)

## How to build and run

Prerequisites

- Flutter SDK (tested with Flutter 3.x)
- Android SDK (with build-tools and cmdline-tools)
- JDK 11+ for Gradle builds (some Android tools may require JDK 8 for legacy JAXB classes)

Development (run on device/emulator)

```bash
flutter pub get
flutter run
```

Build a signed release APK (uses `android/key.properties` if present)

```bash
# Ensure JDK 11 is used by Gradle
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
flutter clean
flutter build apk --release
# Outputs: build/app/outputs/flutter-apk/app-release.apk
```

Build an Android App Bundle (AAB) for Play Store upload

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
flutter build appbundle --release
# Outputs: build/app/outputs/bundle/release/app-release.aab
```

Notes about Android SDK licenses and JAXB issues

Some Android SDK command-line tools (sdkmanager, apkanalyzer) and older tooling may expect JAXB classes that were removed from newer JDKs. If you see errors like `NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema` when running `flutter doctor --android-licenses` or `sdkmanager`, consider either:

- Temporarily using a JDK 8 (for license acceptance only):

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home
flutter doctor --android-licenses
```

- Or run sdkmanager directly with JAXB jars on the classpath (non-invasive). Example approach used during development:

```bash
# download jakarta.xml.bind-api and jaxb-runtime jars into ~/.android/jaxb
# then run:
JAVA_CMD=$(/usr/libexec/java_home -v 11)
$JAVA_CMD/bin/java -cp "$ANDROID_SDK/cmdline-tools/latest/lib/*.jar:~/.android/jaxb/*" com.android.sdklib.tool.sdkmanager.SdkManagerCli --licenses
```

## Firebase / google-services

This project includes `google-services.json` files for Firebase integration. If you change the applicationId (package name) make sure to update Firebase console and the `google-services.json` files accordingly.

## Generated Play Store assets

- `release/playstore/icon_512.png` — 512×512 app icon (no alpha) used by Play Store
- `release/playstore/feature_graphic.png` — 1024×500 feature graphic
- `release/screenshots/phone/` — generated promotional screenshots (1080×1920)

## Lessons Learned (what was learned during this project)

- Tooling: Android's command-line tools sometimes have strict JDK requirements. Modern JDKs (11+) are required for Gradle, but some SDK utilities expect JAXB from older JDKs. A practical solution is to run only the SDK tools with a JDK 8 or include the necessary JAXB jars on the classpath.
- Build artifacts: Flutter's build producing both APK and AAB outputs; AAB is preferred for Play Store. If the strip debug-symbols step fails, examine Gradle's strip task and apkanalyzer stdout/stderr for the real cause and verify the NDK strip tools exist.
- Signing: Keep `key.properties` out of version control. Use a release keystore and ensure signing configs in `android/app/build.gradle(.kts)` point to the local keystore path.
- Reproducible scripts: Small Python scripts that generate icons/screenshots are useful to quickly produce Play Store assets and keep them consistent.

## Troubleshooting

- If `flutter build appbundle` fails during native symbol stripping:
  - Ensure NDK versions exist under `$ANDROID_SDK/ndk/` and that `ndkVersion` in Gradle points to an installed version.
  - Run the Gradle strip task with `--stacktrace` and inspect the exact command failing.
  - Verify `apkanalyzer` runs without Java errors (JAXB) — see notes above.

## Where to look next

- `lib/` — app logic and UI
- `scripts/` — icon and screenshot generators
- `release/` — Play Store-ready assets
- `android/` — Gradle signing config, manifest, and native toolchain settings

## Credits

Project created and maintained by the app author. Assets were generated programmatically with Python + Pillow scripts.

---
If you want, I can also add a short CONTRIBUTING.md and a checklist for Play Store release steps (metadata, screenshots, AAB upload, staged rollout). Want me to add that next?
# phrases_to_share

A new Flutter project.
