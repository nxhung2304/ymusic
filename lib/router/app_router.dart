import 'package:go_router/go_router.dart';
import 'package:ymusic/features/auth/presentation/screens/login_screen.dart';
import 'package:ymusic/features/auth/presentation/screens/splash_screen.dart';
import 'package:ymusic/features/home/presentation/screens/home_screen.dart';

class AppRoutes {
  static const splash = 'splash';
  static const login = 'login';
  static const home = 'home';
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: AppRoutes.splash,
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: AppRoutes.login,
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.home,
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
