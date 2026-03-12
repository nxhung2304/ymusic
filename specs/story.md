# YMusic Implementation Stories

> Break down into small GitHub issues (1 story ≈ 1-4h work). Order: Setup → Core → Features → Polish.
> Dependencies noted. Use Riverpod for state, go_router for navigation, clean layers where possible.

## Phase 0: Setup Foundations
**0.1** – Create GitHub repo + CLAUDE.md (coding guidelines: Riverpod naming, error handling).
**0.2** – Setup Flutter project + folder structure (lib/core, features/, data/, domain/, presentation/).
**0.3** – constants.dart + ThemeData dark mode + MaterialApp.
**0.4** – flutter_dotenv + .env cho API keys (YouTube nếu cần fallback).
**0.5** – Setup Firebase (Auth, Firestore) + google-services/Info.plist.

## Phase 1: Authentication & Routing
**Packages:** google_sign_in, firebase_auth, firebase_core, flutter_riverpod, riverpod_annotation, go_router | dev: build_runner, riverpod_generator
**1.1** – AuthDatasource (login/logout/currentUser).
**1.2** – Riverpod authProvider + authStateProvider.
**1.3** – LoginScreen + Google button + error handling.
**1.4** – SplashScreen (session check → redirect router).
**1.5** – Setup go_router (shell + protected routes).

## Phase 2: Data Layer (Models + Repos + Local DB)
**Packages:** cloud_firestore, isar, isar_flutter_libs, dio | dev: isar_generator
**2.1** – Models: Song, Playlist, UserPreference, History, LikedSong (fromJson/toJson).
**2.2** – FirestoreService generic CRUD.
**2.3** – Repositories: PlaylistRepository, LikedSongsRepository, HistoryRepository, UserRepository.
**2.4** – Isar setup + IsarService (schema mirror models, local CRUD).
**2.5** – Firestore Security Rules draft.
**2.6** – Sync conflict resolution: last-write-wins theo `updatedAt` timestamp; union merge cho LikedSongs/Playlist (không xóa bài khi add từ thiết bị khác).

## Phase 3: YouTube Integration
**Packages:** youtube_explode_dart
**3.1** – YouTubeService: search() → Song list (parse).
**3.2** – extractAudioUrl() + fallback nếu quota/error.
**3.3** – Cache search results Isar (TTL 24h).
**3.4** – Rate limiting + error snackbar global.

## Phase 4: Audio Player Core
**Packages:** just_audio, audio_service, cached_network_image
**4.1** – AudioPlayerService + just_audio instance.
**4.2** – play/pause/seek/next/prev + playerStateProvider.
**4.3** – audio_service background session (handler + task).
**4.4** – Lock screen controls + notification player UI (MediaNotification).
**4.5** – iOS background modes + entitlement (`audio` UIBackgroundModes + Xcode capability).
**4.6** – Retry + error handling stream.

## Phase 5: Player UI & Mini/Full Transition
**5.1** – MiniPlayerBar widget + state persistence khi navigate giữa bottom tabs.
**5.2** – FullPlayerScreen scaffold + tab structure (Player / Lyrics / Queue).
**5.3** – Player tab: album art, seek slider, playback controls, glassmorphism blur background.
**5.4** – Lyrics tab: LRC sync highlight (karaoke style) + plain text fallback.
**5.5** – Queue tab: danh sách queue + drag-to-reorder.
**5.6** – Animation mini → full (Hero / DraggableScrollableSheet) + swipe-down dismiss.

## Phase 6: Home & Navigation Shell
**6.1** – AppShell + BottomNav (Home/Search/Library).
**6.2** – HomeScreen: RecentlyPlayed horizontal scroll + Recommended section.
**6.3** – SongTile reusable widget + pull-to-refresh.
**6.4** – Update history khi play (write Firestore + Isar).

## Phase 7: Search & Queue
**7.1** – SearchScreen + debounce 500ms + autocomplete suggestions dropdown.
**7.2** – Results list + play trực tiếp / add to queue.
**7.3** – QueueProvider + add/remove/reorder/shuffle/repeat modes.

## Phase 8: Library & Playlists
**8.1** – LibraryScreen shell + TabBar (Liked / History / Playlists / Downloads / Podcasts).
**8.2** – Liked Songs tab: danh sách + unlike action + sync Firestore.
**8.3** – History tab: danh sách gần đây + clear history action.
**8.4** – Playlists tab: danh sách playlist + create playlist dialog.
**8.5** – Downloads tab: danh sách offline từ Isar + delete action.
**8.6** – Podcasts tab: danh sách podcast đã subscribe + unsubscribe action.
**8.7** – PlaylistDetailScreen: header (art + title + play all) + song list + add/remove song.
**8.8** – SettingsScreen: theme toggle, language selector (EN/VI), account info, logout, app version.

## Phase 9: Lyrics & Offline Download
**9.1** – LyricsService (lrclib.net API) + parse LRC format + sync theo playback position.
**9.2** – Cache lyrics Isar.
**9.3** – DownloadService: download audio stream → path_provider + progress indicator.
**9.4** – Play local file nếu offline (kiểm tra Isar trước khi fetch URL).
**9.5** – Delete download + cleanup file + update Isar.

## Phase 10: Video & Podcast
**10.1** – Video stream extract (youtube_explode_dart) + VideoPlayerScreen UI (chewie).
**10.2** – Toggle audio ↔ video mode trong player.
**10.3** – PodcastService: parse RSS (webfeed) → episode list.
**10.4** – PodcastScreen UI: subscribe by URL + episode list + play episode.
**10.5** – Lưu subscribed podcasts + playback progress vào Firestore.

## Phase 11: UI States, Polish & iPad
**11.1** – Empty states UI: EmptySearch, EmptyLibrary, EmptyPlaylist components.
**11.2** – Error state UI: NetworkError (wifi-off + retry), GenericError components.
**11.3** – Skeleton loading UI cho Home, Search results, Library lists.
**11.4** – Lazy load images (cached_network_image placeholder + fade-in).
**11.5** – Page transitions + shared element animations.
**11.6** – Internationalization (intl package, en/vi strings cho toàn bộ app).
**11.7** – Global error handling + logging service.
**11.8** – iPad responsive: isMobile/isTablet helper + split-view layout (Library sidebar + Player panel).
**11.9** – iPad adaptive screens: Home (2-col grid), Library (persistent sidebar), Player (art left + controls right).
**11.10** – Final theme/dark mode consistency pass.

## Phase 12: Testing & Performance
**12.1** – Unit tests: AuthService, AudioPlayerService, YouTubeService, Repositories.
**12.2** – Widget tests: SongTile, MiniPlayer, LyricsView.
**12.3** – Performance audit (memory leaks, startup time, image caching).

## Phase 13: Deployment & Docs
**13.1** – Build IPA + TestFlight internal testing.
**13.2** – README + changelog + disclaimer legal.
**13.3** – CI/CD basic (GitHub Actions: lint + test on PR).
