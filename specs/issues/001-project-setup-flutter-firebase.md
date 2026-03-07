# Phase 1: Initialize Flutter Project, Dependencies, and Firebase Config

**Status:** Approved
**Phase:** 1 of 15
**GitHub Issue:** #1

## Overview

Initialize the Flutter project with null safety enabled, install all required dependencies, and configure Google Cloud and Firebase projects for authentication and real-time data sync.

## Tasks

- [ ] Create Flutter project with null safety enabled
- [ ] Add all required dependencies (flutter_pubspec)
- [ ] Setup Google Cloud Project → OAuth 2.0 credentials
- [ ] Setup Firebase project → download google-services.json + GoogleService-Info.plist
- [ ] Configure Firebase in pubspec.yaml
- [ ] Setup theme (dark mode default, colors, typography)
- [ ] Create folder structure per PRD spec
- [ ] Create constants file (API endpoints, theme colors)

## Acceptance Criteria

- Project builds on iOS/Android without errors
- Firebase console accessible and configured
- Theme provider ready for app-wide use
- All core dependencies resolve without conflicts

## Tech Notes

- Ensure Flutter 3.x+ installed
- Need Google Developer account for API keys
- Firebase Spark plan sufficient

## Dependencies

None - this is the foundation phase

---

**Next:** Phase 2 (Google Sign In & Firebase Auth)
