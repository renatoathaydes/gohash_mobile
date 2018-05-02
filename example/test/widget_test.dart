import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gohash_mobile_example/main.dart';

void main() {
  testWidgets('Verify go-hash groups are loaded', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data.startsWith('default'),
        ),
        findsOneWidget);

    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data.startsWith('personal'),
        ),
        findsOneWidget);
  });
}
