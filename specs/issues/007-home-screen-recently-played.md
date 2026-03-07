# Phase 7: Home Screen & Recently Played

**Status:** pending
**Phase:** 7 of 15

## Overview

Build the Home Screen displaying recently played songs and recommendations with pull-to-refresh functionality.

## Tasks

- [ ] Create HomeScreen widget
- [ ] Fetch and display recently played songs from Firestore
- [ ] Build SongTile widget (thumbnail, title, artist)
- [ ] Add recommended section (based on history)
- [ ] Create RecentlyPlayedRepository
- [ ] Update history on every song play
- [ ] Sync history to Firestore
- [ ] Pull-to-refresh for recent updates

## Acceptance Criteria

- Home screen loads on app start
- Recently played songs display with thumbnails
- Tapping song starts playback
- History syncs to Firestore
- Pull-to-refresh updates list

## Tech Notes

- Use Riverpod for state management
- History entries must have timestamp for sorting
- Recently played = last 20 songs ordered by playedAt DESC

## Dependencies

- **Blocked by:** Phase 6 (Player UI)

---

**Next:** Phase 15 (Polish)
