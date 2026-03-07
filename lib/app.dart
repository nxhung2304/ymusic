import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMusic',
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: Text('YMusic - Coming Soon'),
        ),
      ),
    );
  }
}
