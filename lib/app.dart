import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/constants/app_strings.dart';
import 'package:ymusic/core/theme/app_theme.dart';
import 'package:ymusic/features/auth/presentation/screens/login_screen.dart';

class YMusicApp extends StatelessWidget {
  const YMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: AppStrings.title,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const LoginScreen(),
      ),
    );
  }
}
