# YMusic Implementation Stories

> Break down into GitHub issues following this order. Each story has dependencies noted.

---

## Phase 1: Project Setup & Configuration
**Status:** [ ] Pending
**Dependencies:** None

### Story: Initialize Flutter project, dependencies, and Firebase config
- [ ] Create Flutter project with null safety enabled
- [ ] Add all required dependencies (flutter_pubspec)
- [ ] Setup Google Cloud Project → OAuth 2.0 credentials
- [ ] Setup Firebase project → download google-services.json + GoogleService-Info.plist
- [ ] Configure Firebase in pubspec.yaml
- [ ] Setup theme (dark mode default, colors, typography)
- [ ] Create folder structure per PRD spec
- [ ] Create constants file (API endpoints, theme colors)

**Acceptance Criteria:**
- Project builds on iOS/Android without errors
- Firebase console accessible and configured
- Theme provider ready for app-wide use
- All core dependencies resolve without conflicts

**Tech Notes:**
- Ensure Flutter 3.x+ installed
- Need Google Developer account for API keys
- Firebase Spark plan sufficient

---

## Phase 2: Authentication (Google Sign In + Firebase)
**Status:** [ ] Pending
**Dependencies:** Phase 1

### Story: Implement Google Sign In and Firebase Auth session management
- [ ] Setup google_sign_in + firebase_auth packages
- [ ] Create AuthService with login/logout/session check logic
- [ ] Create Riverpod provider for auth state
- [ ] Build Login Screen with Google Sign In button
- [ ] Build Splash Screen (check session on app launch)
- [ ] Auto-login if session exists
- [ ] Handle sign-in errors (show snackbar)
- [ ] Store user profile data

**Acceptance Criteria:**
- User can sign in with Google Account
- Session persists across app closes
- User auto-logs in if session active
- Logout clears session properly
- Errors handled gracefully

**Tech Notes:**
- iOS: Add GIDSignInButton to Info.plist
- Android: Add Google-services plugins
- Use Riverpod for state persistence

---

## Phase 3: Firestore Service & Basic Data Models
**Status:** [ ] Pending
**Dependencies:** Phase 2

### Story: Setup Firestore service and CRUD for core data models
- [ ] Create models: Song, Playlist, UserPreference, History
- [ ] Create FirestoreService with CRUD methods
- [ ] Setup Firestore Security Rules (user-scoped access)
- [ ] Create repositories: PlaylistRepository, UserRepository
- [ ] Test Firestore read/write in emulator
- [ ] Implement sync conflict resolution (last-write-wins with timestamp)
- [ ] Setup Isar local database schema
- [ ] Create IsarService for local persistence

**Acceptance Criteria:**
- Can create/read/update/delete playlists in Firestore
- Firestore rules enforce user-scoped access
- Local Isar mirrors Firestore data structure
- Timestamp tracking for conflict resolution works
- No Firestore write errors on production rules

**Tech Notes:**
- Use Firestore emulator for testing
- Every document must have `updatedAt` field
- Isar schema matches Firestore data model

---

## Phase 4: YouTube Service (Search & Audio Extraction)
**Status:** [ ] Pending
**Dependencies:** Phase 3

### Story: Implement YouTube music search and audio stream extraction
- [ ] Create YouTubeService with search functionality
- [ ] Integrate youtube_explode_dart for audio URL extraction
- [ ] Create SongModel with YouTube metadata (id, title, artist, duration, thumbnail)
- [ ] Build search API using YouTube Data API v3
- [ ] Add search result parsing and display
- [ ] Handle YouTube API quota limits gracefully
- [ ] Implement fallback search (youtube_explode if API fails)
- [ ] Cache search results in Isar for offline browsing

**Acceptance Criteria:**
- Search returns song results with thumbnail, title, artist, duration
- Can extract audio stream URL from YouTube video
- Handles API quota errors with fallback
- Search results cached locally
- No crashes on network errors

**Tech Notes:**
- youtube_explode_dart is unofficial, may break with YouTube updates
- YouTube Data API free quota: 10,000 units/day
- Fallback to youtube_explode_dart if API quota exceeded
- Consider caching search results for 24 hours

---

