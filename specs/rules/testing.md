# Testing Rules

Rules áp dụng cho **tất cả test files** trong project.
Test code phải tuân thủ clean-code rules như production code — không có ngoại lệ.

---

## Stack

- `flutter_test` — unit & widget tests
- `fake_cloud_firestore` — Firestore tests (không dùng mock, không cần emulator)
- `riverpod_test` — provider/notifier tests (khi cần)

---

## File Structure

Mirror `lib/` trong `test/`:

```
lib/core/services/firestore_service.dart
→ test/core/services/firestore_service_test.dart

lib/features/auth/data/datasources/auth_datasource.dart
→ test/features/auth/data/datasources/auth_datasource_test.dart
```

---

## Test Fixtures — DRY bắt buộc

Mọi literal lặp **hơn 1 lần** trong test file PHẢI extract thành top-level constant.

❌ Bad

```dart
test('a', () async {
  await service.setDocument('users/u1', {'name': 'Alice'});
  expect(result, {'name': 'Alice'});
});

test('b', () async {
  await fakeFirestore.doc('users/u1').set({'name': 'Alice'});
});
```

✅ Good

```dart
const _userDoc = 'users/u1';
const _alice = {'name': 'Alice'};

test('a', () async {
  await service.setDocument(_userDoc, _alice);
  expect(result, _alice);
});

test('b', () async {
  await fakeFirestore.doc(_userDoc).set(_alice);
});
```

Quy tắc đặt tên fixture: prefix `_` (private), lowercase, mô tả rõ nội dung.

---

## Coverage Minimum

Mỗi public method phải có:

| Case | Bắt buộc |
|---|---|
| Happy path | ✅ |
| Edge case (empty / null / not found) | ✅ |
| Exception path | ✅ nếu method có try-catch |

---

## Cấu trúc test

```dart
group('methodName', () {
  test('mô tả kết quả mong đợi', () async {
    // arrange
    // act
    // assert
  });
});
```

- Tên test dùng dạng: **"does something when condition"** hoặc **"returns X when Y"**
- Không dùng: `test1`, `testA`, `happy path`

---

## setUp / tearDown

Dùng `setUp` để khởi tạo dependency, không lặp trong từng test.

```dart
late FakeFirebaseFirestore fakeFirestore;
late FirestoreService service;

setUp(() {
  fakeFirestore = FakeFirebaseFirestore();
  service = FirestoreService(firestore: fakeFirestore);
});
```

---

## Quy tắc chung

1. **Test code = production code** — DRY, meaningful names, no magic strings
2. **Không commit nếu test fail** — `flutter test` phải pass trước khi push
3. **Mỗi `[🤖]` item trong story.md PHẢI có test đi kèm trong cùng PR**
4. **Không test implementation detail** — test behavior, không test internal state
5. **Một `test()` = một assertion chính** — tránh assert nhiều thứ không liên quan
