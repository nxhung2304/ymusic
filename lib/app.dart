import 'package:flutter/material.dart';

import 'package:ymusic/core/theme/app_theme.dart';

class YMusicApp extends StatelessWidget {
  const YMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMusic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: Center(
          child: Text('YMusic'),
        ),
      ),
    );
  }
}
