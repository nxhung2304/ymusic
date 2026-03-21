# Constants & Magic Numbers Rule

## Overview

This rule defines when to extract magic numbers/strings and when it's acceptable to inline them.

---

## When to ALWAYS Extract

### 1. Dimensions & Spacing
```dart
// ❌ BAD
padding: EdgeInsets.only(bottom: 28, top: 10),
width: 64,
height: 32,
borderRadius: 20,
fontSize: 12,

// ✅ GOOD
const double _navBarPaddingBottom = 28;
const double _tabItemWidth = 64;
const double _tabItemHeight = 32;
const double _tabItemBorderRadius = 20;
```

**Why:**
- Reused across multiple widgets
- Easy to adjust design in one place
- Improves maintainability

### 2. Reusable Values (used 2+ times)
```dart
// ❌ BAD
if (items.length > 5) { }
// ... later ...
if (otherList.length > 5) { }

// ✅ GOOD
const int maxItemsPerPage = 5;
if (items.length > maxItemsPerPage) { }
if (otherList.length > maxItemsPerPage) { }
```

**Why:** Single source of truth, easier to update

### 3. User-facing Strings
Always use `AppStrings` 

```dart
// ❌ BAD
label: 'Home',
Text('Search'),

// ✅ GOOD
label: AppStrings.navHome,
Text(AppStrings.navSearch),
```

### 4. Colors
Always use `AppColors` constants

```dart
// ❌ BAD
color: Color(0xFF4CAF50),

// ✅ GOOD
color: AppColors.primary,
```

---

## When to CONSIDER Context

### Sequential UI Indices (0, 1, 2)

Three approaches, choose based on context:

#### Approach 1: Use Enum (Most Type-Safe) ⭐ RECOMMENDED
```dart
enum NavTab {
  home(0),
  search(1),
  library(2);

  final int index;
  const NavTab(this.index);
}

// Usage:
isActive: selectedIndex == NavTab.home.index,
onTap: () => _onTabTapped(NavTab.home.index),
```

**When to use:**
- Tab/page order might change
- Need type safety
- Used in 3+ places
- Want to prevent invalid indices

#### Approach 2: Use Constants
```dart
static const int _tabIndexHome = 0;
static const int _tabIndexSearch = 1;
static const int _tabIndexLibrary = 2;

// Usage:
isActive: selectedIndex == _tabIndexHome,
```

**When to use:**
- Need constants per clean-code rules
- Small number of indices
- Order unlikely to change

#### Approach 3: Use Inline (0, 1, 2)
```dart
case 0: return HomeScreen();
isActive: selectedIndex == 0,
```

**When to use:**
- Only used 1-2 places
- Obvious from context (clearly a tab index)
- Never changes
- Simplicity preferred

---

## When it's OK to INLINE

### Loop Counters
```dart
for (int i = 0; i < items.length; i++) { }  // ✓ Acceptable
```

### Single-Use Array Indices
```dart
final first = items[0];  // ✓ If only used here
```

### Obvious One-Off Values
```dart
duration: Duration(milliseconds: 300),  // Depends on context
if (count > 0) { }  // ✓ Self-explanatory zero
```

---

## Decision Tree

```
Is it a magic number/string?

├─ Used 2+ times?
│  └─ YES → Extract to constant ✓
│
├─ Dimension/spacing (padding, width, height, borderRadius, fontSize)?
│  └─ YES → Extract to constant ✓
│
├─ User-facing text?
│  └─ YES → Extract to AppStrings ✓
│
├─ Color value?
│  └─ YES → Extract to AppColors ✓
│
├─ Sequential index (0, 1, 2)?
│  ├─ Order might change? → Use enum ⭐
│  ├─ Rarely changes? → Use constant or inline
│  └─ One-off use? → Inline is fine
│
├─ Loop counter or array index?
│  └─ In tight loop context? → Inline is OK
│
└─ Threshold/timeout/business logic?
   └─ YES → Extract to named constant ✓
```

---

## Naming Conventions

### File-level Constants (private)
```dart
static const double _tabItemWidth = 64;
static const int _maxRetries = 3;
```

### Class Constants
```dart
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
}

class AppStrings {
  static const String navHome = "Home";
}
```

### Enums for Multiple Related Values
```dart
enum NavTab {
  home(0),
  search(1),
  library(2);

  final int index;
  const NavTab(this.index);
}
```

---

## Examples

### ✅ GOOD — Follows Rule
```dart
// Dimensions extracted
const double _buttonPadding = 16;
const double _borderRadius = 8;

// Strings in AppStrings
Text(AppStrings.navHome)

// Colors in AppColors
Container(color: AppColors.primary)

// Sequential indices as enum
enum PageIndex { home(0), search(1) }
pageIndex: PageIndex.home.index
```

### ❌ BAD — Violates Rule
```dart
// Magic numbers scattered
padding: EdgeInsets.all(16),
borderRadius: BorderRadius.circular(8),

// Hardcoded strings
Text('Home')

// Hardcoded colors
Container(color: Color(0xFF4CAF50))

// Magic indices repeated
if (index == 0) { }
// ... later ...
if (index == 0) { }
```

---

## Checklist Before Committing

- [ ] No hardcoded colors (use AppColors)
- [ ] No hardcoded strings (use AppStrings)
- [ ] No repeated magic numbers (extract if 2+ uses)
- [ ] All dimensions/spacing use constants
- [ ] Sequential indices use enum or constants (not scattered 0,1,2)
- [ ] Business logic thresholds extracted and named

---

## Summary

| Category | Extract? | Approach |
|----------|----------|----------|
| **Dimensions** | ✅ Always | Constants (AppSpacing, file-level) |
| **Strings** | ✅ Always | AppStrings |
| **Colors** | ✅ Always | AppColors |
| **Reused values** | ✅ Always | Constants (named) |
| **Sequential indices** | ⚠️ Consider | Enum (preferred), Constants, or Inline |
| **Loop counters** | ❌ No | Inline (i, j in for loops) |
| **Single-use obvious** | ❌ No | Inline is OK |
| **Business thresholds** | ✅ Always | Named constants |

