import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/app.dart';

void main() {
  testWidgets('App renders YMusic placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YMusicApp()),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
