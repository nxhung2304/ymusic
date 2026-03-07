# Phase 9: Queue, Shuffle & Repeat Controls

**Status:** pending
**Phase:** 9 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Implement queue management system with shuffle and repeat mode controls, drag-to-reorder functionality, and proper next/previous logic.

## Tasks

- [ ] Create QueueProvider (Riverpod)
- [ ] Implement add-to-queue logic
- [ ] Build queue display (Queue tab in full player)
- [ ] Add shuffle mode (OFF / ON)
- [ ] Add repeat mode (OFF / ONE / ALL)
- [ ] Update audio_service queue property
- [ ] Handle next/previous with queue logic
- [ ] Drag-to-reorder queue items
- [ ] Clear queue button

## Acceptance Criteria

- Can add songs to queue
- Queue displays in player
- Shuffle/repeat buttons work
- Next/previous follows queue rules
- Queue persists during playback session

## Tech Notes

- Queue stored in memory (not Firestore)
- Shuffle generates random order without duplicates
- Repeat logic: OFF → skip to next, ONE → restart same, ALL → loop queue

## Dependencies

- **Blocked by:** Phase 5 (Audio Player) and Phase 8 (Search Screen)
- **Used by:** Phase 10 (Library)

---

**Next:** Phase 10 (Library Screen)
