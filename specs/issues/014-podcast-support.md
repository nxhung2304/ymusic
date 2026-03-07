# Phase 14: Podcast Support (RSS + webfeed)

**Status:** pending
**Phase:** 14 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Add podcast discovery and playback with RSS feed support, subscription management, and episode progress tracking.

## Tasks

- [ ] Create PodcastService (RSS feed parser)
- [ ] Build PodcastScreen (subscribe to RSS feeds)
- [ ] Parse RSS feeds with webfeed package
- [ ] Display podcast episodes as list
- [ ] Save subscribed podcasts to Firestore
- [ ] Play podcast audio via just_audio
- [ ] Show episode progress (resume playback)
- [ ] Unsubscribe from podcast

## Acceptance Criteria

- Can input RSS feed URL
- Episodes display with title, date, description
- Can play episode audio
- Subscriptions persist in Firestore
- Episode progress tracked and resumed

## Tech Notes

- webfeed parses RSS/Atom formats
- Store podcast subscription URL in Firestore
- Episode playback uses existing AudioPlayerService
- Show podcast icon/metadata in player

## Dependencies

- **Blocked by:** Phase 10 (Library) and Phase 5 (Audio Player)

---

**Next:** Phase 15 (iPad & Polish)
