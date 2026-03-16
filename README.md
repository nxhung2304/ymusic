# ymusic - Coworker with Claude Code

- Tự code: business logic, state management, data sync, stream handling
- Claude: UI scaffolding, boilerplate, package integration code

## 0. Tool Stack & MCP Setup (bắt buộc 1 lần)
- **Core**: Claude Code (main agent) + Pencil.dev (design canvas in codebase)
- **MCP đã connect**: Pencil (design), GitHub (repo management)
- **MCP recommend thêm** (connect ngay để vibe full):
  - Playwright MCP → test browser tự động
  - Coolify MCP hoặc Vercel MCP → deploy 1 lệnh
  - GitHub MCP → tạo branch, PR tự động
- Command connect ví dụ:
```
claude mcp add playwright npx playwright-mcp@latest
claude mcp add coolify npx @masonator/coolify-mcp
```

## 1. PRD (Product Requirements Document)
- Mô tả ý tưởng chi tiết: mục tiêu app, user persona (người Việt yêu nhạc), nền tảng (iOS), features chính, success metrics.
- Prompt Claude: `/create-prd` hoặc dùng plugin prd-generator.
- Grok review: “Đánh giá thực tiễn PRD này với web_search về YouTube Music competitor 2026”.

## 2. Story & Planning (từ PRD → Task + Architecture)
- Chuyển PRD thành User Stories + Task list (dùng Plan mode của Claude).
- Vẽ architecture (React Native/Flutter + backend nếu cần).
- Prompt Claude: “Plan mode: Break this PRD into tasks + tech stack”.
- Grok đánh giá thực tiễn: “Tìm trên web xem stack này có overkill cho solo dev không?”.
### 2.1 Vấn đề gặp phải
"horizontal slice" — xây toàn bộ data layer trước, rồi mới làm feature
- Rủi ro
  - Models sai sớm, sửa muộn — blast radius lớn
  - Không có feedback loop
  - Over-engineering
- Cách giải quyết
  - Chuyển qua Vertical Slice - build theo feature slice hoàn chỉnh

## 3. Design (Pencil.dev)
- Chuẩn bị: Cho Claude đọc PRD + Story → hỏi cách prompt tối ưu cho Pencil.
- Tạo Design System + tất cả screens (iPhone + iPad adaptive).
- **Vibe Check với Grok**: Paste screenshot hoặc mô tả → “Review design này có giống YouTube Music vibe không? Gợi ý cải thiện”.

**Prompt mẫu khi yêu cầu Claude design:**
```
Use Pencil MCP to create specs/designs/<app-name>.pen.

Design system: [màu nền, accent, font, spacing...]
Platform: iOS

Screens to design:
- <Tên Screen 1>: [mô tả ngắn]
- <Tên Screen 2>: [mô tả ngắn]
- ...

Naming convention (bắt buộc để tương thích design-mapping.md):
- Mỗi frame/screen đặt tên rõ ràng, đúng với tên trong danh sách trên
- Sub-screens dùng format: “<Screen> - <Tab>”  (ví dụ: “Library - Liked Songs Tab”)
- Components dùng PascalCase  (ví dụ: “SongTile”, “MiniPlayer”)
- Tổ chức canvas theo rows có label, mỗi row là 1 nhóm chức năng
```

> Lý do cần naming convention: `specs/design-mapping.md` dùng tên screen này làm key để link vào issue file.
> Nếu tên screen trong .pen khác với mapping → dev không biết design nào cần xem khi implement.

## 3.5 Design Mapping (link design → issue)
Sau khi design xong, tạo file `specs/design-mapping.md` để skill `generate-issues` tự động điền đúng screen reference vào mỗi issue file.

```md
# Design Mapping
> File design: `specs/designs/<tên-file>.pen` (mở bằng Pencil MCP)

| Keywords                        | Screen trong .pen         |
|---------------------------------|---------------------------|
| login, auth screen              | Login Screen              |
| home, recently played           | Home Screen               |
| search, results                 | Search Screen             |
| ...                             | ...                       |
```

**Quy tắc:**
- Keywords khớp với title/description trong `specs/story.md`
- Mỗi project có 1 file `design-mapping.md` riêng — skill `generate-issues` đọc file này tự động
- Task không có UI (setup, service, config) → ghi `N/A` trong bảng hoặc bỏ qua

## 4. Vibe Coding / Implementation (Core của vibe coding)
- Export design từ Pencil → Claude generate code (React Native/Tailwind/SwiftUI).
- Multi-file edits, component reusable (SongTile, MiniPlayer...).
- Prompt: “Implement Home Screen từ Pencil design này, dùng auto-layout và glassmorphism”.
- Git branch + commit tự động qua GitHub MCP.

## 5. Testing & QA
- Chạy Playwright MCP: “Test full flow login → play song → queue”.
- TDD mode của Claude (Red-Green-Refactor).
- Browser QA tự động + accessibility check.
- Grok review: “Tìm bug phổ biến của music app trên iOS 2026”.

## 6. Deployment
- Deploy 1 lệnh qua Coolify/Vercel MCP: “Deploy latest version to production”.
- Setup CI/CD (GitHub Actions + Claude tự fix nếu fail).
- Monitor logs realtime trong Claude.

## 7. Iteration & Vibe Check (vòng lặp chính)
- Sau mỗi feature: Prompt Claude “Review & suggest improvements”.
- Grok làm “real-world auditor”: Dùng web_search đánh giá tính năng có thực tế không (ví dụ: “offline download như YouTube Music 2026 ra sao?”).
- User testing (bạn tự dùng hoặc share beta).
- Update PRD/Design/Code → quay lại bước 3-6.

## 8. Documentation & Launch
- Auto generate docs từ Pencil + code (README, API nếu có).
- Create PR tự động, changelog.
- Launch: App Store / Play Store / Web + marketing vibe.
