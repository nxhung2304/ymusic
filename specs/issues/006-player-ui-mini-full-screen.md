# Phase 6: Player UI (Mini Player + Full Player Screen)

**Status:** pending
**Phase:** 6 of 15

## Overview

Build player UI components including a mini player bar at the bottom and full-screen player with tabs for Player, Lyrics, and Queue.

## Tasks

- [ ] Create MiniPlayer widget (bottom bar with song info + controls)
- [ ] Create FullPlayerScreen with tabs (Player, Lyrics, Queue)
- [ ] Player tab: album art, title, artist, progress bar, controls
- [ ] Add seek slider with duration display
- [ ] Implement swipe-to-dismiss on full player
- [ ] Add glassmorphism/blur effects
- [ ] Create transition animation from mini to full player
- [ ] Style with dark theme (per PRD)

## Acceptance Criteria

- Mini player shows current song
- Can tap mini player to open full screen
- Full player has responsive layout
- Seek slider updates in real-time
- Gestures work smoothly (swipe, tap)
- Dark theme applied throughout

## Tech Notes

- Use glass_morphism or similar for blur effect
- Use Riverpod listeners for player state updates
- Gesture detector for swipe-to-dismiss

## Dependencies

- **Blocked by:** Phase 5 (Audio Player)
- **Used by:** Phase 7 (Home), Phase 8 (Search), Phase 11 (Lyrics), Phase 13 (Video), Phase 15 (Polish)

---

**Next:** Phase 7 (Home Screen), Phase 8 (Search Screen)
