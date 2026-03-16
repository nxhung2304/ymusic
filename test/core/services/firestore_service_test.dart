import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/services/firestore_service.dart';

const _userDoc = 'users/u1';
const _nonexistentDoc = 'users/nonexistent';
const _songsCollection = 'users/u1/songs';
const _songDoc1 = 'users/u1/songs/s1';
const _songDoc2 = 'users/u1/songs/s2';

const _alice = {'name': 'Alice'};
const _aliceWithAge = {'name': 'Alice', 'age': 30};
const _bob = {'name': 'Bob'};
const _songA = {'title': 'Song A'};
const _songB = {'title': 'Song B'};

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreService(firestore: fakeFirestore);
  });

  group('setDocument', () {
    test('writes document at path', () async {
      await service.setDocument(_userDoc, _alice);

      final snap = await fakeFirestore.doc(_userDoc).get();
      expect(snap.data(), _alice);
    });

    test('overwrites document by default', () async {
      await service.setDocument(_userDoc, _aliceWithAge);
      await service.setDocument(_userDoc, _bob);

      final snap = await fakeFirestore.doc(_userDoc).get();
      expect(snap.data(), _bob);
    });

    test('merge=true keeps existing fields', () async {
      await service.setDocument(_userDoc, _aliceWithAge);
      await service.setDocument(_userDoc, {'name': 'Alice2'}, merge: true);

      final snap = await fakeFirestore.doc(_userDoc).get();
      expect(snap.data(), {'name': 'Alice2', 'age': 30});
    });
  });

  group('getDocument', () {
    test('returns data when document exists', () async {
      await fakeFirestore.doc(_userDoc).set(_alice);

      final result = await service.getDocument(_userDoc);

      expect(result, _alice);
    });

    test('returns null when document does not exist', () async {
      final result = await service.getDocument(_nonexistentDoc);

      expect(result, isNull);
    });
  });

  group('deleteDocument', () {
    test('document no longer exists after delete', () async {
      await fakeFirestore.doc(_userDoc).set(_alice);

      await service.deleteDocument(_userDoc);

      final snap = await fakeFirestore.doc(_userDoc).get();
      expect(snap.exists, isFalse);
    });
  });

  group('getCollection', () {
    test('returns all documents in collection', () async {
      await fakeFirestore.doc(_songDoc1).set(_songA);
      await fakeFirestore.doc(_songDoc2).set(_songB);

      final result = await service.getCollection(_songsCollection);

      expect(result, hasLength(2));
      expect(result.map((e) => e['title']), containsAll(['Song A', 'Song B']));
    });

    test('returns empty list for empty collection', () async {
      final result = await service.getCollection(_songsCollection);

      expect(result, isEmpty);
    });
  });

  group('streamDocument', () {
    test('emits data when document exists', () async {
      await fakeFirestore.doc(_userDoc).set(_alice);

      final stream = service.streamDocument(_userDoc);

      await expectLater(stream, emits(_alice));
    });

    test('emits null when document does not exist', () async {
      final stream = service.streamDocument(_nonexistentDoc);

      await expectLater(stream, emits(isNull));
    });

    test('emits updated data on change', () async {
      await fakeFirestore.doc(_userDoc).set(_alice);

      final stream = service.streamDocument(_userDoc);

      unawaited(
        Future.delayed(
          const Duration(milliseconds: 10),
          () => fakeFirestore.doc(_userDoc).set(_bob),
        ),
      );

      await expectLater(stream, emitsInOrder([_alice, _bob]));
    });
  });

  group('streamCollection', () {
    test('emits list of documents', () async {
      await fakeFirestore.doc(_songDoc1).set(_songA);

      final stream = service.streamCollection(_songsCollection);
      final first = await stream.first;

      expect(first, hasLength(1));
      expect(first.first['title'], 'Song A');
    });

    test('emits empty list for empty collection', () async {
      final stream = service.streamCollection(_songsCollection);

      await expectLater(stream, emits(isEmpty));
    });

    test('emits updated list when document added', () async {
      final stream = service.streamCollection(_songsCollection);

      unawaited(
        Future.delayed(
          const Duration(milliseconds: 10),
          () => fakeFirestore.doc(_songDoc1).set(_songA),
        ),
      );

      await expectLater(stream, emitsInOrder([isEmpty, hasLength(1)]));
    });
  });

  group('FirestoreException', () {
    test('toString includes message', () {
      const ex = FirestoreException('test error');
      expect(ex.toString(), contains('test error'));
    });

    test('toString includes cause when provided', () {
      const ex = FirestoreException('test error', cause: 'root cause');
      expect(ex.toString(), contains('root cause'));
    });
  });
}
