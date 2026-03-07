# Phase 10: Library Screen (Liked, History, Playlists, Downloaded)

**Status:** pending
**Phase:** 10 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Build personal library with four tabs: Liked Songs, Recent History, My Playlists, and Downloaded Songs with full CRUD support for playlists.

## Tasks

- [ ] Create LibraryScreen with tabs
- [ ] Tab 1: Liked Songs (sync Firestore)
- [ ] Tab 2: Recent History (ordered by playedAt DESC)
- [ ] Tab 3: My Playlists (list with create button)
- [ ] Tab 4: Downloaded Songs (from Isar)
- [ ] Create PlaylistDetailScreen (show songs, add/remove)
- [ ] Create Playlist creation UI
- [ ] Like/unlike songs (heart icon)
- [ ] Add song to playlist dialog

## Acceptance Criteria

- All 4 tabs load data correctly
- Liked songs sync with Firestore
- Can create, view, edit playlists
- Can add/remove songs from playlists
- Heart icon indicates liked state
- Downloaded songs show offline indicator

## Tech Notes

- Liked songs use union merge conflict resolution
- Playlists have createDate + updatedAt for sorting
- Downloaded indicator uses isar query

## Dependencies

- **Blocked by:** Phase 3 (Firestore & Isar) and Phase 9 (Queue)
- **Used by:** Phase 12 (Download), Phase 14 (Podcast)

---

**Next:** Phase 11 (Lyrics), Phase 12 (Download)
