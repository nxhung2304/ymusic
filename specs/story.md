# YMusic Implementation Stories

> Vertical Slice approach: mỗi phase deliver một tính năng chạy được end-to-end.
> Model chỉ tạo khi feature cần đến — tránh over-engineering upfront.
> Riverpod cho state, go_router cho navigation, clean layers (data/domain/presentation).
>
> **Development order (UI-first):** UI skeleton (hardcoded data) → Model → Service/Logic → Wire UI vào real data.
> Lý do: thấy UI trước để biết data cần gì, tránh build service cho thứ UI chưa dùng.
>
> **Chú thích:** `[🤖]` = Claude Code | `[👤]` = User | `[👤+🤖]` = cả hai *(ghi rõ phần ai làm)*
>
> **Testing Convention:**
> - Mọi service/repository do `[🤖]` implement PHẢI có unit test đi kèm trong cùng PR.
> - Dùng `fake_cloud_firestore` cho Firestore tests — không mock, không cần emulator.
> - Test file đặt tại `test/` mirror theo `lib/`: ví dụ `lib/core/services/x.dart` → `test/core/services/x_test.dart`.
> - Minimum coverage: happy path + edge case (empty/null) + exception path cho mỗi public method.

---

## Phase 0: Setup Foundations ✅
- [x] 0.1 – Create GitHub repo + CLAUDE.md (coding guidelines: Riverpod naming, error handling). `[👤+🤖]` *(👤 tạo GitHub repo | 🤖 viết nội dung CLAUDE.md)*
- [x] 0.2 – Setup Flutter project + folder structure (lib/core, features/, data/, domain/, presentation/). `[🤖]`
- [x] 0.3 – constants.dart + ThemeData dark mode + MaterialApp. `[🤖]`
- [x] 0.4 – flutter_dotenv + .env cho API keys (YouTube nếu cần fallback). `[👤+🤖]` *(👤 điền API keys vào .env | 🤖 setup flutter_dotenv code)*
- [x] 0.5 – Setup Firebase (Auth, Firestore) + google-services/Info.plist. `[👤]` *(tạo project trên Firebase Console, download config files)*

---

## Phase 1: Authentication & Routing ✅
Packages: google_sign_in, firebase_auth, firebase_core, flutter_riverpod, riverpod_annotation, go_router | dev: build_runner, riverpod_generator
- [x] 1.1 – AuthDatasource (login/logout/currentUser). `[🤖]`
- [x] 1.2 – Riverpod authProvider + authStateProvider. `[🤖]`
- [x] 1.3 – LoginScreen + Google button + error handling. `[🤖]`
- [x] 1.4 – SplashScreen (session check → redirect router). `[🤖]`
- [x] 1.5 – Setup go_router (shell + protected routes). `[🤖]`
- [x] 1.6 – Register deep link scheme `ymusic://` trong `ios/Runner/Info.plist` + khai báo route placeholder trong go_router (handler logic implement dần theo phase). `[👤+🤖]` *(🤖 sửa Info.plist + khai báo routes | 👤 verify scheme hoạt động trên Xcode)*
- [x] 1.7 – Refactor LoginScreen: AuthNotifier (freezed) + SignInWithGoogleUsecase, fix architecture violations. `[🤖]`
    > ref: specs/comments/login-screen-code-review.md

---

## Phase 2: Core Infrastructure (Shared, Minimal) ✅
> Chỉ setup skeleton — không tạo models hay repos cụ thể ở đây.

Packages: cloud_firestore, isar, isar_flutter_libs, dio | dev: isar_generator
- [x] 2.1 – FirestoreService: set/get/delete/collection helpers + unit tests (16 cases). `[🤖]`
- [x] 2.2 – IsarService: khởi tạo instance, open DB, registerSchemas pattern (schema đăng ký dần theo feature). `[🤖]`
- [x] 2.3 – Firestore Security Rules: `/users/{uid}/**` read/write chỉ cho authenticated owner. `[👤+🤖]` *(🤖 viết rules file | 👤 deploy lên Firebase Console)*
- [x] 2.4 – Global error handling: AppException types + dio interceptor (retry 3 lần, exponential backoff) + error snackbar provider. `[🤖]`

**Deliverable:** infrastructure sẵn sàng để các feature slice dùng.

---

## Phase 3: Slice — Search & Play
> Mục tiêu: search nhạc → phát được. Background audio chưa cần ở phase này.

