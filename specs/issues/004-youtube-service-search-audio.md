# Phase 4: YouTube Service (Search & Audio Extraction)

**Status:** pending
**Phase:** 4 of 15

## Overview

Implement YouTube music search functionality and audio stream extraction using YouTube Data API and youtube_explode_dart with fallback support.

## Tasks

- [ ] Create YouTubeService with search functionality
- [ ] Integrate youtube_explode_dart for audio URL extraction
- [ ] Create SongModel with YouTube metadata (id, title, artist, duration, thumbnail)
- [ ] Build search API using YouTube Data API v3
- [ ] Add search result parsing and display
- [ ] Handle YouTube API quota limits gracefully
- [ ] Implement fallback search (youtube_explode if API fails)
- [ ] Cache search results in Isar for offline browsing

## Acceptance Criteria

- Search returns song results with thumbnail, title, artist, duration
- Can extract audio stream URL from YouTube video
- Handles API quota errors with fallback
- Search results cached locally
- No crashes on network errors

## Tech Notes

- youtube_explode_dart is unofficial, may break with YouTube updates
- YouTube Data API free quota: 10,000 units/day
- Fallback to youtube_explode_dart if API quota exceeded
- Consider caching search results for 24 hours

## Dependencies

- **Blocked by:** Phase 3 (Firestore & Isar)
- **Used by:** Phase 5 (Audio Player), Phase 8 (Search Screen), Phase 12 (Download), Phase 13 (Video)

---

**Next:** Phase 5 (Audio Player)
