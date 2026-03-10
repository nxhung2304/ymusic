import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:ymusic/core/theme/app_theme.dart';
import 'package:ymusic/features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables from .env file
    // Note: If .env doesn't exist, app will still run with placeholder values
    await dotenv.load(fileName: '.env').catchError((error) {
      debugPrint('Warning: Could not load .env file: $error');
      debugPrint('Using placeholder values or environment variables');
      return;
    });

    // Initialize Firebase for iOS
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.ios,
      );
      debugPrint('✓ Firebase initialized successfully');
    } catch (e) {
      debugPrint('⚠️  Firebase initialization error: $e');
      debugPrint('App will run without Firebase. Ensure credentials are configured.');
      // Continue running app even if Firebase fails
    }

    runApp(
      const ProviderScope(
        child: MainApp(),
      ),
    );
  } catch (e) {
    debugPrint('❌ Fatal error during app initialization: $e');
    // Show error screen
    runApp(ErrorApp(error: e.toString()));
  }
}


// Fallback error screen
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMusic',
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
