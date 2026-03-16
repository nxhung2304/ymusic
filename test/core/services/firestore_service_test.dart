import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/core/error/exceptions.dart';
import 'package:ymusic/core/services/firestore_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreService(firestore: fakeFirestore);
  });

  group('setDocument', () {
    test('writes document at path', () async {
      await service.setDocument('users/u1', {'name': 'Alice'});

      final snap = await fakeFirestore.doc('users/u1').get();
      expect(snap.data(), {'name': 'Alice'});
    });

    test('overwrites document by default', () async {
      await service.setDocument('users/u1', {'name': 'Alice', 'age': 30});
      await service.setDocument('users/u1', {'name': 'Bob'});

      final snap = await fakeFirestore.doc('users/u1').get();
      expect(snap.data(), {'name': 'Bob'});
    });

    test('merge=true keeps existing fields', () async {
      await service.setDocument('users/u1', {'name': 'Alice', 'age': 30});
      await service.setDocument('users/u1', {'name': 'Alice2'}, merge: true);

      final snap = await fakeFirestore.doc('users/u1').get();
      expect(snap.data(), {'name': 'Alice2', 'age': 30});
    });
  });

  group('getDocument', () {
    test('returns data when document exists', () async {
      await fakeFirestore.doc('users/u1').set({'name': 'Alice'});

      final result = await service.getDocument('users/u1');

      expect(result, {'name': 'Alice'});
    });

    test('returns null when document does not exist', () async {
      final result = await service.getDocument('users/nonexistent');

      expect(result, isNull);
    });
  });

  group('deleteDocument', () {
    test('document no longer exists after delete', () async {
      await fakeFirestore.doc('users/u1').set({'name': 'Alice'});

      await service.deleteDocument('users/u1');

      final snap = await fakeFirestore.doc('users/u1').get();
      expect(snap.exists, isFalse);
    });
  });

  group('getCollection', () {
    test('returns all documents in collection', () async {
      await fakeFirestore.doc('users/u1/songs/s1').set({'title': 'Song A'});
      await fakeFirestore.doc('users/u1/songs/s2').set({'title': 'Song B'});

      final result = await service.getCollection('users/u1/songs');

      expect(result, hasLength(2));
      expect(result.map((e) => e['title']), containsAll(['Song A', 'Song B']));
    });

    test('returns empty list for empty collection', () async {
      final result = await service.getCollection('users/u1/songs');

      expect(result, isEmpty);
    });
  });

  group('streamDocument', () {
    test('emits data when document exists', () async {
      await fakeFirestore.doc('users/u1').set({'name': 'Alice'});

      final stream = service.streamDocument('users/u1');

      await expectLater(stream, emits({'name': 'Alice'}));
    });

    test('emits null when document does not exist', () async {
      final stream = service.streamDocument('users/nonexistent');

      await expectLater(stream, emits(isNull));
    });

    test('emits updated data on change', () async {
      await fakeFirestore.doc('users/u1').set({'name': 'Alice'});

      final stream = service.streamDocument('users/u1');

      unawaited(
        Future.delayed(const Duration(milliseconds: 10), () {
          fakeFirestore.doc('users/u1').set({'name': 'Bob'});
        }),
      );

      await expectLater(
        stream,
        emitsInOrder([
          {'name': 'Alice'},
          {'name': 'Bob'},
        ]),
      );
    });
  });

  group('streamCollection', () {
    test('emits list of documents', () async {
      await fakeFirestore.doc('users/u1/songs/s1').set({'title': 'Song A'});

      final stream = service.streamCollection('users/u1/songs');
      final first = await stream.first;

      expect(first, hasLength(1));
      expect(first.first['title'], 'Song A');
    });

    test('emits empty list for empty collection', () async {
      final stream = service.streamCollection('users/u1/songs');

      await expectLater(stream, emits(isEmpty));
    });

    test('emits updated list when document added', () async {
      final stream = service.streamCollection('users/u1/songs');

      unawaited(
        Future.delayed(const Duration(milliseconds: 10), () {
          fakeFirestore.doc('users/u1/songs/s1').set({'title': 'Song A'});
        }),
      );

      await expectLater(
        stream,
        emitsInOrder([
          isEmpty,
          hasLength(1),
        ]),
      );
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
