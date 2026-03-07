# Phase 11: Lyrics Display (Fetch + Sync)

**Status:** pending
**Phase:** 11 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Fetch and display real-time synced lyrics with karaoke-style highlighting, using lrclib.net API with fallback to plain text.

## Tasks

- [ ] Create LyricsService (lrclib.net API integration)
- [ ] Fetch lyrics by song title + artist
- [ ] Parse LRC format (timestamps)
- [ ] Build LyricsView widget (karaoke-style)
- [ ] Sync lyrics with playback position
- [ ] Handle no-lyrics case (hide tab gracefully)
- [ ] Cache lyrics in Isar for repeat plays
- [ ] Fallback to plain text if no timestamps

## Acceptance Criteria

- Lyrics fetch and display within 2 seconds
- Lyrics highlight current line in real-time
- No crash if lyrics not found
- Lyrics tab only shows if lyrics exist
- Lyrics cached for offline viewing

## Tech Notes

- lrclib.net API is free, no auth required
- LRC format: [mm:ss.xx] lyrics text
- Sync using AudioService position stream
- Consider fallback plain text from LRC API

## Dependencies

- **Blocked by:** Phase 6 (Player UI)

---

**Next:** Phase 12 (Download)
