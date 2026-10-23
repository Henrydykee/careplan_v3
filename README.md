# CarePlan v3 — Flutter Healthcare App

A mobile patient care management platform built with **Flutter/Dart**, targeting both Android and iOS.

## Tech Stack

- **Framework:** Flutter (Dart >=3.6.0)
- **State Management:** Provider + ChangeNotifier
- **DI:** GetIt (service locator)
- **Networking:** Dio with custom interceptors
- **Error Handling:** Dartz (Either type, functional style)
- **Storage:** Shared Preferences + Flutter Secure Storage
- **Auth:** PIN-based + biometric (Local Auth)
- **Serialization:** Dart Mappable (code-gen)
- **Firebase:** Remote Config for feature flags

## Architecture

Clean Architecture + MVVM, organized per feature:

```
features/<feature>/
  ├── data/          (datasources, models, repo implementations)
  ├── domain/        (repo interfaces, usecases, DI)
  └── presentation/  (pages, state/providers)
```

## Key Features (14 modules)

`auth` · `home` · `assement` · `careplan` · `appointment` · `card` · `history` · `account` · `onboarding` · `getting_started` · `billing` · `notification` · `nav_bar` · `stressors`

## Notable Patterns

- **`guardedApiCall<T>()`** wrapper for safe API calls with `Either<Failure, T>` returns
- **`ProviderState` mixin** for common loading/error/ready states
- **Custom `RouterService`** with fade transitions and a global navigator key
- **Two environment flavors:** production & staging via `EnvConfig`
- **Feature-level DI injectors** registered in a core config

## Releasing

Builds are shipped with [Shorebird](https://docs.shorebird.dev), which wraps `flutter build`
and additionally uploads a copy of the release to Shorebird's servers. That upload is what
makes later over-the-air patches possible — a build produced by plain `flutter build` cannot
be patched.

Store submission itself is unchanged: Shorebird produces the same AAB/IPA you upload today.

> **Upload only artifacts built by `shorebird release`.** A plain `flutter build` writes to the
> *same* output path, so the file sitting in `build/` may or may not contain the updater, and
> nothing in the filename says which. `shorebird.yaml` is bundled as an asset either way, so its
> presence proves nothing. Ship a `flutter build` artifact and those users can never receive a
> patch — even though the Shorebird console will still show the release as `active`.
>
> To check an AAB before uploading — a Shorebird build reports a non-zero count, a plain
> `flutter build` reports exactly `0`:
>
> ```bash
> unzip -p <app>.aab base/lib/arm64-v8a/libflutter.so | grep -ac shorebird
> ```

### Prerequisites

```bash
shorebird account whoami     # must be logged in; otherwise: shorebird login
shorebird doctor             # verifies project wiring
```

Each flavor is a separate Shorebird app, mapped in `shorebird.yaml`:

| Flavor | Entry point | Shorebird app |
|---|---|---|
| production | `lib/main-production.dart` | `CarePlan (production)` |
| staging | `lib/main-staging.dart` | `CarePlan (staging)` |

Bump `version:` in `pubspec.yaml` before cutting a store release. The version string
(`3.0.0+117`) is the key Shorebird uses to match a patch to its release, so every store
build needs its own.

### Android → Play Store

```bash
# production
shorebird release -p android --flavor production \
  -t lib/main-production.dart --flutter-version 3.47.1

# staging
shorebird release -p android --flavor staging \
  -t lib/main-staging.dart --flutter-version 3.47.1
```

Upload the resulting bundle to the Play Console:

- production → `build/app/outputs/bundle/productionRelease/app-production-release.aab`
- staging → `build/app/outputs/bundle/stagingRelease/app-staging-release.aab`

### iOS → App Store

Delete stale IPAs first. Shorebird looks for exactly one `.ipa` in `build/ios/ipa/` and
fails with "Unable to find generated IPA" if a previous flavor's build is still sitting
there — even though the build itself succeeded.

```bash
rm -f build/ios/ipa/*.ipa

# production
shorebird release -p ios --flavor production \
  -t lib/main-production.dart --flutter-version 3.47.1

# staging — clear the directory again before switching flavor
rm -f build/ios/ipa/*.ipa
shorebird release -p ios --flavor staging \
  -t lib/main-staging.dart --flutter-version 3.47.1
```

Upload `build/ios/ipa/*.ipa` with the [Transporter](https://apps.apple.com/us/app/transporter/id1450874784)
app, or from the terminal:

```bash
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa \
  --apiKey <key_id> --apiIssuer <issuer_id>
```

### Patching a shipped release (OTA, no store review)

A patch updates Dart code on devices already running a matching release. Pass the exact
`--release-version` of the store build being patched:

```bash
# production — android
shorebird patch -p android --flavor production \
  -t lib/main-production.dart --release-version 3.0.0+117

# production — ios
shorebird patch -p ios --flavor production \
  -t lib/main-production.dart --release-version 3.0.0+117

# staging — android (note the -stage suffix)
shorebird patch -p android --flavor staging \
  -t lib/main-staging.dart --release-version 3.0.0-stage+117

# staging — ios (no suffix; iOS ignores versionNameSuffix)
shorebird patch -p ios --flavor staging \
  -t lib/main-staging.dart --release-version 3.0.0+117
```

**Release versions are not the same on both platforms.** `versionNameSuffix` in
`android/app/build.gradle` is an Android-only Gradle setting, so the `-stage` suffix never
reaches iOS, where the version comes from the Xcode project instead:

| Flavor | Android | iOS |
|---|---|---|
| production | `3.0.0+117` | `3.0.0+117` |
| staging | `3.0.0-stage+117` | `3.0.0+117` |

iOS staging and iOS production share a version string, but they are separate Shorebird apps
(separate `app_id`s in `shorebird.yaml`), so they do not collide. Always read the exact
version off `shorebird releases list` before patching rather than assuming the suffix:

```bash
shorebird releases list --flavor production
shorebird releases list --flavor staging
```

`shorebird preview` runs a published release on a device. It takes the app id from
`shorebird.yaml` (not a `--flavor` flag), and prompts for the release if omitted:

```bash
shorebird preview --app-id <app id> --platform ios --release-version 3.0.0+117
```

**What a patch cannot change.** Patches carry Dart code only. Anything below the Dart layer
needs a new release and a store submission:

- native code, plugins, or dependency changes (`pubspec.yaml`, Podfile, Gradle)
- assets, app icons, launch images
- permissions, entitlements, manifest or Info.plist changes
- the Flutter version — a patch is always built with its release's Flutter version

### Why `--flutter-version` is pinned

Shorebird defaults to the latest stable Flutter, which may not be the version this project
builds against. `3.47.1` matches the repo's toolchain; keep the flag in sync whenever the
team upgrades Flutter, and note that existing releases stay pinned to the version they were
cut with.
