# Phase 2: Google Sign In & Firebase Auth Session Management

**Status:** Completed
**Phase:** 2 of 15
**GitHub Issue:** #2

## Overview

Implement Google Sign In and Firebase Authentication with session persistence, auto-login on app launch, and graceful error handling.

## Tasks

- [ ] Setup google_sign_in + firebase_auth packages
- [ ] Create AuthService with login/logout/session check logic
- [ ] Create Riverpod provider for auth state
- [ ] Build Login Screen with Google Sign In button
- [ ] Build Splash Screen (check session on app launch)
- [ ] Auto-login if session exists
- [ ] Handle sign-in errors (show snackbar)
- [ ] Store user profile data

## Acceptance Criteria

- User can sign in with Google Account
- Session persists across app closes
- User auto-logs in if session active
- Logout clears session properly
- Errors handled gracefully

## Tech Notes

- iOS: Add GIDSignInButton to Info.plist
- Android: Add Google-services plugins
- Use Riverpod for state persistence

## Dependencies

- **Blocked by:** Phase 1 (Project Setup)

---

**Next:** Phase 3 (Firestore Service & Basic Data Models)
