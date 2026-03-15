## 1. Tổng quan

**Tên app:** Ymusic
**Nền tảng:** iOS (Flutter)
**Mục đích:** App nghe nhạc cá nhân, stream audio từ YouTube, không quảng cáo
**Người dùng:** Cá nhân, không publish store
**Thiết bị:** iPhone + iPad (sync đa thiết bị)
Ngôn ngữ: hỗ trợ tiếng Anh / tiếng Việt

---

## 2. Mục tiêu

- Trải nghiệm nghe nhạc sạch, không ads
- Đăng nhập bằng tài khoản Google
- Tìm kiếm và phát nhạc từ YouTube
- Phát nhạc nền (background playback)
- Giao diện tương tự YouTube Music
- Sync dữ liệu giữa iPhone và iPad
- Nghe offline (tải về)
- Xem lyrics real-time
- Xem video và nghe podcast

---

## 3. Tech Stack

| Thành phần | Package |
|---|---|
| UI Framework | Flutter 3.x |
| Đăng nhập | `google_sign_in` + `firebase_auth` |
| Lấy audio/video stream | `youtube_explode_dart` |
| Phát nhạc | `just_audio` |
| Phát video | `video_player` + `chewie` |
| Background playback | `audio_service` |
| Tìm kiếm YouTube | YouTube Data API v3 |
| State management | `riverpod` |
| Cloud database | `cloud_firestore` |
| Local cache / offline | `isar` |
| HTTP | `dio` |
| Lyrics | `lrclib.net` API (free) |
| Podcast | `webfeed` (RSS parser) |
| File storage offline | `path_provider` |
| Navigation | `go_router` |

### Phân chia database

| Lưu ở đâu | Dữ liệu |
|---|---|
| **Firestore** | Playlist, liked songs, lịch sử nghe, settings |
| **Isar (local)** | Audio đã tải offline, cache metadata |
| **Firestore + Isar** | Preferences (sync cloud, fallback local) |

### Conflict resolution (multi-device)
- **Strategy:** last-write-wins dựa theo timestamp
- Mỗi document Firestore có field `updatedAt`
- Khi sync, so sánh `updatedAt` local vs cloud → lấy bản mới hơn
- Riêng **liked songs / playlist**: dùng union merge (không xóa bài nếu thêm từ thiết bị khác)

---

## 4. Firestore Schema

Tất cả data của user nằm dưới `/users/{uid}/` để Security Rules đơn giản.

```
/users/{uid}/
  ├── liked_songs/{songId}
  │     videoId, title, artist, thumbnailUrl, duration, addedAt, updatedAt
  │
  ├── history/{historyId}
  │     videoId, title, artist, thumbnailUrl, duration, playedAt, updatedAt
  │
  ├── playlists/{playlistId}
  │     name, description, coverUrl, createdAt, updatedAt
  │     └── songs/{songId}
  │           videoId, title, artist, thumbnailUrl, duration, addedAt
  │
  ├── subscribed_podcasts/{podcastId}
  │     feedUrl, title, description, coverUrl, subscribedAt, updatedAt
  │     └── episode_progress/{episodeId}
  │           position (seconds), duration, updatedAt
  │
  └── preferences/settings
        theme, language, repeatMode, shuffleEnabled, updatedAt
```

**Quy tắc:**
- `songId` = YouTube `videoId` (dùng làm document ID để dedup tự động)
- `historyId` = `videoId` (overwrite khi nghe lại — giữ entry mới nhất)
- `playlistId` = Firestore auto-ID
- Mọi document có `updatedAt: Timestamp` để conflict resolution

## 5. Interactice
- Slack:
  - Slack Channel ID: C0AGTJ0EE6B
  - User id: U01RC2ZPYJW