Packages: youtube_explode_dart, just_audio, cached_network_image
- [x] 3.1 – Song model (videoId, title, artist, thumbnailUrl, duration) + fromJson/toJson. `[🤖]`
- [x] 3.2 – YouTubeService: search(query) → List<Song> (parse từ youtube_explode_dart). `[🤖]`
- [x] 3.3 – extractAudioUrl(videoId) + fallback + rate limiting (queue + throttle 1 req/s). `[👤]` *(stream handling + rate limiting logic)*
- [ ] 3.4 – AppShell + BottomNav (Home/Search/Library) + SongTile widget (hardcoded Song data). `[🤖]`
- [ ] 3.5 – SearchScreen: debounce 500ms + autocomplete suggestions + results list (wire tới YouTubeService 3.2); play action là no-op tạm. `[🤖]`
- [ ] 3.6 – MiniPlayerBar + FullPlayerScreen (art, seek slider, controls, blur bg — hardcoded state trước). `[🤖]`
- [ ] 3.7 – AudioPlayerService: just_audio instance + play/pause/seek/next/prev. `[👤]` *(stream handling)*
  > ⚠️ 3.7 sẽ được refactor ở Phase 4.1 để tích hợp audio_service background handler — thiết kế interface đủ abstract để dễ wrap sau.
- [ ] 3.8 – playerStateProvider (currentSong, playback state, position, queue) + wire vào Player UI (3.6). `[👤]` *(state management)*
- [ ] 3.9 – Wire SearchScreen play action → AudioPlayerService + wire MiniPlayer/FullPlayer vào real state. `[🤖]`
- [ ] 3.10 – Cache search results Isar (TTL 24h) — đăng ký schema Song vào IsarService. `[🤖]`
- [ ] 3.11 – Unit test: YouTubeService (mock), AudioPlayerService, playerStateProvider. `[👤+🤖]` *(👤 test AudioPlayerService + playerStateProvider | 🤖 test YouTubeService mock)*

**Deliverable:** search bài → tap → nhạc phát trong foreground, mini/full player chuyển đổi được.

---

## Phase 4: Slice — Background Audio & Player Animation
> Mục tiêu: background audio hoạt động, animation mini → full.

Packages: audio_service
- [ ] 4.1 – Animation mini → full (Hero / DraggableScrollableSheet) + swipe-down dismiss. `[🤖]`
- [ ] 4.2 – Lock screen controls + MediaNotification UI. `[🤖]`
- [ ] 4.3 – iOS: UIBackgroundModes audio + Xcode capability. `[👤+🤖]` *(🤖 sửa Info.plist (UIBackgroundModes) | 👤 bật Audio capability trong Xcode → Signing & Capabilities)*
- [ ] 4.4 – audio_service background session (handler + AudioTask) + wire vào AudioPlayerService (3.7). `[👤]` *(stream handling + background session logic)*
- [ ] 4.5 – Implement deep link handlers: `ymusic://song/{videoId}` → play + `ymusic://podcast/{encodedFeedUrl}` → open podcast. *(scheme đã register ở Phase 1.6)* `[🤖]`
- [ ] 4.6 – Unit test: background handler, lock screen controls, deep link routing. `[👤+🤖]` *(👤 test background handler | 🤖 test lock screen UI + deep link routing)*

**Deliverable:** tắt màn hình → nhạc vẫn chạy, lock screen controls hoạt động.

---

## Phase 5: Slice — Queue & Home
> Mục tiêu: queue hoạt động, Home có nội dung.

- [ ] 5.1 – HomeScreen: RecentlyPlayed horizontal scroll + Recommended section (hardcoded data trước). `[🤖]`
- [ ] 5.2 – Pull-to-refresh trên HomeScreen. `[🤖]`
- [ ] 5.3 – Queue tab trong FullPlayerScreen: danh sách + drag-to-reorder (hardcoded queue trước). `[🤖]`
- [ ] 5.4 – SearchScreen: add to queue action (UI). `[🤖]`
- [ ] 5.5 – History model (videoId, title, artist, thumbnailUrl, duration, playedAt, updatedAt) + HistoryRepository (Firestore + Isar schema, overwrite theo videoId, cap 200 entries). `[👤+🤖]` *(👤 viết overwrite + cap logic | 🤖 viết model boilerplate + Isar schema)*
- [ ] 5.6 – Ghi history tự động khi play + wire HomeScreen RecentlyPlayed vào real data. `[👤]` *(data sync logic)*
- [ ] 5.7 – QueueProvider: add/remove/reorder + shuffle/repeat modes + wire Queue UI (5.3, 5.4). `[👤]` *(state management)*
- [ ] 5.8 – Unit test: QueueProvider (add/remove/shuffle/repeat) + HistoryRepository (cap logic, overwrite logic). `[👤]` *(test business logic tự viết)*

