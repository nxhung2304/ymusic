# Design Mapping

> Project-specific mapping: story keyword → design screen
> File design: `specs/designs/ymusic_design.pen` (mở bằng Pencil MCP)
> Nếu task không có màn hình liên quan → ghi `N/A`

## Format
```
Keyword trong story title/description → Screen name trong .pen file
```

## Mapping

| Keywords | Screen trong .pen |
|---|---|
| splash | Splash Screen |
| login, google sign in, auth screen | Login Screen |
| home, recently played, recommended | Home Screen |
| search, autocomplete, search results, debounce | Search Screen |
| library, tab bar, bottom nav shell | Library Screen |
| liked songs, liked tab | Library - Liked Songs Tab |
| history, recent, history tab | Library - History Tab |
| playlists tab, create playlist | Library - Playlists Tab |
| downloads tab, offline list | Library - Downloads Tab |
| podcasts tab, subscribed | Library - Podcasts Tab |
| mini player, mini bar, persistence | MiniPlayer Component |
| full player, now playing, player screen | Full Player Screen |
| player tab, album art, seek, controls, glassmorphism | Full Player - Player Tab |
| lyrics, lrc, karaoke, sync | Full Player - Lyrics Tab |
| queue, reorder, drag | Full Player - Queue Tab |
| playlist detail, playlist header | Playlist Detail Screen |
| video player, chewie, video screen | Video Player Screen |
| podcast screen, rss, episodes | Podcast Screen |
| settings, theme toggle, language | Settings Screen |
| skeleton, shimmer, loading state | Loading Skeleton State |
| empty search, no results | Empty Search State |
| empty library, no liked | Empty Library State |
| error state, network error, retry, wifi | Error State |
| ipad, split view, adaptive, tablet | iPad Split View |

## Tasks không có design (N/A)
- Setup project, folder structure, constants
- Firebase config, google-services
- Models, repositories, services (data layer)
- Firestore Security Rules
- Sync conflict resolution logic
- Riverpod providers (non-UI)
- go_router setup
- Background audio service handler
- iOS entitlements / Info.plist
- Cache / Isar setup
- Unit tests, widget tests
- Performance audit
- CI/CD, deployment
