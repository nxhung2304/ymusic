# Security Incident Report & Recovery Guide

## 🚨 Exposed Credentials Alert

Firebase API keys were accidentally committed to the public GitHub repository. These credentials have been exposed and must be rotated immediately.

### Exposed Credentials

The following files contained sensitive information:

1. **`lib/firebase_options.dart`** (commits: b2cbc5cb)
   - Firebase API keys for iOS, Android, Web
   - Firebase App IDs
   - Project IDs

2. **`ios/Runner/GoogleService-Info.plist`** (commit: b2cbc5cb)
   - iOS Firebase configuration
   - API keys

3. **`android/app/google-services.json`** (commit: b2cbc5cb)
   - Android Firebase configuration
   - API keys

### Impact Assessment

- **Risk Level:** HIGH
- **Public Visibility:** Repository is public on GitHub
- **Affected Services:** Firebase, Google Cloud, YouTube API
- **Exposure Duration:** All commits from b2cbc5cb onwards contain exposed credentials

## 🔐 Immediate Actions (DO THIS NOW)

### Step 1: Revoke Exposed API Keys (5 minutes)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select **ymusic-dev** project
3. Go to **APIs & Services** > **Credentials**
4. Find and delete these API keys:
   - `AIzaSyC29rAyY18IL0KYb7-a8Kj9yzcAaQ5Q1xA` (Android)
   - `AIzaSyD8F_gghU4u8eNYeY4p2K8Hy0YQLcP_wHU` (iOS)
   - Any Web API keys visible in commits

5. Go to **APIs & Services** > **OAuth 2.0 Client IDs**
6. Delete any exposed OAuth credentials

### Step 2: Generate New API Keys (5 minutes)

1. **YouTube API Key**
   - Go to **Credentials** > **Create Credentials** > **API Key**
   - Restrict to **YouTube Data API v3** only
   - Set application restrictions (iOS Bundle ID + Android Package)
   - Copy key to `.env`: `FIREBASE_API_KEY_IOS=...`

2. **Firebase API Keys**
   - Go to **Firebase Console** > **Project Settings**
   - Under **Your Apps**, find iOS and Android apps
   - Regenerate Service Account Keys if needed
   - Copy to `.env`:
     - `FIREBASE_API_KEY_IOS=...`
     - `FIREBASE_API_KEY_ANDROID=...`
     - `FIREBASE_API_KEY_WEB=...`

3. **OAuth Client IDs**
   - Go to **OAuth 2.0 Client IDs**
   - Regenerate credentials for iOS and Android
   - Update `.env`: `GOOGLE_OAUTH_CLIENT_ID=...`

### Step 3: Update Local Configuration (2 minutes)

```bash
# Copy template
cp .env.example .env

# Edit .env and fill in NEW credentials (from Step 2)
nano .env

# Verify app starts
flutter pub get
flutter run
```

### Step 4: Clean Git History (Recommended)

**Warning:** This rewrites git history. Only do if no one else is working on this branch.

```bash
# Remove exposed commits from history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch lib/firebase_options.dart \
   ios/Runner/GoogleService-Info.plist \
   android/app/google-services.json' \
  --prune-empty --tag-name-filter cat -- --all

# Force push (⚠️ destructive - talk to team first)
git push origin feature/hung-#1-project-setup --force
```

Or use BFG Repo-Cleaner (easier):
```bash
# Install BFG
brew install bfg

# Remove exposed files
bfg --delete-files '{lib/firebase_options.dart,ios/Runner/GoogleService-Info.plist,android/app/google-services.json}' .

# Clean up
git reflog expire --expire=now --all && git gc --prune=now

# Force push
git push origin feature/hung-#1-project-setup --force
```

## 📋 Checklist

- [ ] Step 1: Revoke exposed API keys in Google Cloud Console
- [ ] Step 2: Generate new API keys with proper restrictions
- [ ] Step 3: Update `.env` with new credentials
- [ ] Step 4: Verify `flutter run` works with new keys
- [ ] Step 5: Clean git history (if team agrees)
- [ ] Step 6: Document in team chat/documentation
- [ ] Step 7: Review other branches for exposed credentials

## ✅ Permanent Fixes Applied

The following security improvements have been implemented:

1. **Code Changes**
   - ✅ `firebase_options.dart` now loads from `.env` (no hardcoded keys)
   - ✅ Environment variables for all sensitive credentials
   - ✅ Proper error handling for missing credentials

2. **Configuration Files**
   - ✅ `.env` added to `.gitignore` (never committed)
   - ✅ `.env.example` documents structure (safe to commit)
   - ✅ Clear comments warning about sensitive data

3. **Documentation**
   - ✅ Enhanced `ENV_SETUP.md` with security warnings
   - ✅ API key restriction guidance
   - ✅ Credential rotation procedures
   - ✅ This incident report

## 🔍 Future Prevention

### Before Every Commit

Run this to detect secrets:
```bash
# Install git-secrets
brew install git-secrets

# Configure for your repo
git secrets --install
git secrets --register-aws

# Or use pre-commit hooks
pip install pre-commit
pre-commit install
```

### Team Best Practices

1. **Never commit:**
   - `.env` files
   - `*.plist` (iOS config)
   - `*.json` with credentials (Android config)
   - Hardcoded API keys

2. **Always:**
   - Use environment variables for sensitive data
   - Add to `.gitignore` before creating
   - Review `.env.example` for documentation
   - Rotate keys if accidentally exposed

3. **Code Review:**
   - Check for hardcoded credentials
   - Ensure `.env` is in `.gitignore`
   - Verify `.env.example` has only structure

## 📞 Questions?

If you need help:
1. Check `ENV_SETUP.md` for detailed configuration
2. Review `CLAUDE.md` project guidelines
3. Contact team lead for credentials management policy

## References

- [Firebase Security Best Practices](https://firebase.google.com/docs/rules/basics)
- [Google Cloud Security Tips](https://cloud.google.com/docs/authentication/best-practices)
- [OWASP Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [git-secrets](https://github.com/awslabs/git-secrets)

---

**Last Updated:** 2026-03-07
**Status:** 🟡 IN PROGRESS - Awaiting credential rotation
