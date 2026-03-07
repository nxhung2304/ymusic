import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'app.dart';

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

    // Initialize Firebase with platform-specific configuration
    try {
      await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );
      debugPrint('✓ Firebase initialized successfully');
    } catch (e) {
      debugPrint('⚠️  Firebase initialization error: $e');
      debugPrint('App will run without Firebase. Ensure credentials are configured.');
      // Continue running app even if Firebase fails
    }

    runApp(const MainApp());
  } catch (e) {
    debugPrint('❌ Fatal error during app initialization: $e');
    // Show error screen
    runApp(ErrorApp(error: e.toString()));
  }
}

FirebaseOptions _getFirebaseOptions() {
  if (Platform.isIOS) {
    return DefaultFirebaseOptions.ios;
  } else if (Platform.isAndroid) {
    return DefaultFirebaseOptions.android;
  } else {
    return DefaultFirebaseOptions.web;
  }
}

// Fallback error screen
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Initialization Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
