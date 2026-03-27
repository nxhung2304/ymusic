import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ymusic/core/error/exceptions.dart';

/// Shared Firestore CRUD wrapper used by all feature repositories.
///
/// Path convention: `/users/{uid}/liked_songs/{songId}`, etc.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _docRef(String path) =>
      _firestore.doc(path);

  CollectionReference<Map<String, dynamic>> _colRef(String path) =>
      _firestore.collection(path);

  /// Writes or overwrites a document at [path].
  /// Pass [merge] = true for partial update (keeps existing fields).
  Future<void> setDocument(
    String path,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      await _docRef(path).set(data, SetOptions(merge: merge));
    } on FirebaseException catch (e) {
      throw FirestoreException('setDocument failed at $path', cause: e);
    } catch (e) {
      throw FirestoreException('setDocument failed at $path', cause: e);
    }
  }

  /// Reads a document at [path].
  /// Returns null if the document does not exist.
  Future<Map<String, dynamic>?> getDocument(String path) async {
    try {
      final snapshot = await _docRef(path).get();

      return snapshot.exists ? snapshot.data() : null;
    } on FirebaseException catch (e) {
      throw FirestoreException('getDocument failed at $path', cause: e);
    } catch (e) {
      throw FirestoreException('getDocument failed at $path', cause: e);
    }
  }

  /// Deletes the document at [path].
  Future<void> deleteDocument(String path) async {
    try {
      await _docRef(path).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException('deleteDocument failed at $path', cause: e);
    } catch (e) {
      throw FirestoreException('deleteDocument failed at $path', cause: e);
    }
  }

  /// Reads all documents in the collection at [path].
  Future<List<Map<String, dynamic>>> getCollection(String path) async {
    try {
      final snapshot = await _colRef(path).get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException('getCollection failed at $path', cause: e);
    } catch (e) {
      throw FirestoreException('getCollection failed at $path', cause: e);
    }
  }

  /// Returns a stream that emits the document at [path] on every change.
  /// Emits null when the document does not exist.
  Stream<Map<String, dynamic>?> streamDocument(String path) {
    try {
      return _docRef(path).snapshots().map(
            (snapshot) => snapshot.exists ? snapshot.data() : null,
          );
    } on FirebaseException catch (e) {
      throw FirestoreException('streamDocument failed at $path', cause: e);
    } catch (e) {
      throw FirestoreException('streamDocument failed at $path', cause: e);
    }
  }

  /// Returns a stream that emits the full collection at [path] on every change.
  Stream<List<Map<String, dynamic>>> streamCollection(String path) {
    try {
      return _colRef(path).snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
          );
    } on FirebaseException catch (e) {
      throw FirestoreException('streamCollection failed at $path', cause: e);
    } catch (e) {
      throw FirestoreException('streamCollection failed at $path', cause: e);
    }
  }
}