## Phase 5: Audio Player (just_audio + audio_service)
**Status:** [ ] Pending
**Dependencies:** Phase 4

### Story: Implement core audio playback with background support
- [ ] Setup just_audio with audio sources
- [ ] Integrate audio_service for background playback
- [ ] Create AudioPlayerService (play, pause, next, previous, seek)
- [ ] Create Riverpod provider for player state
- [ ] Setup iOS background modes (Audio, AirPlay, Picture in Picture)
- [ ] Setup Android background audio entitlements
- [ ] Implement lock screen controls (iOS/Android native)
- [ ] Add notification player for background control
- [ ] Handle audio stream errors with retry logic

**Acceptance Criteria:**
- Audio plays from YouTube stream URL
- Play/pause/next/previous works smoothly
- Notification controls work in background
- Lock screen shows current track
- App doesn't crash when backgrounded
- Retry attempts stream if failed

**Tech Notes:**
- iOS: Enable Audio entitlement in Xcode
- iOS: Add UIBackgroundModes: audio in Info.plist
- Android: Use AudioService for background management
- All errors wrapped in try-catch per PRD

---

## Phase 6: Player UI (Mini Player + Full Player Screen)
**Status:** [ ] Pending
**Dependencies:** Phase 5

### Story: Build player UI with mini player bar and full screen player
- [ ] Create MiniPlayer widget (bottom bar with song info + controls)
- [ ] Create FullPlayerScreen with tabs (Player, Lyrics, Queue)
- [ ] Player tab: album art, title, artist, progress bar, controls
- [ ] Add seek slider with duration display
- [ ] Implement swipe-to-dismiss on full player
- [ ] Add glassmorphism/blur effects
- [ ] Create transition animation from mini to full player
- [ ] Style with dark theme (per PRD)

**Acceptance Criteria:**
- Mini player shows current song
- Can tap mini player to open full screen
- Full player has responsive layout
- Seek slider updates in real-time
- Gestures work smoothly (swipe, tap)
- Dark theme applied throughout

**Tech Notes:**
- Use glass_morphism or similar for blur effect
- Use Riverpod listeners for player state updates
- Gesture detector for swipe-to-dismiss

---

## Phase 7: Home Screen & Recently Played
**Status:** [ ] Pending
**Dependencies:** Phase 6

### Story: Build Home Screen with recently played and recommendations
- [ ] Create HomeScreen widget
- [ ] Fetch and display recently played songs from Firestore
- [ ] Build SongTile widget (thumbnail, title, artist)
- [ ] Add recommended section (based on history)
- [ ] Create RecentlyPlayedRepository
- [ ] Update history on every song play
- [ ] Sync history to Firestore
- [ ] Pull-to-refresh for recent updates

**Acceptance Criteria:**
- Home screen loads on app start
- Recently played songs display with thumbnails
- Tapping song starts playback
- History syncs to Firestore
- Pull-to-refresh updates list

**Tech Notes:**
- Use Riverpod for state management
- History entries must have timestamp for sorting
- Recently played = last 20 songs ordered by playedAt DESC

---

## Phase 8: Search Screen
**Status:** [ ] Pending
**Dependencies:** Phase 4, Phase 6

### Story: Build search UI and integrate YouTube search results
- [ ] Create SearchScreen with search bar
- [ ] Implement search input debouncing
- [ ] Display search results as list
- [ ] Show search suggestions (autocomplete)
- [ ] Tap result → start playback + add to queue
- [ ] Save search history locally
- [ ] Clear search history option

**Acceptance Criteria:**
- Search bar accepts text input
- Results show within 1-2 seconds (with debounce)
- Can tap result to play song
- Search history persists
- No lag on rapid typing

**Tech Notes:**
- Debounce search input by 500ms
- Display spinner while fetching results
- Search suggestions from cached popular songs

---

## Phase 9: Queue, Shuffle & Repeat Controls
**Status:** [ ] Pending
**Dependencies:** Phase 5, Phase 8

