---
allowed-tools: Bash(gh pr:*), Bash(flutter:*), Bash(git:*), Read, Write, Edit, Grep, mcp__github__get_pull_request, mcp__github__create_pull_request_review
description: Implement approved changes from PR review feedback. Use when user asks "handle PR review, implement PR feedback"
---

## Mục đích
Đọc approved feedback từ `specs/comments/[ISSUE-NUMBER].md`, implement changes vào code **Yêu cầu user approval trước khi push.**

---

## Điều kiện tiên quyết

1. ✓ `specs/comments/[ISSUE-NUMBER].md` tồn tại
2. ✓ `Status: Approved` đã được user set
3. ✓ Đang ở trên feature branch (feature/hung-11-*)
4. ✓ `specs/issues/[ISSUE-NUMBER].md` tồn tại (tham khảo spec gốc)
5. ✓ Code đã được pull latest từ remote
6. Read code rules in files:
   - specs/rules/clean-code.md
   - specs/rules/coding.md
   - specs/rules/design.md
   - specs/rules/flutter.md

---

## Các bước thực hiện

### 1. Xác định issue number
```bash
# Từ current branch: feature/hung-11-calendar-widget
# → Issue number: 11
git branch --show-current | grep -oP 'hung-\K\d+'
```

---

### 2. Pre-flight checks

**Check 1**: File specs/comments/011-calendar-widget.md tồn tại?
```bash
if [ ! -f "specs/comments/011-calendar-widget.md" ]; then
  echo "❌ specs/comments/011-calendar-widget.md not found"
  exit 1
fi
```

**Check 2**: Status = Approved?
```bash
STATUS=$(grep "^Status:" specs/comments/011-calendar-widget.md | sed 's/Status: //')

if [ "$STATUS" != "Approved" ]; then
  echo "❌ Status is '$STATUS', not 'Approved'"
  echo "Please review and set Status: Approved in specs/comments/011-calendar-widget.md"
  exit 1
fi
```

**Check 3**: Current branch is feature branch?
```bash
BRANCH=$(git branch --show-current)
if [[ ! $BRANCH =~ ^feature/hung- ]]; then
  echo "❌ Not on feature branch: $BRANCH"
  exit 1
fi
```

---

### 3. Read feedback & original spec

**File 1**: `specs/comments/011-calendar-widget.md`
- Extract section: "## **Suggested Implementation Actions**"
- Parse all action items (Critical, Important, Nice-to-have)

**File 2**: `specs/issues/011-calendar-widget.md` (reference)
- Cross-check actions against original spec
- Ensure no out-of-scope changes

---

### 4. Implement changes

**Flow per action item**:

```
FOR EACH action item (in priority order):
  a) Understand the change requirement
  b) Cross-check: spec-compliant? Not out-of-scope?
  c) Implement code change
  d) Stage the file: git add [file]
  f) After each change:
     - Run: flutter analyze
     - If errors/warnings → FIX BEFORE CONTINUING
     - If UI change: Consider running flutter test
```

---

### 5. Quality checks (per change)

After implementing each action or group of actions:

```bash
# Check 1: Linting
flutter analyze
# Must pass with 0 warnings, 0 errors

# Check 2: Tests (if affected files have tests)
flutter test
# All tests must pass
```

---

## Quy tắc quan trọng

- **MUST**: Pass quality checks (flutter analyze 0 warnings)
- **MUST**: All tests pass (if applicable)
- **MUST**: Implement only approved actions from specs/comments
- **CANNOT**: Skip quality checks
- **CANNOT**: Out-of-scope changes
- **Manual**: User pushes, updates PR comments, and updates specs/comments status

---

## Xử lý lỗi

| Lỗi | Xử lý |
|-----|-------|
| specs/comments file không tồn tại | Dừng, nhắc user chạy `/analytic-pr-review` trước |
| Status ≠ Approved | Dừng, thông báo user: "Set Status: Approved first" |
| Not on feature branch | Dừng, hỏi user checkout feature branch |
| Spec ambiguity | Dừng, hỏi user — không tự assume |
| Out-of-scope change | Dừng, thông báo: "This is not in PR feedback" |
| git push fails | Dừng, hỏi user (conflict? permission?) |

---

## Workflow Diagram

```
specs/comments/011-calendar-widget.md
            ↓
        [Pre-flight checks]
            ↓
    [Read approved feedback]
            ↓
    [Read original spec]
            ↓
    [Implement changes → Quality checks]
```

---

## Example Scenario

### Given
- Issue #11: Calendar Widget
- PR #42 has 3 reviewer comments
- User ran `/analytic-pr-review`, created specs/comments/011-calendar-widget.md
- User set Status: Approved

### When
User runs: `/handle-pr-review`

### Then
1. Check Status = Approved ✓
2. Extract actions: const constructors, extract widget, update styling
3. Implement change 1: Add const constructors

**User then manually**:
- `git push origin feature/hung-11-calendar-widget`
- Add PR comment
- Update specs/comments Status if needed

---

## Notes

- **Testing**: If changes affect logic, run tests to ensure no regression
- **PR updates**: GitHub auto-updates when you push; no need to manually edit PR
- **User approval**: Required before push to prevent accidental pushes
- **Manual Slack**: User notifies reviewer manually via Slack (not auto)
