# Phase 3: Firestore Service & Basic Data Models

**Status:** pending
**Phase:** 3 of 15
**GitHub Issue:** (to be filled after sync)

## Overview

Setup Firestore cloud database and Isar local database with data models for Song, Playlist, UserPreference, and History. Implement CRUD operations and sync conflict resolution.

## Tasks

- [ ] Create models: Song, Playlist, UserPreference, History
- [ ] Create FirestoreService with CRUD methods
- [ ] Setup Firestore Security Rules (user-scoped access)
- [ ] Create repositories: PlaylistRepository, UserRepository
- [ ] Test Firestore read/write in emulator
- [ ] Implement sync conflict resolution (last-write-wins with timestamp)
- [ ] Setup Isar local database schema
- [ ] Create IsarService for local persistence

## Acceptance Criteria

- Can create/read/update/delete playlists in Firestore
- Firestore rules enforce user-scoped access
- Local Isar mirrors Firestore data structure
- Timestamp tracking for conflict resolution works
- No Firestore write errors on production rules

## Tech Notes

- Use Firestore emulator for testing
- Every document must have `updatedAt` field
- Isar schema matches Firestore data model

## Dependencies

- **Blocked by:** Phase 2 (Authentication)

---

**Next:** Phase 4 (YouTube Service), Phase 10 (Library Screen)
