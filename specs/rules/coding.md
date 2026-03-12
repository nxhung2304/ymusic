# Coding Conventions

## Folder Structure

```
lib/
├── core/
│   ├── constants/        # AppColors, AppTypography, AppSpacing
│   ├── theme/            # AppTheme
│   ├── utils/            # Extensions, helpers
│   ├── errors/           # Failure classes, Result type
│   └── widgets/          # Shared base widgets
└── features/
    └── [feature]/
        ├── data/
        │   ├── datasources/  # External calls: Firebase, REST API, local DB
        │   ├── models/       # DTOs — Freezed + fromJson/toJson
        │   └── repositories/ # Implements domain/repositories interfaces
        ├── domain/
        │   ├── entities/     # Pure Dart business objects (no external deps)
        │   ├── repositories/ # Abstract interfaces
        │   └── usecases/     # Business logic (1 class = 1 use case)
        └── presentation/
            ├── providers/    # @riverpod providers
            ├── screens/      # Screens
            ├── widgets/      # Feature-specific widgets
            └── strings/      # Localized strings
```

### Dependency rule (Clean Architecture)
- `domain/` không được import từ `data/` hay `presentation/`
- `data/` phụ thuộc vào `domain/` (implement interfaces)
- `presentation/` phụ thuộc vào `domain/` (qua providers)
- `datasources/` throw exceptions → `repositories/` catch và trả `Result<T>`

## Naming

| Type | Convention | Example |
|------|-----------|---------|
| File | snake_case | `leave_request_screen.dart` |
| Class | PascalCase | `LeaveRequestScreen` |
| Datasource | PascalCase + Datasource | `AuthDatasource` |
| Repository (impl) | PascalCase + RepositoryImpl | `AuthRepositoryImpl` |
| Repository (interface) | PascalCase + Repository | `AuthRepository` |
| UseCase | PascalCase + UseCase | `SignInUseCase` |
| Provider | camelCase + Provider | `leaveRequestProvider` |
| Notifier | PascalCase + Notifier | `LeaveRequestNotifier` |
| Private | underscore prefix | `_buildHeader()` |
| Constants | camelCase | `AppColors.primary` |

## Riverpod — Code Generation

- Luôn dùng `@riverpod` annotation, không dùng Provider thủ công
- Async data dùng `AsyncNotifier`, sync dùng `Notifier`
- File provider phải có `.g.dart` counterpart (chạy build_runner)

```dart
// ✅ Đúng
@riverpod
class LeaveRequestNotifier extends _$LeaveRequestNotifier {
  @override
  Future<List<LeaveRequest>> build() async {
    return _fetchLeaveRequests();
  }
}

// ❌ Sai
final leaveProvider = StateNotifierProvider(...);
```

## Error Handling — Result Pattern

Dùng `Result<T>` (không dùng Either từ fpdart để tránh overhead):

```dart
// core/errors/result.dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}
```

```dart
// Repository trả về Result
Future<Result<List<LeaveRequest>>> getLeaveRequests();

// Notifier xử lý
final result = await repo.getLeaveRequests();
switch (result) {
  case Success(:final data): state = AsyncData(data);
  case Failure(:final failure): state = AsyncError(failure, StackTrace.current);
}
```

## Failure Classes

```dart
// core/errors/failures.dart
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class NetworkFailure extends AppFailure { ... }
class ServerFailure extends AppFailure { ... }
class UnauthorizedFailure extends AppFailure { ... }
class NotFoundFailure extends AppFailure { ... }
```

## Widgets

- Mỗi widget trong 1 file riêng nếu > 50 lines
- Không dùng `StatefulWidget` nếu có thể dùng `ConsumerWidget`
- **Only extract to separate class if:**
  - Widget được dùng **2+ lần** (duplication) → Extract to class
  - Widget có **logic phức tạp** (> 50 lines) → Extract to class
  - Widget là **reusable component** (dùng trên multiple screens) → Extract to class
  - Ngược lại (simple, one-off UI) → Use helper method `_build*()`

```dart
// ✅ Đúng — Reusable, dùng 2+ lần
class LeaveStatusBadge extends StatelessWidget { ... }

// ✅ Đúng — Simple, one-off UI
Widget _buildSimpleLabel() {
  return Text(title, style: AppTypography.h3);
}

// ❌ Sai — Extract helper method thay vì tạo class cho UI đơn giản
// Tránh boilerplate code không cần thiết
```

## Constants

- Không hardcode string, color, spacing trong widget
- Tất cả dùng qua `AppColors`, `AppSpacing`, `AppTypography`

```dart
// ✅ Đúng
color: AppColors.primary
padding: EdgeInsets.all(AppSpacing.md)

// ❌ Sai
color: Color(0xFF4CAF50)
padding: EdgeInsets.all(16)
```

## Imports

Thứ tự import:
1. dart:
2. package:flutter/
3. package:third_party/
4. package:app/ (relative hoặc absolute)

Dùng absolute import từ `lib/`:
```dart
import 'package:employee_app/core/constants/app_colors.dart';
```

## Strings
- Không hardcode string trực tiếp trong widget
- Tất cả strings dùng qua class `[Feature]Strings`
- Strings viết bằng tiếng Việt
```dart
// ✅ Đúng
class HomeStrings {
  static const title = 'Trang chủ';
  static const greeting = 'Xin chào';
}

Text(HomeStrings.title)

// ❌ Sai
Text('Trang chủ')
```

File đặt tại: `lib/features/[feature]/presentation/strings/[feature]_strings.dart`

## Const Constructors
- Ưu tiên dùng `const` constructor bất cứ khi nào có thể
- Widget không thay đổi runtime phải là `const`
```dart
// ✅ Đúng
const Text(HomeStrings.title)
const SizedBox(height: AppSpacing.md)
const LeaveStatusBadge()

// ❌ Sai
Text(HomeStrings.title)
SizedBox(height: AppSpacing.md)
```
