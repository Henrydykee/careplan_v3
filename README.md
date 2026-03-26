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
