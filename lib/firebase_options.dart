import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration for all platforms
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // TODO: Replace with actual Firebase configuration
    // Use FlutterFire CLI to generate this:
    // `flutterfire configure`

    // This is a placeholder - you need to run flutterfire configure
    // and replace this with the generated config

    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
    );
  }
}
