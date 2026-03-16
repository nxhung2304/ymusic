# Environment Configuration Setup

This document explains how to configure environment variables for YMusic using `.env` files.

## ⚠️ SECURITY WARNING - READ THIS FIRST

**CRITICAL:** The `.env` file contains sensitive Firebase API keys and credentials that could compromise your entire app if exposed.

- ✅ `.env` is listed in `.gitignore` - it will NOT be committed
- ✅ `.env.example` is safe to commit - it contains ONLY structure/documentation
- ❌ NEVER commit `.env` file to version control
- ❌ NEVER hardcode API keys in source code
- ❌ NEVER push credentials to GitHub or public repos

If you accidentally expose credentials:
1. **Immediately rotate all keys** in Firebase/Google Cloud Console
2. Revoke old API keys
3. Generate new ones
4. Update `.env` with new values

## Overview

YMusic uses `flutter_dotenv` package to manage sensitive configuration and environment-specific settings. This allows developers to keep secrets out of version control while maintaining flexibility across different environments (development, staging, production).

## Quick Start

### 1. Create Your .env File

Copy the provided example and fill in your actual values:

```bash
cp .env.example .env
```

### 2. Configure Required Values

Edit `.env` and replace placeholder values with your actual credentials:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-actual-project-id
FIREBASE_WEB_API_KEY=your-actual-firebase-key

# Google Cloud & YouTube API
YOUTUBE_API_KEY=your-actual-youtube-api-key
GOOGLE_OAUTH_CLIENT_ID=your-actual-oauth-client-id.apps.googleusercontent.com

# App Configuration
APP_ENV=development
LOG_LEVEL=debug
```

### 3. Run the App

```bash
flutter pub get
flutter run
```

## Environment Variables

### Required (will throw error if not set correctly)

| Variable | Description | Example |
|----------|-------------|---------|
| `YOUTUBE_API_KEY` | YouTube Data API v3 key from Google Cloud Console | `AIzaXXXXXXXXXXXX...` |
| `GOOGLE_OAUTH_CLIENT_ID` | OAuth 2.0 Client ID for Google Sign In | `xxxxx.apps.googleusercontent.com` |

### Optional (with defaults)

| Variable | Default | Description |
|----------|---------|-------------|
| `FIREBASE_PROJECT_ID` | `ymusic-dev` | Firebase project identifier |
| `APP_ENV` | `development` | Application environment |
| `LOG_LEVEL` | `debug` | Logging verbosity level |
| `ENABLE_ANALYTICS` | `false` | Enable Firebase Analytics |
| `ENABLE_CRASH_REPORTING` | `false` | Enable crash reporting |

## Accessing Environment Variables

### In Code

Use `AppConstants` getters to access environment variables:

```dart
import 'package:ymusic/core/constants/app_constants.dart';

// Access API key
String apiKey = AppConstants.youtubeApiKey;

// Access app environment
String env = AppConstants.appEnv;

// Check feature flags
if (AppConstants.enableAnalytics) {
  // Initialize analytics
}
```

### In Tests

Create test-specific `.env` files:

```bash
cp .env.example .env.test
```

## Security Best Practices

### ✅ Do's

- **Keep `.env` out of version control** — it's listed in `.gitignore`
- **Use `.env.example`** as a template for documentation
- **Rotate API keys regularly** — especially if accidentally committed
- **Use strong, unique credentials** for each environment
- **Share `.env` file securely** with your team (e.g., password manager, secure channel)

### ❌ Don'ts

- **Never commit `.env` file** to Git
- **Never hardcode secrets** in source code
- **Never share credentials via email** or chat
- **Don't use same keys for dev and production**

## Setting Up Google Cloud Credentials

### YouTube API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **YouTube Data API v3**
4. Go to **Credentials** → Create API Key
5. ⚠️ **IMPORTANT:** Apply API key restrictions:
   - Restrict to **YouTube Data API v3** only
   - Set application restrictions (iOS Bundle ID)
   - This prevents misuse if key is accidentally exposed
6. Copy the key and paste in `.env` (NEVER in source code):
   ```env
   YOUTUBE_API_KEY=AIzaSy...
   ```

### Google OAuth Client ID

1. In Google Cloud Console, go to **OAuth consent screen**
2. Configure consent screen (add required fields)
3. Go to **Credentials** → Create OAuth 2.0 Client ID
   - Application type: **iOS**
   - Add authorized redirect URIs
4. ⚠️ **IMPORTANT:** Restrict OAuth usage:
   - Only allow authentication for your app domain
   - Monitor usage for suspicious activity
5. Copy Client ID and paste in `.env`:
   ```env
   GOOGLE_OAUTH_CLIENT_ID=xxx.apps.googleusercontent.com
   ```

### Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project or select existing
3. Go to Project Settings
4. Copy **Project ID**:
   ```env
   FIREBASE_PROJECT_ID=ymusic-dev
   ```

## Environment-Specific Configurations

### Development (.env)
```env
APP_ENV=development
LOG_LEVEL=debug
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
```

### Production (.env.prod)
Create for production builds:
```env
APP_ENV=production
LOG_LEVEL=info
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
```

To use: `flutter run --dart-define-from-file=.env.prod`

## Troubleshooting

### "API key not configured" error

**Problem:** The app throws an exception about missing YouTube API key

**Solution:**
1. Verify `.env` file exists in project root
2. Check `YOUTUBE_API_KEY` is not the placeholder value
3. Verify API key is valid in Google Cloud Console
4. Run `flutter pub get` to reload assets

### Environment variable not loading

**Problem:** `dotenv.env['VARIABLE_NAME']` returns null

**Solution:**
1. Check variable name spelling (case-sensitive)
2. Ensure `.env` file is in pubspec.yaml assets:
   ```yaml
   flutter:
     assets:
       - .env
   ```
3. Try `flutter clean && flutter pub get`

### Firebase configuration issues

**Problem:** Firebase initialization fails

**Solution:**
1. Ensure `firebase_options.dart` is properly configured
2. Run `flutterfire configure` to generate platform-specific configs
3. Verify `FIREBASE_PROJECT_ID` matches your actual Firebase project

## CI/CD Integration

For automated builds, set environment variables at build time:

```bash
# GitHub Actions example
- name: Build APK
  env:
    YOUTUBE_API_KEY: ${{ secrets.YOUTUBE_API_KEY }}
    GOOGLE_OAUTH_CLIENT_ID: ${{ secrets.GOOGLE_OAUTH_CLIENT_ID }}
  run: flutter build apk
```

## References

- [flutter_dotenv Documentation](https://pub.dev/packages/flutter_dotenv)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [YouTube Data API Docs](https://developers.google.com/youtube/v3)
