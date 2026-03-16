# State Management — Riverpod Convention

## Stack
- `flutter_riverpod` + `riverpod_annotation` (code generation)
- `freezed` for immutable state
- Always run: `dart run build_runner watch`

---

## Provider Type Cheatsheet

| Use case | Provider type |
|---|---|
| Async data, no state mutation (fetch & display) | `@riverpod Future<T>` |
| Simple sync value | `@riverpod T` |
| Mutable state + methods | `@riverpod class XxxNotifier extends _$XxxNotifier` |
| Stream (realtime, websocket) | `@riverpod Stream<T>` |

**Rule: Only use `Notifier` when you need to mutate state. Otherwise use plain `@riverpod`.**

---

## Notifier Convention

### File location
```
features/[feature]/presentation/providers/
├── [feature]_provider.dart     # Notifier + DI providers
└── [feature]_state.dart        # State class (freezed)
```

### State — always freezed
```dart
// [feature]_state.dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial()                   = _Initial;
  const factory AuthState.loading()                   = _Loading;
  const factory AuthState.success(UserEntity user)    = _Success;
  const factory AuthState.error(String message)       = _Error;
}
```

### Notifier
```dart
// [feature]_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    final result = await ref.read(loginUsecaseProvider).call(email, password);

    state = result.fold(
      (failure) => AuthState.error(failure.message),
      (user)    => AuthState.success(user),
    );
  }
}
```

---

## DI Providers (in same file as Notifier)

Wire from datasource → repository → usecase in the same `_provider.dart` file.

```dart
@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) =>
    AuthRemoteDatasourceImpl(ref.read(dioClientProvider));

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.read(authRemoteDatasourceProvider));

@riverpod
LoginUsecase loginUsecase(Ref ref) =>
    LoginUsecase(ref.read(authRepositoryProvider));
```

---

## Consuming in UI

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);

    return state.when(
      initial: () => const LoginForm(),
      loading: () => const CircularProgressIndicator(),
      success: (user) => HomeRedirect(user: user),
      error:   (msg)  => ErrorText(message: msg),
    );
  }
}
```

### ref.watch vs ref.read

| | Usage |
|---|---|
| `ref.watch` | Inside `build()` — rebuilds widget on change |
| `ref.read` | Inside callbacks/methods — one-time read, no rebuild |

**Never use `ref.watch` inside a callback or method.**

---

## Async Provider (no mutation needed)

```dart
// Fetch-only, no state mutation
@riverpod
Future<List<ProductEntity>> productList(Ref ref) async {
  return ref.read(getProductListUsecaseProvider).call();
}

// In UI
final state = ref.watch(productListProvider);
return state.when(
  data:    (list)  => ProductListView(items: list),
  loading: ()      => const CircularProgressIndicator(),
  error:   (e, st) => ErrorText(message: e.toString()),
);
```

---

## Rules

1. **State is always immutable** — use `freezed`, never mutate fields directly
2. **Notifier only calls usecases** — never calls repository or datasource directly
3. **DI providers stay in `[feature]_provider.dart`** — co-locate with the notifier
4. **One notifier per feature screen/flow** — don't share notifier across unrelated screens
5. **Never use `ref.watch` outside `build()`** — use `ref.read` in event handlers
6. **Loading/error/success states are explicit** — never use nullable fields to represent state
7. **`build()` returns initial state only** — no side effects inside `build()`
