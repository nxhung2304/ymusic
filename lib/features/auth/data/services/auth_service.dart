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
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return const Success(null);
      }

      final userModel = UserModel(
        uid: currentUser.uid,
        email: currentUser.email ?? '',
        displayName: currentUser.displayName ?? '',
        photoUrl: currentUser.photoURL,
      );
      return Success(userModel);
    } catch (e) {
      return Failure(AuthFailure('Lỗi kiểm tra phiên đăng nhập: $e'));
    }
  }

  /// Sign in with Google
  Future<Result<UserModel>> signInWithGoogle() async {
    try {
      // Trigger sign-in flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Failure(
          AuthFailure('Đăng nhập Google bị hủy bỏ'),
        );
      }

      // Get auth tokens from Google
      final googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return Failure(
          AuthFailure('Không thể lấy thông tin người dùng'),
        );
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
      );

      return Success(userModel);
    } on FirebaseAuthException catch (e) {
      return Failure(
        AuthFailure('Lỗi Firebase: ${e.message}'),
      );
    } catch (e) {
      return Failure(
        AuthFailure('Lỗi đăng nhập: $e'),
      );
    }
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      return const Success(null);
    } catch (e) {
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
