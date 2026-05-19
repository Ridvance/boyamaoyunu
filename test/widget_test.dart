import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocuk_oyun/main.dart';

void main() {
  testWidgets('shows three coloring pages on the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CocukOyunApp());

    expect(find.text('Cocuk Oyun'), findsOneWidget);
    expect(find.text('Boyama'), findsOneWidget);
    expect(find.text('Kedi'), findsOneWidget);
    expect(find.text('Sekiller'), findsOneWidget);
    expect(find.text('Oyuncak'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });

  testWidgets('opens a coloring page and exposes drawing tools', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('page-cat')));
    await tester.pumpAndSettle();

    expect(find.text('Kedi'), findsOneWidget);
    expect(find.byKey(const ValueKey('drawing-canvas')), findsOneWidget);
    expect(find.byKey(const ValueKey('clear-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('eraser-button')), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('drawing-canvas')),
      const Offset(80, 20),
    );
    await tester.tap(find.byKey(const ValueKey('eraser-button')));
    await tester.tap(find.byKey(const ValueKey('clear-button')));
    await tester.tap(find.byKey(const ValueKey('back-button')));
    await tester.pumpAndSettle();

    expect(find.text('Boyama'), findsOneWidget);
  });
}
