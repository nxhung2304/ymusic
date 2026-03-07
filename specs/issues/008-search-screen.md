# Phase 8: Search Screen

**Status:** pending
**Phase:** 8 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Build search UI with debounced search input, results display, autocomplete suggestions, and search history persistence.

## Tasks

- [ ] Create SearchScreen with search bar
- [ ] Implement search input debouncing
- [ ] Display search results as list
- [ ] Show search suggestions (autocomplete)
- [ ] Tap result → start playback + add to queue
- [ ] Save search history locally
- [ ] Clear search history option

## Acceptance Criteria

- Search bar accepts text input
- Results show within 1-2 seconds (with debounce)
- Can tap result to play song
- Search history persists
- No lag on rapid typing

## Tech Notes

- Debounce search input by 500ms
- Display spinner while fetching results
- Search suggestions from cached popular songs

## Dependencies

- **Blocked by:** Phase 4 (YouTube Service) and Phase 6 (Player UI)

---

**Next:** Phase 9 (Queue, Shuffle & Repeat)
