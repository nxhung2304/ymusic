import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ymusic/features/auth/presentation/providers/auth_provider.dart';
import 'package:ymusic/features/auth/presentation/screens/login_screen.dart';
import 'package:ymusic/features/home/presentation/screens/home_screen.dart';
import 'package:ymusic/features/home/presentation/screens/app_shell.dart';
import 'package:ymusic/features/search/presentation/screens/search_screen.dart';
import 'package:ymusic/features/home/presentation/screens/library_screen.dart';
import 'package:ymusic/features/player/presentation/screens/full_player_screen.dart';
import 'package:ymusic/features/video/presentation/screens/video_player_screen.dart';
import 'package:ymusic/features/playlist/presentation/screens/playlist_detail_screen.dart';
import 'package:ymusic/features/podcast/presentation/screens/podcast_detail_screen.dart';
import 'package:ymusic/features/settings/presentation/screens/settings_screen.dart';
import 'package:ymusic/features/splash/presentation/screens/splash_screen.dart';

part 'app_router.g.dart';

/// Route path constants
class AppRoutes {
  static const root = '/';
  static const login = '/login';
  static const home = '/home';
  static const search = '/search';
  static const library = '/library';
  static const player = '/player';
  static const video = '/video/:videoId';
  static const playlist = '/playlist/:playlistId';
  static const podcast = '/podcast/:encodedFeedUrl';
  static const settings = '/settings';
}

/// Simple ChangeNotifier used as a Listenable bridge for GoRouter
class _AuthRouterNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Router provider using Riverpod
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final notifier = _AuthRouterNotifier();
  ref.onDispose(notifier.dispose);

  // ref.listen must be called in the provider body, not inside a class constructor
  ref.listen(authStateProvider, (_, __) => notifier.notify());

  return GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      // If still loading → no redirect
      if (authState.isLoading) return null;

      // If error → redirect to login
      if (authState.hasError) return AppRoutes.login;

      // Get user from auth state
      final user = authState.valueOrNull;

      // Handle redirect logic
      return _handleRedirect(user, state.uri.toString());
    },
    routes: [
      /// Splash Screen (public)
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const SplashScreen(),
      ),

      /// Login Screen (public)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      /// App Shell with nested routes (protected)
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          /// Home Screen (tab 0)
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),

          /// Search Screen (tab 1)
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SearchScreen(),
          ),

          /// Library Screen (tab 2)
          GoRoute(
            path: AppRoutes.library,
            builder: (context, state) => const LibraryScreen(),
          ),
        ],
      ),

      /// Full Player Screen (push over shell)
      GoRoute(
        path: AppRoutes.player,
        builder: (context, state) {
          final videoId = state.uri.queryParameters['videoId'];
          return FullPlayerScreen(videoId: videoId);
        },
      ),

      /// Video Player Screen (push)
      GoRoute(
        path: AppRoutes.video,
        builder: (context, state) {
          final videoId = state.pathParameters['videoId']!;
          return VideoPlayerScreen(videoId: videoId);
        },
      ),

      /// Playlist Detail Screen (push)
      GoRoute(
        path: AppRoutes.playlist,
        builder: (context, state) {
          final playlistId = state.pathParameters['playlistId']!;
          return PlaylistDetailScreen(playlistId: playlistId);
        },
      ),

      /// Podcast Detail Screen (push)
      GoRoute(
        path: AppRoutes.podcast,
        builder: (context, state) {
          final encodedFeedUrl = state.pathParameters['encodedFeedUrl']!;
          return PodcastDetailScreen(encodedFeedUrl: encodedFeedUrl);
        },
      ),

      /// Settings Screen (push)
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    /// Initial location: splash screen
    initialLocation: AppRoutes.root,
  );
}

/// Handles redirect logic based on auth state and current route
String? _handleRedirect(User? user, String currentPath) {
  final isLoggedIn = user != null;
  final isAuthRoute = _isAuthRoute(currentPath);
  final isPublicRoute = _isPublicRoute(currentPath);

  // Always leave splash once auth state is known
  if (currentPath == AppRoutes.root) {
    return isLoggedIn ? AppRoutes.home : AppRoutes.login;
  }

  // If user is logged in but still at login → redirect to home
  if (isLoggedIn && currentPath == AppRoutes.login) {
    return AppRoutes.home;
  }

  // If user is not logged in and trying to access protected route → redirect to login
  if (!isLoggedIn && isAuthRoute && !isPublicRoute) {
    return AppRoutes.login;
  }

  // No redirect needed
  return null;
}

/// Check if route requires authentication
bool _isAuthRoute(String path) {
  return path.startsWith(AppRoutes.home) ||
      path.startsWith(AppRoutes.player) ||
      path.startsWith(AppRoutes.video) ||
      path.startsWith(AppRoutes.playlist) ||
      path.startsWith(AppRoutes.podcast) ||
      path.startsWith(AppRoutes.settings);
}

/// Check if route is public
bool _isPublicRoute(String path) {
  return path == AppRoutes.root || path == AppRoutes.login;
}
