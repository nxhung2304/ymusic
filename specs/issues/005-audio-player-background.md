# Phase 5: Audio Player (just_audio + audio_service)

**Status:** pending
**Phase:** 5 of 15

## Overview

Implement core audio playback with background support, lock screen controls, and native notification controls for both iOS and Android.

## Tasks

- [ ] Setup just_audio with audio sources
- [ ] Integrate audio_service for background playback
- [ ] Create AudioPlayerService (play, pause, next, previous, seek)
- [ ] Create Riverpod provider for player state
- [ ] Setup iOS background modes (Audio, AirPlay, Picture in Picture)
- [ ] Setup Android background audio entitlements
- [ ] Implement lock screen controls (iOS/Android native)
- [ ] Add notification player for background control
- [ ] Handle audio stream errors with retry logic

## Acceptance Criteria

- Audio plays from YouTube stream URL
- Play/pause/next/previous works smoothly
- Notification controls work in background
- Lock screen shows current track
- App doesn't crash when backgrounded
- Retry attempts stream if failed

## Tech Notes

- iOS: Enable Audio entitlement in Xcode
- iOS: Add UIBackgroundModes: audio in Info.plist
- Android: Use AudioService for background management
- All errors wrapped in try-catch per PRD

## Dependencies

- **Blocked by:** Phase 4 (YouTube Service)
- **Used by:** Phase 6 (Player UI), Phase 9 (Queue), Phase 14 (Podcast)

---

**Next:** Phase 6 (Player UI)
