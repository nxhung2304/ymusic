# Phase 13: Video Playback (chewie + video_player)

**Status:** pending
**Phase:** 13 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Add video playback capability with audio/video toggle, fullscreen controls, and queue synchronization.

## Tasks

- [ ] Create VideoService (youtube_explode video URL extraction)
- [ ] Create VideoPlayerScreen widget
- [ ] Integrate video_player + chewie
- [ ] Build toggle button (Audio ↔ Video mode)
- [ ] Add fullscreen controls
- [ ] Handle video load errors
- [ ] Display video with lyrics/info overlay option
- [ ] Video playback respects queue

## Acceptance Criteria

- Can toggle between audio and video modes
- Video plays fullscreen without crashes
- Video syncs with audio player state
- Fullscreen controls visible and functional
- Handles network errors gracefully

## Tech Notes

- youtube_explode extracts video stream URL
- chewie provides iOS/Android video UI
- Switching audio→video uses same queue

## Dependencies

- **Blocked by:** Phase 4 (YouTube Service) and Phase 6 (Player UI)

---

**Next:** Phase 14 (Podcast)
