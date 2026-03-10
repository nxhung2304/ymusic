## **Status:**
- Review: Approved
- PR: Draft

## Metadata
- **Title:** Build Login Screen UI with Google Sign In button
- **Phase:** 2. Authentication
- **GitHub Issue:** #5
- **Labels:** phase-2, feature

---

## Description
- Create Login Screen UI with clean, minimal design
- Display Google Sign In button prominently
- Show app logo and branding
- Display loading state during authentication
- Error message display for failed sign-in
- Responsive layout for mobile and tablet

---

## Dependencies
No new packages needed (firebase_auth and google_sign_in already in pubspec.yaml)

---

## Design
- Clean, modern Material Design
- Center-aligned button layout
- Dark theme consistent with app
- Loading spinner overlay during sign-in

---

## Acceptance Criteria
- [ ] LoginScreen widget created in lib/presentation/screens/auth/
- [ ] Google Sign In button styled and functional
- [ ] Loading state shows during authentication
- [ ] Error snackbar displays on sign-in failure
- [ ] Responsive on mobile and tablet sizes
- [ ] Proper SafeArea handling
- [ ] flutter analyze — 0 warnings

---

## Implementation Checklist
- [ ] Create LoginScreen widget
- [ ] Design button and layout
- [ ] Connect to authProvider from Riverpod
- [ ] Handle loading state
- [ ] Handle error state with snackbar
- [ ] Test on multiple screen sizes
- [ ] Code follows project conventions

---

## Notes
- Refer to Material Design guidelines for button styling
- Use flutter_riverpod for state management
- Ensure proper error handling and user feedback
- Test with actual Google Sign In flow