### Story: Implement queue management with shuffle and repeat modes
- [ ] Create QueueProvider (Riverpod)
- [ ] Implement add-to-queue logic
- [ ] Build queue display (Queue tab in full player)
- [ ] Add shuffle mode (OFF / ON)
- [ ] Add repeat mode (OFF / ONE / ALL)
- [ ] Update audio_service queue property
- [ ] Handle next/previous with queue logic
- [ ] Drag-to-reorder queue items
- [ ] Clear queue button

**Acceptance Criteria:**
- Can add songs to queue
- Queue displays in player
- Shuffle/repeat buttons work
- Next/previous follows queue rules
- Queue persists during playback session

**Tech Notes:**
- Queue stored in memory (not Firestore)
- Shuffle generates random order without duplicates
- Repeat logic: OFF → skip to next, ONE → restart same, ALL → loop queue

---

## Phase 10: Library Screen (Liked, History, Playlists, Downloaded)
**Status:** [ ] Pending
**Dependencies:** Phase 3, Phase 9

### Story: Build personal library with liked songs, history, playlists, downloads
- [ ] Create LibraryScreen with tabs
- [ ] Tab 1: Liked Songs (sync Firestore)
- [ ] Tab 2: Recent History (ordered by playedAt DESC)
- [ ] Tab 3: My Playlists (list with create button)
- [ ] Tab 4: Downloaded Songs (from Isar)
- [ ] Create PlaylistDetailScreen (show songs, add/remove)
- [ ] Create Playlist creation UI
- [ ] Like/unlike songs (heart icon)
- [ ] Add song to playlist dialog

**Acceptance Criteria:**
- All 4 tabs load data correctly
- Liked songs sync with Firestore
- Can create, view, edit playlists
- Can add/remove songs from playlists
- Heart icon indicates liked state
- Downloaded songs show offline indicator

**Tech Notes:**
- Liked songs use union merge conflict resolution
- Playlists have createDate + updatedAt for sorting
- Downloaded indicator uses isar query

---

## Phase 11: Lyrics Display (Fetch + Sync)
**Status:** [ ] Pending
**Dependencies:** Phase 6

### Story: Fetch and display real-time synced lyrics
- [ ] Create LyricsService (lrclib.net API integration)
- [ ] Fetch lyrics by song title + artist
- [ ] Parse LRC format (timestamps)
- [ ] Build LyricsView widget (karaoke-style)
- [ ] Sync lyrics with playback position
- [ ] Handle no-lyrics case (hide tab gracefully)
- [ ] Cache lyrics in Isar for repeat plays
- [ ] Fallback to plain text if no timestamps

**Acceptance Criteria:**
- Lyrics fetch and display within 2 seconds
- Lyrics highlight current line in real-time
- No crash if lyrics not found
- Lyrics tab only shows if lyrics exist
- Lyrics cached for offline viewing

**Tech Notes:**
- lrclib.net API is free, no auth required
- LRC format: [mm:ss.xx] lyrics text
- Sync using AudioService position stream
- Consider fallback plain text from LRC API

---

## Phase 12: Download Offline (youtube_explode + path_provider)
**Status:** [ ] Pending
**Dependencies:** Phase 4, Phase 10

### Story: Implement offline download functionality
- [ ] Create DownloadService (youtube_explode_dart)
- [ ] Add download button to song tile
- [ ] Download audio to app directory (path_provider)
- [ ] Show download progress indicator
- [ ] Save metadata to Isar with offline flag
- [ ] Check offline availability before streaming
- [ ] Play offline audio without network
- [ ] Delete downloaded files
- [ ] Show downloaded size

**Acceptance Criteria:**
- Download button visible on every song
- Download progress shows visually
- Downloaded songs marked in library
- Can play offline without internet
- Can delete offline files
- Offline indicator visible in UI

**Tech Notes:**
- Use path_provider for persistent storage
- Save audio as .m4a or .webm (youtube_explode default)
- Metadata includes: fileName, fileSize, downloadDate
- Implement delete confirmation dialog

---

## Phase 13: Video Playback (chewie + video_player)
**Status:** [ ] Pending
**Dependencies:** Phase 4, Phase 6

