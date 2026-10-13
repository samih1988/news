# Flutter Architecture & Development Rules (Advanced MVVM + Repository Pattern)

Apply these universal architectural rules to any Flutter codebase worked on with the user.
These rules are feature-agnostic and must be followed strictly.

---

## 1. Separation of Responsibilities

- **Model**: DTO data container only (`fromJson`, `toJson`, properties). Never contains business
  logic or network code.
- **Remote DataSource**: Network/API calls only using HTTP/Dio. No caching logic, no connectivity
  checks.
- **Local DataSource**: Local storage only (Hive, SQLite, SharedPreferences). Never close boxes
  inside data access methods (`box.close()` forbidden). Queries must return nullable types (
  `Future<Model?>`).
- **Repository**: Sole orchestrator and error translator. Decides remote vs local caching strategy.
  Translates all failures into `Failure` classes. Never throws raw unhandled exceptions.
- **Cubit / Bloc**: State management only (Loading, Success, Error). Never writes `try/catch` on
  Either-returning methods. Consumes results via `.fold()`.
- **UI**: Visual rendering and user event dispatching only.

---

## 2. Universal Folder Structure

```
lib/
├── core/
│   ├── di/                   # Dependency Injection (Injectable setup)
│   ├── errors/               # Failures hierarchy (ServerFailure, NetworkFailure, CacheFailure)
│   ├── network/              # Dio client, interceptors, endpoints
│   ├── storage/              # Storage helpers, Hive setup
│   ├── theme/                # Theme, Colors, TextStyles
│   ├── utils/                # Constants, helpers, routes
│   └── widgets/              # Shared reusable widgets
├── data/
│   ├── models/               # DTOs
│   ├── datasources/          # local/ and remote/ (contracts + impl/)
│   └── repositories/         # contracts + impl/
└── ui/
    └── [feature]/            # Feature-first: cubit/, widgets/, screen.dart
```

---

## 3. Strict Error Handling (`Either<Failure, T>`)

- All repository methods must return `Future<Either<Failure, T>>` using `dartz`.
- Base failure:
  ```dart
  abstract class Failure { final String message; const Failure(this.message); }
  class ServerFailure extends Failure { const ServerFailure(super.message); }
  class NetworkFailure extends Failure { const NetworkFailure([super.message = "No internet connection"]); }
  class CacheFailure extends Failure { const CacheFailure([super.message = "No cached data found"]); }
  ```
- Error priority in Repository:
    1. Extract backend error message from response body (`response.status == 'error'` or
       `dioError.response.data['message']`).
    2. Handle network/timeout errors with clear user-friendly message (`NetworkFailure`).
    3. Wrap unexpected runtime exceptions in `ServerFailure`.
- In Cubit:
  ```dart
  result.fold(
    (failure) => emit(FeatureErrorState(errorMessage: failure.message)),
    (data) => emit(FeatureSuccessState(data: data)),
  );
  ```

---

## 4. Local Caching with Hive

- Never close boxes inside queries/saves (`box.close()` is prohibited in data sources).
- Local query methods must be nullable: `Future<Model?> getCachedItem(String id)`.
- Register all required model adapters and run `build_runner`.
- On offline cache miss, repository must return `Left(CacheFailure(...))`.

---

## 5. Dependency Injection (`Injectable` + `GetIt`)

- `@Injectable(as: FeatureRemoteDataSource)` for Remote DataSource implementations.
- `@Injectable(as: FeatureLocalDataSource)` for Local DataSource implementations.
- `@Injectable(as: FeatureRepository)` for Repository implementations.
- `@injectable` for Cubits.
- `@singleton` for long-lived clients (`Dio`, `SharedPreferences`).
- Run `dart run build_runner build --delete-conflicting-outputs` after dependency updates.

---

## 6. UI & State Lifecycle

- Provide Cubits via `BlocProvider(create: (context) => getIt<FeatureCubit>()..init())`.
- If a Cubit is stored in a `StatefulWidget` state directly, always call `cubit.close()` in
  `dispose()`.

---

## 7. Clean Code Conventions

- File/folder names: `snake_case`.
- Class names: `PascalCase`.
- Variables/methods: `camelCase`.
- Zero dead code: delete commented-out or unused classes.
- No magic strings: endpoints and storage keys go into `core/`.
