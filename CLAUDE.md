# CLAUDE.md — CarePlan v3

## Project Overview

Flutter healthcare mobile app (Android + iOS) for patient care management. Dart >=3.6.0.

**Entry points:** `lib/main-production.dart`, `lib/main-staging.dart`

## Architecture

Clean Architecture + MVVM. Every feature follows this layered structure:

```
features/<feature>/
├── data/
│   ├── datasources/        # Remote data source (abstract + impl)
│   │   └── endpoint.dart   # API endpoint strings
│   ├── model/              # Data models with fromJson/toJson
│   └── repositories/       # Repository implementations
├── domain/
│   ├── di/                 # Feature DI injector (GetIt registrations)
│   ├── repositories/       # Abstract repository interfaces
│   └── usecases/           # Use cases + param classes + facade
└── presentation/
    ├── state/              # ChangeNotifier providers
    └── <flow_name>/        # Screen files grouped by flow
```

## Coding Flow (how to build a new feature)

### 1. Define endpoints

Create `data/datasources/endpoint.dart` with static strings:
```dart
class MyFeatureEndpoints {
  static String getData = "my-feature/data";
}
```

### 2. Create models

In `data/model/`, use manual `fromJson`/`toJson` (no code generation):
```dart
class MyModel {
  final String? id;
  final String? name;

  MyModel({this.id, this.name});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### 3. Create remote data source

Abstract interface + implementation. Inject `NetworkService`. Use `handleNetworkResponse()` to unwrap responses:
```dart
abstract class MyFeatureRemoteDataSource {
  Future<MyModel> getData();
}

class MyFeatureRemoteDataSourceImpl implements MyFeatureRemoteDataSource {
  final NetworkService _networkService;
  MyFeatureRemoteDataSourceImpl(this._networkService);

  @override
  Future<MyModel> getData() async {
    NetworkServiceResponse response = await _networkService.get(MyFeatureEndpoints.getData);
    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    return MyModel.fromJson(jsonData['data']);
  }
}
```

### 4. Create repository

Abstract interface in `domain/repositories/`, implementation in `data/repositories/`. Always wrap calls with `guardedApiCall<T>()`:
```dart
// domain/repositories/
abstract class MyFeatureRepository {
  Future<MyModel> getData();
}

// data/repositories/
class MyFeatureRepositoryImpl implements MyFeatureRepository {
  final MyFeatureRemoteDataSource _remoteDataSource;
  MyFeatureRepositoryImpl(this._remoteDataSource);

  @override
  Future<MyModel> getData() async =>
      await guardedApiCall<MyModel>(() => _remoteDataSource.getData(), source: "getData");
}
```

### 5. Create use cases

Each use case implements `UseCase<ReturnType, ParamType>` and returns `Either<UIError, T>`. Catch `NetworkFailure` and `CacheFailure`:
```dart
class GetData implements UseCase<MyModel, NoParams> {
  final MyFeatureRepository _repo;
  GetData(this._repo);

