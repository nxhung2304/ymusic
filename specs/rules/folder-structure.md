# Flutter Project Structure — Feature-First Clean Architecture

## Overview

This project follows **Feature-First Clean Architecture**.
State management, DI, and networking are intentionally left flexible — adapt to your stack.

### Dependency Rule
```
Presentation → Domain ← Data
```
- `domain` — pure Dart, zero dependencies on Flutter or external packages
- `data` — implements domain interfaces, handles API/local storage
- `presentation` — UI layer, calls domain usecases via state management of choice

---

## Folder Structure

```
lib/
├── core/                                   # Shared across all features
│   ├── constants/
│   ├── error/
│   │   ├── exceptions.dart                 # Raw exceptions (thrown by datasource)
│   │   └── failures.dart                   # Domain-level failures (returned by repository)
│   ├── network/                            # HTTP client setup
│   ├── router/                             # App routing
│   └── utils/
│
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── [feature]_remote_datasource.dart
│       │   │   └── [feature]_local_datasource.dart
│       │   ├── models/
│       │   │   └── [entity]_model.dart
│       │   └── repositories/
│       │       └── [feature]_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── [entity].dart
│       │   ├── repositories/
│       │   │   └── [feature]_repository.dart    # abstract
│       │   └── usecases/
│       │       └── [action]_usecase.dart
│       │
│       └── presentation/
│           ├── [state_management]/             # bloc/ | providers/ | notifiers/ | controllers/
│           ├── pages/
│           └── widgets/
│
└── main.dart
```

---

## Layer Conventions

### domain/entities
- Pure Dart, no `fromJson`/`toJson`, no Flutter imports
- Immutable by convention

```dart
class UserEntity {
  final String id;
  final String email;
  const UserEntity({required this.id, required this.email});
}
```

### domain/repositories
- Abstract class only — no implementation here

```dart
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
}
```

### domain/usecases
- One file = one action
- Depends only on repository abstract class

```dart
class LoginUsecase {
  final AuthRepository repository;
  const LoginUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.login(email, password);
  }
}
```

### data/models
- Extends or maps to entity
- Contains serialization logic (`fromJson`, `toJson`)

```dart
class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], email: json['email']);
}
```

### data/repositories
- Implements domain repository
- Catches exceptions from datasource, returns `Either<Failure, T>`

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  const AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      return Right(await remote.login(email, password));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

### presentation/[state_management]
- Calls usecases only — no direct repository or datasource access
- Folder name matches your chosen library:

| Library | Folder name |
|---|---|
| flutter_bloc | `bloc/` |
| Riverpod | `providers/` |
| GetX | `controllers/` |
| Provider / ChangeNotifier | `notifiers/` |

---

## Naming Conventions

| Type | Pattern | Example |
|---|---|---|
| Entity | `[Name]Entity` | `UserEntity` |
| Model | `[Name]Model` | `UserModel` |
| Repository (abstract) | `[Feature]Repository` | `AuthRepository` |
| Repository (impl) | `[Feature]RepositoryImpl` | `AuthRepositoryImpl` |
| Datasource (abstract) | `[Feature]RemoteDatasource` | `AuthRemoteDatasource` |
| Datasource (impl) | `[Feature]RemoteDatasourceImpl` | `AuthRemoteDatasourceImpl` |
| Usecase | `[Action]Usecase` | `LoginUsecase` |

---

## Rules

1. **`domain` has zero external dependencies** — no Flutter, no Dio, no state management packages
2. **Never import `data` or `presentation` from `domain`**
3. **Each usecase = one file, one public method (`call`)**
4. **All exceptions are caught in `repository_impl`** — never leak into usecase or presentation
5. **Models live in `data/`, entities live in `domain/`** — never mix
6. **No cross-feature imports** — shared code goes into `core/`
7. **Presentation calls usecases only** — never repositories or datasources directly