**Deliverable:** queue đầy đủ, Home có nội dung hiển thị.

---

## Phase 6: Slice — Liked Songs & History
> Mục tiêu: like bài, xem lịch sử — sync lên Firestore.

> ⚠️ Convention từ phase này trở đi: Mọi Firestore document model PHẢI có field `updatedAt: Timestamp` để tương thích với conflict resolution ở Phase 10.

- [ ] 6.1 – LibraryScreen shell + TabBar (Liked / History / Playlists / Downloads / Podcasts). `[🤖]`
- [ ] 6.2 – Liked Songs tab: danh sách + unlike action (hardcoded data trước). `[🤖]`
- [ ] 6.3 – History tab: danh sách gần đây + clear history action (wire tới HistoryRepository từ Phase 5.5). `[🤖]`
- [ ] 6.4 – Like/unlike action từ Player + SongTile (optimistic update — UI trước, no-op). `[🤖]`
- [ ] 6.5 – LikedSong model + LikedSongsRepository (Firestore + Isar schema) + wire Liked Songs tab + like action. `[🤖]`
- [ ] 6.6 – Unit test: LikedSongsRepository (like/unlike, Firestore sync). `[🤖]`

**Deliverable:** like bài → xuất hiện trong Library, lịch sử nghe tự cập nhật.

---

## Phase 7: Slice — Playlists
> Mục tiêu: tạo và quản lý playlist.

- [ ] 7.1 – Playlist model + PlaylistRepository (Firestore, auto-ID). `[🤖]`
- [ ] 7.2 – Playlists tab: danh sách + create playlist dialog. `[🤖]`
- [ ] 7.3 – PlaylistDetailScreen: header (art + title + play all) + song list. `[🤖]`
- [ ] 7.4 – Add/remove song khỏi playlist (từ Player context menu + SongTile). `[🤖]`
- [ ] 7.5 – Unit test: PlaylistRepository (CRUD). `[🤖]`

**Deliverable:** tạo playlist, thêm/xóa bài, phát toàn bộ playlist.

---

## Phase 8: Slice — Lyrics
> Mục tiêu: lyrics sync realtime theo playback position.

- [ ] 8.1 – LyricsService: gọi lrclib.net API + parse LRC format. `[🤖]`
- [ ] 8.2 – Cache lyrics Isar (đăng ký schema Lyrics vào IsarService). `[🤖]`
- [ ] 8.3 – Lyrics tab trong FullPlayerScreen: highlight dòng hiện tại (karaoke style) + plain text fallback. `[🤖]`
- [ ] 8.4 – Unit test: LyricsService (parse LRC, fallback plain text). `[🤖]`

**Deliverable:** mở Lyrics tab → thấy lyrics chạy theo nhạc.

---

## Phase 9: Slice — Offline Download
> Mục tiêu: tải bài về, phát khi offline.

Packages: path_provider
- [ ] 9.1 – DownloadService: download audio stream → path_provider + progress indicator. `[👤]` *(stream handling)*
- [ ] 9.2 – Isar schema DownloadedSong (localPath, downloadedAt). `[🤖]`
- [ ] 9.3 – AudioPlayerService: kiểm tra Isar local file trước khi fetch URL từ YouTube. `[👤]` *(business logic — local-first decision)*
- [ ] 9.4 – Downloads tab: danh sách offline + delete action (cleanup file + Isar). `[🤖]`
- [ ] 9.5 – Unit test: DownloadService (progress, cleanup). `[👤]` *(test stream handling tự viết)*

**Deliverable:** tải bài → phát được khi tắt mạng.

---

## Phase 10: Slice — Multi-device Sync, Deep Link & Settings
> Mục tiêu: sync Firestore ↔ Isar, deep link, settings persist.