  @override
  Future<Either<UIError, MyModel>> call([NoParams? params]) async {
    try {
      final result = await _repo.getData();
      return Right(result);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}
```

Group use cases in a facade class:
```dart
class MyFeatureUseCases {
  final GetData getData;
  MyFeatureUseCases(this.getData);
}
```

### 6. Wire DI

In `domain/di/my_feature_injector.dart`, register datasource -> repo -> usecases -> provider:
```dart
Future<void> myFeatureInjector() async {
  inject.registerLazySingleton<MyFeatureRemoteDataSource>(
    () => MyFeatureRemoteDataSourceImpl(inject()),
  );
  inject.registerLazySingleton<MyFeatureRepository>(
    () => MyFeatureRepositoryImpl(inject()),
  );
  inject.registerLazySingleton<GetData>(() => GetData(inject()));
  inject.registerLazySingleton<MyFeatureUseCases>(() => MyFeatureUseCases(inject()));
  inject.registerLazySingleton<MyFeatureProvider>(() => MyFeatureProvider(inject()));
}
```

Then add the call in `core/di/di_config.dart` inside `initInjectors()`.

### 7. Create provider (state management)

Extend `ChangeNotifier` with `ProviderState` mixin. Use `_setState` helper and `response.fold()`:
```dart
class MyFeatureProvider with ChangeNotifier, ProviderState {
  final MyFeatureUseCases useCases;
  MyFeatureProvider(this.useCases);

  void _setState({loading = false, isReady = false, hasError = false, errorMsg = '', payload}) {
    update(loading: loading, hasErr: hasError, errorMsg: errorMsg, ready: isReady, statePayload: payload);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _setState(loading: true, hasError: false);
    notifyListeners();

    Either<UIError, MyModel>? response = await useCases.getData();
    notifyListeners();

    response.fold(
      (l) => _setState(loading: false, hasError: true, errorMsg: l.message),
      (r) => _setState(loading: false, isReady: true, payload: r),
    );
  }
}
```

Register in `ProviderInitializer.providers` list.

### 8. Build UI screens

Use `ViewModelProvider` + `LoaderWrapper` pattern:
```dart
@override
Widget build(BuildContext context) {
  return ViewModelProvider(
    viewModel: inject<MyFeatureProvider>(),
    builder: (context, vm, _) {
      return LoaderWrapper(
        isLoading: vm.isLoading,
        view: Scaffold(
          appBar: CustomAppBar(showBackIcon: true),
          body: vm.hasError
              ? ErrorComponent(message: vm.errorMessage)
              : MyContent(data: vm.payload),
        ),
      );
    },
  );
}
```

## Error Handling Flow

```
DataSource throws exception
  → guardedApiCall catches → converts to NetworkFailure/CacheFailure
    → UseCase catches → converts to Left(UIError)
      → Provider.fold() sets hasError + errorMessage
        → UI reads vm.hasError / vm.errorMessage
```

## Navigation

Use the global `router` (RouterService) — never use `Navigator.of(context)` directly:
```dart
router.push(MyScreen());                                    // push
router.pop();                                               // pop
router.pushReplacement(MyScreen());                         // replace
router.pushAndRemoveUntil(MyScreen(), (route) => false);   // clear stack
```

All transitions use fade animation by default.

## Key Conventions

### Naming
- **Files:** `snake_case.dart` — suffixes: `_screen`, `_model`, `_datasource`, `_repository_impl`, `_provider`
- **Classes:** `PascalCase` — suffixes: `Screen`, `Model`, `RemoteDataSource`/`RemoteDataSourceImpl`, `Repository`/`RepositoryImpl`, `Provider`
- **Param classes:** `PascalCase` with `Params` suffix, bundled in same file as use case
- **Endpoints:** static strings in a per-feature `Endpoints` class

### DI Registration
- `registerSingleton()` — one instance, created immediately (core services)
- `registerLazySingleton()` — one instance, created on first access (features)
- `registerFactory()` — new instance each time (interceptors)

### Storage
- **Sensitive data** (tokens, PIN): `SecuredStorage` (flutter_secure_storage)
- **General data** (user profile, preferences): `LocalStorageService` (SharedPreferences)
- **In-memory cache**: `InMemory` class

### Colors & Styles
Defined in `core/platform/color.dart` as `CarePlanColor` static constants. Font: Avenir (weights 300–700).

### Shared Widgets
Located in `core/presentation/widgets/`:
- `LoaderWrapper` — loading overlay
- `CustomAppBar` — app bar with back button
- `CustomTextField` — form input
- `CustomButtom` — styled button
- `TextHolder` — reusable styled text
- `ErrorComponent` — error display
- `AppLoadingIndicator` — spinner

## Commands

```bash
# Run (production)
flutter run -t lib/main-production.dart

# Run (staging)
flutter run -t lib/main-staging.dart

# Build runner (code gen)
dart run build_runner build --delete-conflicting-outputs
```

## Environment

Two flavors configured via `EnvConfig`:
- **Production:** `Constants.PROD_BASE_URL`
- **Staging:** staging base URL

Set in `main()` before `initInjectors()`.