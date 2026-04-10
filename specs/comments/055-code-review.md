---
GitHub Issue: #55
Issue Title: Add Search Screen
Review Date: 2026-03-27
Type: Code Review (Round 3)
Reviewer: Claude Code
---

## **Code Summary**

Round 3 — reviewing fixes from Round 2. Files changed:

- `search_screen.dart` — padding magic numbers fixed, const issue pending
- `song_tile.dart` — `Colors.white` → `AppColors.text` fixed
- `main_appbar.dart` — formatting + `automaticallyImplyLeading` cleaned up
- `search_notifier.dart` — `result.fold` formatting still pending
- `search_notifier_test.dart` — 700ms debounce wait extracted to local const
- `isar_service.dart` — singleton service (new, unrelated to search)

---

## **✅ Fixed From Round 2**

- `left: 16, right: 16` → `left: AppSpacing.md, right: AppSpacing.md` ✅
- `Colors.white` → `AppColors.text` ✅
- `MainAppbar` formatting — `backgroundColor: Colors.transparent` on one line ✅
- `automaticallyImplyLeading: true` removed ✅
- `700` debounce wait → `const debounceWait = Duration(milliseconds: 700)` with comment ✅
- All 10 tests pass ✅

---

## **🚨 Critical Issues** (Must fix)

### Issue 1: `flutter analyze` — missing `const` constructor
**Location:** `lib/features/search/presentation/screens/search_screen.dart:57`
**Problem:** `MainAppbar(title: AppStrings.navSearch)` should be `const`. Flutter lint `prefer_const_constructors` flags this.
**Rule:** `rules/flutter.md` — "Ưu tiên dùng `const` constructor bất cứ khi nào có thể"
**Fix:**
```dart
// Before
appBar: MainAppbar(title: AppStrings.navSearch),

// After
appBar: const MainAppbar(title: AppStrings.navSearch),
```

---

## **⚠️ Code Quality Issues** (Nice to have)

### Issue 2: `EdgeInsets.only` can be simplified
**Location:** `lib/features/search/presentation/screens/search_screen.dart:61`
**Problem:** `EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md)` — magic numbers are now correct, but `only` with equal left/right is redundant.
**Rule:** `rules/code-style.md` — Avoid dense code, prefer readable expression
**Suggestion:**
```dart
padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
```

### Issue 3: Magic number `60` in `_formatDuration`
**Location:** `lib/features/search/presentation/widgets/song_tile.dart:19`
**Problem:** `duration.inSeconds % 60` uses a raw `60` (seconds-per-minute). It's a domain constant.
**Rule:** `specs/rules/constants.md` — Business logic thresholds must be extracted
**Suggestion:**
```dart
static const int _secondsPerMinute = 60;

final seconds = duration.inSeconds % _secondsPerMinute;
```

### Issue 4: Magic numbers `2` and `1` in `maxLines`
**Location:** `lib/features/search/presentation/widgets/song_tile.dart:45,51`
**Problem:** `maxLines: 2` and `maxLines: 1` are UI dimension constants.
**Rule:** `specs/rules/constants.md` — Dimensions must always be extracted
**Suggestion:**
```dart
static const int _titleMaxLines = 2;
static const int _subtitleMaxLines = 1;
```

### Issue 5: `result.fold` formatting (carried from Round 2)
**Location:** `lib/features/search/presentation/providers/search_notifier.dart:62–65`
**Problem:** Inconsistent callback style — first uses arrow, second uses block with unusual parameter break:
```dart
result.fold((failure) => state = SearchState.error(failure.message), (
  songs,
) {
```
**Rule:** `rules/code-style.md` — Consistent formatting
**Suggestion:**
```dart
result.fold(
  (failure) => state = SearchState.error(failure.message),
  (songs) {
    if (songs.isEmpty) {
      state = SearchState.empty(query);
      return;
    }
    state = switch (searchType) {
      SearchType.search => SearchState.results(songs),
      SearchType.suggestions => SearchState.suggestions(songs),
    };
  },
);
```

### Issue 6: `empty` state shows blank screen (carried from Round 2)
**Location:** `lib/features/search/presentation/screens/search_screen.dart:92`
**Problem:** `empty: (query) => const SizedBox()` shows nothing after a zero-result search.
**Suggestion:** Show a message, or add a `// TODO:` comment if intentionally deferred:
```dart
empty: (query) => Center(child: Text(AppStrings.searchNoResults)),
```

---

## **📊 Code Quality Score**

| Category | Status | Notes |
|----------|--------|-------|
| **Structure** | ✅ | Feature-first Clean Architecture, correct layer separation |
| **Naming** | ✅ | All conventions followed |
| **Riverpod** | ✅ | Notifier pattern correct, ref.watch/read used correctly |
| **Widgets** | ✅ | Well-extracted: SongTile, SongList, SuggestionDropdown, _ErrorView |
| **Constants** | ⚠️ | `% 60`, `maxLines: 2/1` — minor dimension extractions missing |
| **Magic Numbers** | ⚠️ | 3 minor (% 60, maxLines 2, maxLines 1) |
| **Strings** | ✅ | AppStrings used throughout |
| **Imports** | ✅ | Clean, no unused imports |
| **flutter analyze** | ❌ | 1 info: `prefer_const_constructors` at search_screen.dart:57 |
| **Tests** | ✅ | 10/10 passing, all methods covered, fixtures extracted |

**Overall: 8.5/10**

---

## **📋 Rule Compliance**

✅ Follows: `specs/rules/state-management.md`
✅ Follows: `specs/rules/folder-structure.md`
✅ Follows: `specs/rules/testing.md`
❌ Violates: `rules/flutter.md` — missing `const` constructor (critical, blocks merge)
⚠️ Minor: `specs/rules/constants.md` — `% 60`, `maxLines` not extracted
⚠️ Minor: `rules/code-style.md` — `result.fold` formatting inconsistent

---

## **✍️ Action Items**

- [ ] **Fix:** Add `const` to `MainAppbar(...)` in `search_screen.dart:57` → unblocks flutter analyze
- [ ] Nice: `EdgeInsets.only(left:, right:)` → `EdgeInsets.symmetric(horizontal:)` in `search_screen.dart:61`
- [ ] Nice: Extract `_secondsPerMinute = 60` in `song_tile.dart:19`
- [ ] Nice: Extract `_titleMaxLines = 2`, `_subtitleMaxLines = 1` in `song_tile.dart:45,51`
- [ ] Nice: Fix `result.fold` formatting in `search_notifier.dart:62`
- [ ] Nice: Handle `empty` state with visible feedback in `search_screen.dart:92`

---

## **Status**

- [x] NEEDS_FIX — `flutter analyze` has 1 lint info (const constructor)
- [ ] READY_TO_MERGE
