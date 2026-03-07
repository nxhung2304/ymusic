# Phase 12: Download Offline (youtube_explode + path_provider)

**Status:** pending
**Phase:** 12 of 15

## Overview

Implement offline download functionality allowing users to download songs for offline playback with progress indication and storage management.

## Tasks

- [ ] Create DownloadService (youtube_explode_dart)
- [ ] Add download button to song tile
- [ ] Download audio to app directory (path_provider)
- [ ] Show download progress indicator
- [ ] Save metadata to Isar with offline flag
- [ ] Check offline availability before streaming
- [ ] Play offline audio without network
- [ ] Delete downloaded files
- [ ] Show downloaded size

## Acceptance Criteria

- Download button visible on every song
- Download progress shows visually
- Downloaded songs marked in library
- Can play offline without internet
- Can delete offline files
- Offline indicator visible in UI

## Tech Notes

- Use path_provider for persistent storage
- Save audio as .m4a or .webm (youtube_explode default)
- Metadata includes: fileName, fileSize, downloadDate
- Implement delete confirmation dialog

## Dependencies

- **Blocked by:** Phase 4 (YouTube Service) and Phase 10 (Library)

---

**Next:** Phase 13 (Video)
