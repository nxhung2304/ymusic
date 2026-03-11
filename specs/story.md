# YMusic Implementation Stories

> Break down into GitHub issues following this order. Each story has dependencies noted.

---

## Phase 1: Project Setup

**1.1** – Tạo Flutter project + cấu hình folder structure
*(1.2 đã bỏ — dependencies thêm theo từng phase)*
**1.3** – Tạo `constants.dart` (colors, endpoints, strings)
**1.4** – Setup ThemeData (dark mode) + MaterialApp
**1.5** – Config Firebase (google-services.json, Info.plist, `firebase_options.dart`)
**1.6** – Setup `flutter_dotenv` + file `.env` cho API keys

> **Lưu ý:** Không thêm package trước. Mỗi phase tự thêm package cần thiết khi bắt đầu làm.

---

## Phase 2: Authentication

> **Packages cần thêm:** `google_sign_in`, `firebase_auth`, `firebase_core`, `flutter_riverpod`, `riverpod_annotation`, `go_router` | dev: `build_runner`, `riverpod_generator`

**2.1** – Tạo `AuthService` (login/logout/getCurrentUser)
**2.2** – Tạo Riverpod `authProvider` + `authStateProvider`
**2.3** – Build `LoginScreen` UI (Google Sign In button)
**2.4** – Build `SplashScreen` (check session → redirect)
**2.5** – Xử lý lỗi sign-in (SnackBar, loading state)

---

## Phase 3: Firestore + Isar

> **Packages cần thêm:** `cloud_firestore`, `isar`, `isar_flutter_libs`, `dio` | dev: `isar_generator`

**3.1** – Tạo model `Song` (fromJson/toJson)
**3.2** – Tạo model `Playlist`, `UserPreference`, `History`
**3.3** – Tạo `FirestoreService` (generic CRUD methods)
**3.4** – Tạo `PlaylistRepository` (wraps FirestoreService)
**3.4b** – Tạo `LikedSongsRepository` (add/remove/list liked songs, sync Firestore)
**3.4c** – Tạo `HistoryRepository` (append/list/clear history, sync Firestore)
**3.5** – Tạo `UserRepository` (profile, preferences)
**3.6** – Viết Firestore Security Rules
**3.7** – Setup Isar schema (mirror các model trên)
**3.8** – Tạo `IsarService` (open DB, CRUD local)

---

## Phase 4: YouTube Service

> **Packages cần thêm:** `youtube_explode_dart`

**4.1** – Tạo `YouTubeService.search()` dùng YouTube Data API v3
**4.2** – Parse response → `SongModel` list
**4.3** – Tạo `YouTubeService.extractAudioUrl()` dùng `youtube_explode_dart`
**4.4** – Xử lý quota error + fallback sang `youtube_explode`
**4.5** – Cache search results vào Isar (TTL 24h)

---

## Phase 5: Audio Player

> **Packages cần thêm:** `just_audio`, `audio_service`

**5.1** – Setup `just_audio` player instance + `AudioPlayerService` class
**5.2** – Implement play/pause/seek/stop
**5.3** – Implement next/previous
**5.4** – Integrate `audio_service` cho background playback
**5.5** – Setup iOS background modes (Info.plist `UIBackgroundModes: audio`, Xcode entitlement)
**5.6** – Build lock screen / notification controls handler
**5.7** – Tạo Riverpod `playerStateProvider`
**5.8** – Retry logic khi stream lỗi

---

## Phase 6: Player UI

> **Packages cần thêm:** `cached_network_image`

**6.1** – Tạo `MiniPlayerBar` widget (thumbnail + title + play/pause)
**6.2** – Tạo `FullPlayerScreen` scaffold + tab bar (Player / Lyrics / Queue)
**6.3** – Build Player tab: album art, title, artist
**6.4** – Build seek slider + thời gian
**6.5** – Hiệu ứng glassmorphism/blur background
**6.6** – Animation transition mini → full player
**6.7** – Swipe-to-dismiss full player

