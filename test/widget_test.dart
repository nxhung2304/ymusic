import 'package:flutter_test/flutter_test.dart';

import 'package:ymusic/app.dart';

void main() {
  testWidgets('App renders YMusic placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const YMusicApp());
    expect(find.text('YMusic'), findsOneWidget);
  });
}
