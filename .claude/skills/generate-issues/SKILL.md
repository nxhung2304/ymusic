---
allowed-tools: Grep, Bash(touch:*), Bash(mkdir -p *), Bash(mkdir:*), Read, Edit, Write
description: Create issues from specs/story.md file. Use when use ask "Generate issues, generate issue [number].[title]"
---

## Mục đích
Đọc file `specs/story.md`, tạo ra file story riêng cho từng task trong thư mục `specs/issues/`.
Mỗi story là roadmap chi tiết của 1 task — dev review và đổi status thành `approved` trước khi implement.

---

## Các bước thực hiện

### 1. Đọc source file
```
Đọc: specs/story.md
```
- Parse từng task theo format: `- [ ] [number]. [title]`
- Xác định number, title, labels cho mỗi task

### 2. Chuẩn bị thư mục
```bash
mkdir -p specs/issues
```

### 3. Với mỗi task → tạo file story

**Tên file:** `specs/issues/[number]-[slug-title].md`

Ví dụ:
```
001-project-setup-clone-template.md
002-ui-login-screen.md
```

**Slug rule:** lowercase, replace space → `-`, bỏ ký tự đặc biệt

### 4. Nội dung mỗi file — theo template.md

### 5. Sau khi tạo xong tất cả

In ra summary:
```
✅ Đã tạo [X] issues tại specs/issues/
...

→ Review từng file, đổi status: pending → approved để bắt đầu implement
```

---
## Wireframe mapping

Đọc file `specs/design-mapping.md` trong project hiện tại để lấy mapping keyword → screen.

- Nếu file **tồn tại** → match title/description của task với cột Keywords → điền screen name vào section **Design** của issue file.
- Nếu file **không tồn tại** → ghi `N/A` vào section Design.
- Nếu task keyword **không match** bất kỳ dòng nào trong mapping → ghi `N/A`.
- Mỗi project có `design-mapping.md` riêng — SKILL không hardcode bất kỳ mapping nào.

---

## Quy tắc quan trọng

- **KHÔNG** tự implement — chỉ tạo file story
- Status luôn là `pending` — dev tự đổi thành `approved`
- Mỗi task = 1 file riêng, không gộp
- Nếu file đã tồn tại → skip, không overwrite
