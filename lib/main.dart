import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(
    options: _getFirebaseOptions(),
  );

  runApp(const MainApp());
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