### Story: Add video playback capability with audio/video toggle
- [ ] Create VideoService (youtube_explode video URL extraction)
- [ ] Create VideoPlayerScreen widget
- [ ] Integrate video_player + chewie
- [ ] Build toggle button (Audio ↔ Video mode)
- [ ] Add fullscreen controls
- [ ] Handle video load errors
- [ ] Display video with lyrics/info overlay option
- [ ] Video playback respects queue

**Acceptance Criteria:**
- Can toggle between audio and video modes
- Video plays fullscreen without crashes
- Video syncs with audio player state
- Fullscreen controls visible and functional
- Handles network errors gracefully

**Tech Notes:**
- youtube_explode extracts video stream URL
- chewie provides iOS/Android video UI
- Switching audio→video uses same queue

---

## Phase 14: Podcast Support (RSS + webfeed)
**Status:** [ ] Pending
**Dependencies:** Phase 10, Phase 5

### Story: Add podcast discovery and playback
- [ ] Create PodcastService (RSS feed parser)
- [ ] Build PodcastScreen (subscribe to RSS feeds)
- [ ] Parse RSS feeds with webfeed package
- [ ] Display podcast episodes as list
- [ ] Save subscribed podcasts to Firestore
- [ ] Play podcast audio via just_audio
- [ ] Show episode progress (resume playback)
- [ ] Unsubscribe from podcast

**Acceptance Criteria:**
- Can input RSS feed URL
- Episodes display with title, date, description
- Can play episode audio
- Subscriptions persist in Firestore
- Episode progress tracked and resumed

**Tech Notes:**
- webfeed parses RSS/Atom formats
- Store podcast subscription URL in Firestore
- Episode playback uses existing AudioPlayerService
- Show podcast icon/metadata in player

---

## Phase 15: iPad Adaptive Layout & Polish
**Status:** [ ] Pending
**Dependencies:** All previous phases

### Story: iPad split-view layout, animations, and final UI polish
- [ ] Implement responsive layout (MediaQuery checks)
- [ ] Build iPad-specific split-view (library + player side-by-side)
- [ ] Add smooth page transition animations
- [ ] Polish mini-to-full player transition
- [ ] Add loading skeletons for async data
- [ ] Implement pull-to-refresh animations
- [ ] Fine-tune dark theme colors
- [ ] Test on multiple devices (iPhone 13+, iPad)
- [ ] Performance optimization (lazy load images)

**Acceptance Criteria:**
- iPhone layout works full-screen
- iPad shows split view on landscape
- Animations smooth (60fps target)
- All screens have proper spacing/padding
- Images load without jank
- Dark theme consistent throughout

**Tech Notes:**
- Use LayoutBuilder for responsive design
- CachedNetworkImage for image optimization
- Riverpod ensures state consistency across screens

---

## Dependencies Summary

```
Phase 1 (Setup)
    ↓
Phase 2 (Auth)
    ↓
Phase 3 (Firestore + Isar)
    ↓
Phase 4 (YouTube Service) ← Phase 3
    ↓
Phase 5 (Audio Player) ← Phase 4
    ↓
Phase 6 (Player UI) ← Phase 5
    ├→ Phase 7 (Home) ← Phase 6
    ├→ Phase 8 (Search) ← Phase 4, 6
    ├→ Phase 9 (Queue) ← Phase 5, 8
    ├→ Phase 10 (Library) ← Phase 3, 9
    ├→ Phase 11 (Lyrics) ← Phase 6
    ├→ Phase 12 (Download) ← Phase 4, 10
    ├→ Phase 13 (Video) ← Phase 4, 6
    ├→ Phase 14 (Podcast) ← Phase 10, 5
    ↓
Phase 15 (Polish & iPad Layout) ← All previous
```

---

## Notes for GitHub Issues

Each phase can be converted to a GitHub issue:
- **Title:** Phase X: [Feature Name]
- **Description:** Copy the story section
- **Labels:** `phase-X`, `feature`, `epic` (optional)
- **Milestone:** Assign to YMusic v1.0 (optional)
- **Acceptance Criteria:** Check the list in story
- **Dependencies:** Link to previous phase issues

Example:
```
Title: Phase 2: Google Sign In & Firebase Auth
Body: [Copy story section]
Labels: phase-2, auth
Links: Blocked by #1 (Phase 1)
```
