# Clean Code Principles

## Table of Contents
1. [Magic Numbers](#magic-numbers)
2. [Hardcoded Strings](#hardcoded-strings)
3. [Return Early](#return-early)
4. [Avoid Deep Nesting](#avoid-deep-nesting)
5. [Meaningful Names](#meaningful-names)
6. [One Responsibility](#one-responsibility)
7. [DRY (Don't Repeat Yourself)](#dry-dont-repeat-yourself)
8. [Checklist](#checklist-before-committing)

---

## Magic Numbers

❌ **NEVER** use magic numbers in code:

```dart
// ❌ Bad
if (status.length > 5) { ... }
if (age >= 18) { ... }
if (retryCount < 3) { ... }
```

✅ **ALWAYS** extract to named constants:

```dart
// ✅ Good
const int maxStatusLength = 5;
const int legalAdultAge = 18;
const int maxRetries = 3;

if (status.length > maxStatusLength) { ... }
if (age >= legalAdultAge) { ... }
if (retryCount < maxRetries) { ... }
```

**Why?**
- Makes code self-documenting
- Easy to change values in one place
- Avoids scattered magic numbers

---

## Hardcoded Strings

❌ **NEVER** hardcode strings in widgets:

```dart
// ❌ Bad
Text('Xin chào')
Text('Đã nhập')
Text('Tháng 1')
debugPrint('Error occurred');
```

✅ **ALWAYS** use String constants class:

```dart
// ✅ Good - in lib/core/widgets/calendar/calendar_strings.dart
class CalendarStrings {
  static const greeting = 'Xin chào';
  static const submitted = 'Đã nhập';
  static const january = 'Tháng 1';
}

// In widget:
Text(CalendarStrings.greeting)
Text(CalendarStrings.submitted)
Text(CalendarStrings.monthNames[0])
```

**String file locations:**
- Calendar strings → `lib/core/widgets/calendar/calendar_strings.dart`
- Feature strings → `lib/features/[feature]/presentation/strings/[feature]_strings.dart`
- Navigation strings → `lib/core/strings/navigation_strings.dart`

**Example structure:**
```dart
// lib/features/leave_request/presentation/strings/leave_strings.dart
class LeaveStrings {
  static const title = 'Xin Nghỉ';
  static const pending = 'Đang chờ';
  static const approved = 'Phê duyệt';
  static const rejected = 'Từ chối';
  static const reason = 'Lý do';

  static String approvalDate(DateTime date) => 'Ngày duyệt: ${date.toString()}';
}
```

---

## Return Early

❌ **AVOID** deep nesting with multiple conditions:

```dart
// ❌ Bad - hard to read, many levels deep
Future<void> processData(String id) async {
  if (id.isNotEmpty) {
    final data = await fetchData(id);
    if (data != null) {
      final result = await validateData(data);
      if (result.isSuccess) {
        await sendToServer(result);
        showSuccess();
      } else {
        showError('Validation failed');
      }
    } else {
      showError('No data');
    }
  } else {
    showError('Empty ID');
  }
}
```

✅ **USE** return early pattern (guard clauses):

```dart
// ✅ Good - clear and flat
Future<void> processData(String id) async {
  // Guard clause 1: Validate input
  if (id.isEmpty) {
    return showError('Empty ID');
  }

  // Guard clause 2: Fetch data
  final data = await fetchData(id);
  if (data == null) {
    return showError('No data');
  }

  // Guard clause 3: Validate data
  final result = await validateData(data);
  if (!result.isSuccess) {
    return showError('Validation failed');
  }

  // Happy path: all checks passed
  await sendToServer(result);
  showSuccess();
}
```

**Pattern:**
1. Check invalid conditions first (guard clauses)
2. Return/exit early if condition fails
3. Main logic at the end (happy path)

**Benefits:**
- Easier to understand flow
- Fewer nested braces
- Less cognitive load
- Guards handle edge cases first

---

## Avoid Deep Nesting

❌ **AVOID** nesting deeper than 3 levels:

```dart
// ❌ Bad - 4 levels deep
if (condition1) {
  if (condition2) {
    if (condition3) {
      if (condition4) {
        doSomething();
      }
    }
  }
}
```

✅ **USE** multiple strategies:

**Strategy 1: Early returns**
```dart
// ✅ Good - flat structure
if (!condition1) return;
if (!condition2) return;
if (!condition3) return;
if (!condition4) return;
doSomething();
```

**Strategy 2: Extract method**
```dart
// ✅ Good - extract to helper
if (isValidAndReady()) {
  doSomething();
}

bool isValidAndReady() {
  return condition1 && condition2 && condition3 && condition4;
}
```

**Strategy 3: Ternary (for simple cases)**
```dart
// ✅ Good - simple conditional
final status = isValid ? 'Success' : 'Error';
return isActive ? activeWidget() : inactiveWidget();
```

**Nesting levels guide:**
- Level 1-2: ✅ Acceptable
- Level 3: ⚠️ Consider refactoring
- Level 4+: ❌ Must refactor

---

## Meaningful Names

❌ **AVOID** unclear, abbreviated names:

```dart
// ❌ Bad
final d = DateTime.now();
final x = user.age;
void process() { ... }
Future getD() async { ... }
final tmp = calculateValue();
var obj = MyClass();
```

✅ **USE** clear, descriptive names:

```dart
// ✅ Good
final currentDate = DateTime.now();
final userAge = user.age;
void validateAndSubmitForm() { ... }
Future<LeaveRequest> fetchLeaveRequestData() async { ... }
final calculatedSalary = calculateMonthlySalary();
var userPreferences = UserPreferences();
```

**Naming rules:**

| Type | Convention | Example |
|------|-----------|---------|
| Variables | Noun, what they contain | `userData`, `errorMessage`, `buttonColor` |
| Methods | Verb, what they do | `validateEmail()`, `fetchData()`, `buildHeader()` |
| Booleans | Yes/no questions | `isValid`, `hasPermission`, `canDelete`, `isLoading` |
| Constants | Descriptive noun | `maxRetries`, `defaultTimeout`, `minPasswordLength` |

**Avoid these:**
- ❌ Single letters: `d`, `x`, `i` (except loop counters: `for (int i = 0; ...)`)
- ❌ Abbreviations: `usr`, `pwd`, `tmp`, `val`
- ❌ Generic names: `data`, `value`, `object`, `temp`, `stuff`
- ❌ Numbers: `value1`, `value2` (use descriptive names instead)

---

## One Responsibility

❌ **AVOID** methods doing multiple unrelated things:

```dart
// ❌ Bad - does 4 things (violates Single Responsibility)
void saveUser() {
  validateInput();           // 1. Validate
  final user = parseData();  // 2. Parse
  sendToServer(user);        // 3. Send
  updateUI();                // 4. Update UI
}
```

✅ **SPLIT** into focused methods:

```dart
// ✅ Good - each method has 1 responsibility
void saveUser() {
  _validateInput();
  final user = _parseUserData();
  _sendToServer(user);
  _updateUI();
}

void _validateInput() { /* validation only */ }
User _parseUserData() { /* parsing only */ }
Future<void> _sendToServer(User user) { /* network only */ }
void _updateUI() { /* UI update only */ }
```

**Or use the repository pattern:**
```dart
// ✅ Better - separation of concerns
void saveUser() async {
  final result = await userRepository.saveUser(userData);

  switch (result) {
    case Success(:final data):
      _updateUI(data);
      showSuccess();
    case Failure(:final failure):
      showError(failure.message);
  }
}
```

**Benefits:**
- Easier to test
- Easier to reuse
- Easier to maintain
- Easier to understand

---

## DRY (Don't Repeat Yourself)

❌ **AVOID** copying the same code:

```dart
// ❌ Bad - validation duplicated in 2 places
void createLeaveRequest() {
  if (startDate.isEmpty) return showError('Start date required');
  if (endDate.isEmpty) return showError('End date required');
  if (reason.isEmpty) return showError('Reason required');
  // ... create request
}

void createOTRequest() {
  if (startDate.isEmpty) return showError('Start date required');
  if (endDate.isEmpty) return showError('End date required');
  if (reason.isEmpty) return showError('Reason required');
  // ... create request
}
```

✅ **EXTRACT** common logic to reusable function:

```dart
// ✅ Good - validation reused
bool _validateDates(String startDate, String endDate, String reason) {
  if (startDate.isEmpty) {
    showError('Start date required');
    return false;
  }
  if (endDate.isEmpty) {
    showError('End date required');
    return false;
  }
  if (reason.isEmpty) {
    showError('Reason required');
    return false;
  }
  return true;
}

void createLeaveRequest() {
  if (!_validateDates(startDate, endDate, reason)) return;
  // ... create request
}

void createOTRequest() {
  if (!_validateDates(startDate, endDate, reason)) return;
  // ... create request
}
```

**When to extract:**
- ✅ Same code appears 2+ times
- ✅ Complex logic used in multiple places
- ✅ Logic that might change (update once)

**Where to put shared logic:**
- Widget logic → Extract to method in same class
- Feature logic → Extract to helper class or extension
- App-wide logic → Move to `lib/core/utils/` or repository

