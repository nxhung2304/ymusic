# PRD — Flutter Music App (Personal YT Music Client)

## 1. Tổng quan

**Tên app:** Ymusic
**Nền tảng:** Android & iOS (Flutter)  
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

## 4. Tính năng

### 4.1 Authentication
- [ ] Đăng nhập bằng Google Account (Firebase Auth)
- [ ] Lưu session, tự đăng nhập lại
- [ ] Sync data tự động khi đăng nhập cùng account trên iPad/iPhone
- [ ] Đăng xuất

### 4.2 Tìm kiếm
- [ ] Thanh tìm kiếm bài hát / nghệ sĩ / album
- [ ] Hiển thị kết quả: thumbnail, tên bài, tên kênh, thời lượng
- [ ] Tìm kiếm gợi ý (autocomplete)

### 4.3 Phát nhạc
- [ ] Stream audio (không video) từ YouTube
- [ ] Play / Pause / Next / Previous
- [ ] Seek (tua)
- [ ] Hiển thị thumbnail, tên bài, tên nghệ sĩ
- [ ] Background playback (tắt màn hình vẫn nghe)
- [ ] Lock screen controls + notification player

### 4.4 Lyrics real-time
- [ ] Fetch lyrics từ `lrclib.net` theo tên bài + nghệ sĩ
- [ ] Hiển thị lyrics sync theo timestamp (karaoke style)
- [ ] Fallback: hiển thị plain text nếu không có timestamp

### 4.5 Video playback
- [ ] Chuyển chế độ Audio ↔ Video
- [ ] Phát video full screen
- [ ] `youtube_explode_dart` lấy video stream URL
- [ ] `chewie` làm video player UI

### 4.6 Tải nhạc offline
- [ ] Nút download trên từng bài
- [ ] `youtube_explode_dart` download audio → lưu local qua `path_provider`
- [ ] Hiển thị danh sách nhạc đã tải
- [ ] Phát offline không cần mạng
- [ ] Xóa bài đã tải

### 4.7 Podcast
- [ ] Tìm kiếm podcast qua RSS feed URL
- [ ] `webfeed` parse RSS → danh sách tập
- [ ] Phát audio podcast qua `just_audio`
- [ ] Lưu podcast đã subscribe vào Firestore

### 4.8 Queue & Playlist
- [ ] Hàng chờ phát (queue)
- [ ] Thêm bài vào queue
- [ ] Shuffle / Repeat (off / one / all)
- [ ] Tạo playlist cá nhân → lưu Firestore
- [ ] Thêm / xóa bài khỏi playlist

### 4.9 Thư viện cá nhân
- [ ] Danh sách yêu thích (liked songs) — sync Firestore
- [ ] Lịch sử nghe gần đây — sync Firestore
- [ ] Playlist đã tạo — sync Firestore
- [ ] Nhạc đã tải offline — local Isar

### 4.10 UI/UX
- [ ] Bottom navigation: Home / Search / Library
- [ ] Mini player (bottom bar)
- [ ] Full screen player với lyrics tab
- [ ] Dark mode mặc định
- [ ] Hiệu ứng blur / glassmorphism cho player
- [ ] Adaptive layout cho iPad (split view)

---

## 5. Màn hình chính

```
├── Splash Screen
├── Login Screen (Google Sign In)
├── Home Screen
│   ├── Recently played
│   └── Recommended (dựa theo lịch sử)
├── Search Screen
│   ├── Search bar
│   └── Search results list
├── Library Screen
│   ├── Liked songs
│   ├── Recent history
│   ├── My playlists
│   ├── Downloaded songs
│   └── Podcasts
├── Playlist Detail Screen
├── Now Playing Screen (Full player)
│   ├── Tab: Player
│   ├── Tab: Lyrics
│   └── Tab: Queue
├── Video Player Screen
├── Podcast Screen
└── Settings Screen
```

---

## 5.5 Error Handling Strategy

Tất cả services phải wrap logic trong try-catch và trả về kết quả rõ ràng:

