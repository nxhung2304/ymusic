import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// Get current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign in with Google and Firebase
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out and clear session
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  /// Listen to auth state changes
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  /// Get current auth state immediately (for splash screen check)
  Future<User?> checkSession() async {
    try {
      // Check if session exists
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Try to refresh token to ensure session is still valid
        await user.getIdToken();
      }
      return user;
    } catch (e) {
      // Session expired or invalid
      await signOut();
      rethrow;
    }
  }

  /// Get user ID token
  Future<String?> getIdToken() async {
    try {
      return await currentUser?.getIdToken();
    } catch (e) {
      rethrow;
    }
  }
}
