# Flutter-Specific Rules

## State Management — Riverpod

### Provider types

| Use case | Provider type |
|----------|--------------|
| Async data từ API | `@riverpod AsyncNotifier` |
| Sync state (filter, tab) | `@riverpod Notifier` |
| Simple computed value | `@riverpod` function |
| Stream | `@riverpod StreamNotifier` |

### UI đọc state

```dart
// Screen phải extends ConsumerWidget hoặc ConsumerStatefulWidget
class LeaveListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaveRequestNotifierProvider);

    return switch (state) {
      AsyncData(:final value) => LeaveListView(items: value),
      AsyncError(:final error) => ErrorView(error: error),
      _ => const LoadingView(),
    };
  }
}
```

### Invalidate & Refresh

```dart
// Reload data
ref.invalidate(leaveRequestNotifierProvider);

// Không dùng ref.read trong build()
```

## Navigation — go_router

- Định nghĩa tất cả routes trong `core/router/app_router.dart`
- Dùng named routes, không dùng path string trực tiếp
- Route constants trong `AppRoutes` class

```dart
// ✅ Đúng
context.goNamed(AppRoutes.leaveDetail, pathParameters: {'id': id});

// ❌ Sai
context.go('/leave/123');
```

## Freezed Models

Tất cả data models dùng `@freezed`:

```dart
@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    required String id,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String status, // pending | approved | rejected
    String? reason,
  }) = _LeaveRequest;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFromJson(json);
}
```

## Async Notifier Pattern

```dart
@riverpod
class LeaveRequestNotifier extends _$LeaveRequestNotifier {
  @override
  Future<List<LeaveRequest>> build() async {
    // Load initial data
    final repo = ref.read(leaveRepositoryProvider);
    final result = await repo.getLeaveRequests();
    return switch (result) {
      Success(:final data) => data,
      Failure(:final failure) => throw failure,
    };
  }

  Future<void> createLeaveRequest(CreateLeaveRequestParams params) async {
    // Optimistic update hoặc loading state
    state = const AsyncLoading();
    final repo = ref.read(leaveRepositoryProvider);
    final result = await repo.createLeaveRequest(params);
    state = switch (result) {
      Success(:final data) => AsyncData([data, ...state.valueOrNull ?? []]),
      Failure(:final failure) => AsyncError(failure, StackTrace.current),
    };
  }
}
```

## Build Runner

Sau khi thêm/sửa file có annotation, chạy:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Các annotation cần build_runner:
- `@riverpod` → generate `*.g.dart`
- `@freezed` → generate `*.freezed.dart` + `*.g.dart`

## Linting

File `analysis_options.yaml` dùng `flutter_lints` + custom rules:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_use_package_imports
    - avoid_dynamic_calls
    - avoid_print
    - prefer_const_constructors
    - prefer_const_widgets
    - sized_box_for_whitespace
    - use_super_parameters
```

## Performance

- Dùng `const` constructor khi có thể
- Không gọi async trong `build()`
- Dùng `select()` để tránh rebuild không cần thiết

```dart
// Chỉ rebuild khi status thay đổi
final status = ref.watch(
  leaveRequestNotifierProvider.select((s) => s.valueOrNull?.first.status),
);
```