| Lỗi | Xử lý |
|---|---|
| Stream không lấy được | Retry 1 lần → hiện snackbar "Không thể phát bài này" |
| YouTube API quota hết | Fallback tìm kiếm qua `youtube_explode_dart` trực tiếp |
| Firestore offline | Đọc từ Isar local, sync lại khi có mạng |
| Download thất bại | Xóa file partial, hiện thông báo lỗi |
| Lyrics không tìm thấy | Ẩn tab lyrics, không crash |

---

## 6. Luồng chính

### Phát nhạc
```
User tìm kiếm
  → Chọn bài
  → Kiểm tra có file offline không (Isar)
  → Nếu có → phát local
  → Nếu không → youtube_explode_dart lấy audio URL
  → just_audio stream URL
  → audio_service quản lý background session
  → Fetch lyrics từ lrclib.net song song
  → Hiển thị player + lyrics
```

### Đăng nhập & Sync
```
App khởi động
  → Kiểm tra Firebase Auth session
  → Nếu có → load data từ Firestore → merge với Isar local
  → Nếu không → màn hình Login → Google Sign In → Firebase Auth
```

### Tải offline
```
User nhấn Download
  → youtube_explode_dart lấy audio stream
  → Tải file về path_provider directory
  → Lưu metadata vào Isar
  → Hiển thị trong Library > Downloaded
```

---

## 7. Cấu trúc thư mục (gợi ý)

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   │   ├── song.dart
│   │   ├── playlist.dart
│   │   ├── podcast.dart
│   │   └── lyrics.dart
│   ├── repositories/
│   │   ├── music_repository.dart
│   │   ├── playlist_repository.dart
│   │   └── podcast_repository.dart
│   └── services/
│       ├── auth_service.dart
│       ├── youtube_service.dart
│       ├── audio_service.dart
│       ├── firestore_service.dart
│       ├── lyrics_service.dart
│       ├── download_service.dart
│       └── podcast_service.dart
├── presentation/
│   ├── screens/
│   │   ├── home/
│   │   ├── search/
│   │   ├── library/
│   │   ├── player/
│   │   ├── video/
│   │   ├── podcast/
│   │   └── auth/
│   ├── widgets/
│   │   ├── mini_player.dart
│   │   ├── song_tile.dart
│   │   ├── playlist_card.dart
│   │   ├── lyrics_view.dart
│   │   └── download_button.dart
│   └── providers/
└── router/
    └── app_router.dart  ← dùng go_router
```

---

## 8. Thứ tự build gợi ý

1. **Setup project** — Flutter init, dependencies, Firebase config, theme
2. **Auth** — Google Sign In + Firebase Auth
3. **Firestore Service** — CRUD cơ bản cho playlist, liked, history
4. **YouTube Service** — tìm kiếm + lấy audio URL
5. **Audio Player** — just_audio + audio_service cơ bản
6. **UI Player** — mini player + full player
7. **Search Screen**
8. **Queue & Repeat / Shuffle**
9. **Library** — liked, history, playlist (sync Firestore)
10. **Lyrics** — fetch + hiển thị sync
11. **Download offline** — tải + phát local
12. **Video playback**
13. **Podcast**
14. **iPad adaptive layout**
15. **Polish** — animation, dark mode, UX

---

## 9. Giới hạn & lưu ý

- App chỉ dùng cá nhân, không distribute
- `youtube_explode_dart` có thể bị break khi YouTube thay đổi API nội bộ — cần update package thường xuyên
- YouTube Data API v3 có quota miễn phí 10,000 units/ngày — đủ dùng cá nhân
- Cần tạo Google Cloud Project để lấy API Key và OAuth Client ID
- Firebase Firestore free tier (Spark plan) đủ dùng cá nhân: 50,000 reads / 20,000 writes mỗi ngày
- `lrclib.net` hoàn toàn miễn phí, không cần API key
- **iOS Background Audio:** Cần bật entitlement `Audio, AirPlay, and Picture in Picture` trong Xcode → Signing & Capabilities, và set `UIBackgroundModes: audio` trong Info.plist
- **Firebase Security Rules:** Chỉ cho phép user đọc/ghi data của chính mình. Rule cơ bản:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 10. Ngoài phạm vi (Out of scope)

- Multi-user / social features
- Upload nhạc lên cloud
- Equalizer / audio effects