- [ ] 10.1 – UserPreference model + repo (Firestore doc `preferences/settings` + Isar cache). `[🤖]`
- [ ] 10.2 – Conflict resolution: last-write-wins theo `updatedAt`. `[👤]` *(data sync logic)*
- [ ] 10.3 – Union merge cho LikedSongs/Playlist (merge logic tách riêng khỏi last-write-wins). `[👤]` *(business logic)*
- [ ] 10.4 – Sync trigger khi app foreground (onResume). `[👤]` *(data sync)*
- [ ] 10.5 – SettingsScreen: theme toggle, language selector (EN/VI), account info, logout, app version. `[🤖]`
- [ ] 10.6 – Unit test: conflict resolution (last-write-wins + union merge). `[👤]` *(test business logic tự viết)*

**Deliverable:** thay đổi trên iPhone → sync sang iPad, share link bài nhạc mở và phát được, settings persist.

---

## Phase 11: Slice — Video & Podcast
> Mục tiêu: xem video, nghe podcast.

Packages: video_player, chewie, webfeed
- [ ] 11.1 – Video stream extract (youtube_explode_dart) + VideoPlayerScreen UI (chewie). `[👤+🤖]` *(👤 viết stream extract logic | 🤖 viết VideoPlayerScreen UI với chewie)*
- [ ] 11.2 – Toggle audio ↔ video mode trong FullPlayerScreen. `[🤖]`
- [ ] 11.3 – PodcastService: parse RSS feed (webfeed) → episode list. `[🤖]`
- [ ] 11.4 – PodcastScreen: subscribe by URL + episode list + play episode. `[🤖]`
- [ ] 11.5 – Subscribed podcasts + episode progress → Firestore. `[👤]` *(data sync)*
- [ ] 11.6 – Podcasts tab trong LibraryScreen: danh sách + unsubscribe action. `[🤖]`
- [ ] 11.7 – Unit test: PodcastService (RSS parse), episode progress sync. `[👤+🤖]` *(👤 test episode progress sync | 🤖 test RSS parse)*

**Deliverable:** phát video YouTube, nghe podcast qua RSS URL, episode progress sync Firestore.

---

## Phase 12: Polish & iPad
> Mục tiêu: UI đầy đủ states, responsive iPad.

- [ ] 12.1 – Empty states: EmptySearch, EmptyLibrary, EmptyPlaylist components. `[🤖]`
- [ ] 12.2 – Error states: NetworkError (wifi-off + retry), GenericError components. `[🤖]`
- [ ] 12.3 – Skeleton loading: Home, Search results, Library lists. `[🤖]`
- [ ] 12.4 – Lazy load images (cached_network_image placeholder + fade-in). `[🤖]`
- [ ] 12.5 – Page transitions + shared element animations. `[🤖]`
- [ ] 12.6 – Internationalization: hoàn thiện en/vi strings còn thiếu, kiểm tra toàn bộ app (infrastructure đã setup ở Phase 2). `[🤖]`
- [ ] 12.7 – iPad responsive: isMobile/isTablet helper + split-view layout (Library sidebar + Player panel). `[🤖]`
- [ ] 12.8 – iPad adaptive: Home (2-col grid), Library (persistent sidebar), Player (art left + controls right). `[🤖]`
- [ ] 12.9 – Final theme/dark mode consistency pass. `[🤖]`

**Deliverable:** app polish hoàn chỉnh, chạy đẹp trên cả iPhone lẫn iPad.

---

## Phase 13: Performance & Deployment
- [ ] 13.1 – Performance audit: memory leaks, startup time, image caching. `[🤖]`
- [ ] 13.2 – Build IPA + TestFlight internal testing. `[👤]` *(Xcode archive + upload lên App Store Connect)*
- [ ] 13.3 – README + changelog + disclaimer legal. `[🤖]`
- [ ] 13.4 – CI/CD basic (GitHub Actions: lint + test on PR). `[🤖]`
- [ ] 13.5 – App binary size audit: đo IPA size + xác định heavy packages (target < 50MB). `[👤+🤖]` *(🤖 analyze packages + đề xuất cắt giảm | 👤 đo IPA thực tế trên Xcode)*
- [ ] 13.6 – Cold start benchmark: đo thời gian từ launch đến interactive (target < 2s trên iPhone 12+). `[👤]` *(đo trên device thực)*
- [ ] 13.7 – Accessibility audit: VoiceOver labels cho Player controls, Search, Library lists. `[🤖]`
- [ ] 13.8 – Background edge case: test headphone disconnect khi màn hình tắt, iOS terminate app mid-play. `[👤]` *(test thủ công trên device)*
