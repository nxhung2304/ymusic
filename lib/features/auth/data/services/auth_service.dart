import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ymusic/core/errors/failures.dart';
import 'package:ymusic/core/errors/result.dart';
import 'package:ymusic/features/auth/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Check if user session exists
  Future<Result<UserModel?>> checkSession() async {
    try {
      debugPrint('🔍 [AuthService] Checking existing session...');
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        debugPrint('ℹ️  [AuthService] No active session found');
        return const Success(null);
      }

      debugPrint('✅ [AuthService] Session found for user: ${currentUser.email}');
      final userModel = UserModel(
        uid: currentUser.uid,
        email: currentUser.email ?? '',
        displayName: currentUser.displayName ?? '',
        photoUrl: currentUser.photoURL,
      );
      return Success(userModel);
    } catch (e) {
      debugPrint('❌ [AuthService] Session check error: $e');
      return Failure(AuthFailure('Lỗi kiểm tra phiên đăng nhập: $e'));
    }
  }

  /// Sign in with Google
  Future<Result<UserModel>> signInWithGoogle() async {
    try {
      debugPrint('🚀 [AuthService] Starting Google Sign In...');

      // Trigger sign-in flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('⚠️  [AuthService] Google Sign In cancelled by user');
        return Failure(
          AuthFailure('Đăng nhập Google bị hủy bỏ'),
        );
      }

      debugPrint('✅ [AuthService] Google Sign In successful: ${googleUser.email}');

      // Get auth tokens from Google
      debugPrint('🔐 [AuthService] Getting Google authentication tokens...');
      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        debugPrint('❌ [AuthService] idToken is null');
        return Failure(
          AuthFailure('Không thể lấy token từ Google'),
        );
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('🔄 [AuthService] Signing in to Firebase...');
      // Sign in to Firebase with credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        debugPrint('❌ [AuthService] Firebase user is null after sign in');
        return Failure(
          AuthFailure('Không thể lấy thông tin người dùng'),
        );
      }

      debugPrint('✅ [AuthService] Firebase sign in successful: ${user.email}');
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
      );

      debugPrint('✅ [AuthService] User model created successfully');
      return Success(userModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ [AuthService] Firebase error: ${e.code} - ${e.message}');
      return Failure(
        AuthFailure('Lỗi Firebase: ${e.message}'),
      );
    } catch (e, st) {
      debugPrint('❌ [AuthService] Unexpected error: $e');
      debugPrint('Stack trace: $st');
      return Failure(
        AuthFailure('Lỗi đăng nhập: $e'),
      );
    }
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    try {
      debugPrint('🚪 [AuthService] Signing out...');
      await _firebaseAuth.signOut();
      debugPrint('✅ [AuthService] Firebase signed out');
      await _googleSignIn.signOut();
      debugPrint('✅ [AuthService] Google signed out');
      return const Success(null);
    } catch (e) {
      debugPrint('❌ [AuthService] Sign out error: $e');
      return Failure(
        AuthFailure('Lỗi đăng xuất: $e'),
      );
    }
  }

  /// Get current user from Firebase
  User? get currentUser => _firebaseAuth.currentUser;

  /// Get auth state stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