---

## Phase 7: Home Screen

**7.0** – Build `AppShell` + `BottomNavigationBar` (Home / Search / Library) + setup `AppRouter`
**7.1** – Tạo `HomeScreen` layout
**7.2** – Tạo `RecentlyPlayedRepository` (Firestore query)
**7.3** – Build `SongTile` widget (thumbnail, title, artist)
**7.4** – Hiển thị danh sách recently played
**7.5** – Cập nhật history khi play song
**7.6** – Pull-to-refresh

---

## Phase 8: Search Screen

**8.1** – Tạo `SearchScreen` UI + search bar
**8.2** – Debounce input 500ms
**8.3** – Hiển thị kết quả search (list `SongTile`)
**8.4** – Tap kết quả → play + add to queue
**8.5** – Lưu/xóa search history local

---

## Phase 9: Queue & Playback Modes

**9.1** – Tạo `QueueProvider` (Riverpod, in-memory)
**9.2** – Logic add/remove/reorder queue
**9.3** – Build Queue tab UI trong FullPlayerScreen (drag-to-reorder)
**9.4** – Implement shuffle mode (ON/OFF)
**9.5** – Implement repeat mode (OFF / ONE / ALL)
**9.6** – Next/previous theo queue rules

---

## Phase 10: Library Screen

**10.1** – Tạo `LibraryScreen` với TabBar (Liked / History / Playlists / Downloads)
**10.2** – Tab Liked Songs (sync Firestore, heart icon)
**10.3** – Tab History (ordered by `playedAt DESC`)
**10.4** – Tab Playlists + `PlaylistDetailScreen`
**10.5** – UI tạo playlist mới
**10.6** – Dialog thêm song vào playlist
**10.7** – Tab Downloaded (query Isar)

---

## Phase 11: Lyrics

**11.1** – Tạo `LyricsService` (gọi lrclib.net API)
**11.2** – Parse LRC format → list `{timestamp, text}`
**11.3** – Build `LyricsView` widget (scroll + highlight dòng hiện tại)
**11.4** – Sync lyrics với `AudioService` position stream
**11.5** – Cache lyrics vào Isar, fallback plain text

---

## Phase 12: Download Offline

> **Packages cần thêm:** `path_provider`

**12.1** – Tạo `DownloadService` (extract URL + download file)
**12.2** – Download button + progress indicator trên `SongTile`
**12.3** – Lưu metadata vào Isar (fileName, size, date)
**12.4** – Kiểm tra offline trước khi stream
**12.5** – Play từ local file nếu đã download
**12.6** – Xóa file + xóa record Isar

---

## Phase 13: Video Playback

> **Packages cần thêm:** `video_player`, `chewie`

**13.1** – Tạo `VideoService.extractVideoUrl()` dùng `youtube_explode`
**13.2** – Tạo `VideoPlayerScreen` dùng `video_player` + `chewie`
**13.3** – Toggle button Audio ↔ Video
**13.4** – Fullscreen controls
**13.5** – Error handling + sync state với queue

---

## Phase 14: Podcast

> **Packages cần thêm:** `webfeed`

**14.1** – Tạo `PodcastService` (parse RSS bằng `webfeed`)
**14.2** – `PodcastScreen` UI (input RSS URL + danh sách subscribe)
**14.3** – Hiển thị episode list
**14.4** – Lưu subscription vào Firestore
**14.5** – Play episode qua `AudioPlayerService`
**14.6** – Track + resume episode progress

---

## Phase 15: Polish & iPad

**15.1** – Responsive layout helper (`isMobile` / `isTablet`)
**15.2** – iPad split-view layout (Library + Player)
**15.3** – Loading skeleton widgets
**15.4** – Page transition animations
**15.5** – Lazy load ảnh với `CachedNetworkImage`
**15.6** – Final dark theme audit toàn app

---
