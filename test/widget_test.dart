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

  testWidgets('drawing updates repaint data while the finger moves', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('page-cat')));
    await tester.pumpAndSettle();

    final canvasFinder = find.byKey(const ValueKey('drawing-canvas'));
    final beforePaint =
        tester
                .widget<CustomPaint>(
                  find.descendant(
                    of: canvasFinder,
                    matching: find.byType(CustomPaint),
                  ),
                )
                .painter!
            as ColoringPainter;

    await tester.drag(canvasFinder, const Offset(80, 20));
    await tester.pump();

    final afterPaint =
        tester
                .widget<CustomPaint>(
                  find.descendant(
                    of: canvasFinder,
                    matching: find.byType(CustomPaint),
                  ),
                )
                .painter!
            as ColoringPainter;

    expect(identical(afterPaint.strokes, beforePaint.strokes), isFalse);
    expect(afterPaint.strokes, isNotEmpty);
    expect(afterPaint.strokes.last.points.length, greaterThan(1));
  });

  testWidgets('opens the separated parent safety area through the gate', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('parent-gate-button')));
    await tester.pumpAndSettle();
    expect(find.text('Ebeveyn alani'), findsOneWidget);

    await tester.longPress(find.byKey(const ValueKey('parent-unlock-button')));
    await tester.pumpAndSettle();

    expect(find.text('Ebeveyn'), findsOneWidget);
    expect(find.text('Reklam yok'), findsOneWidget);
    expect(find.text('Odeme yok'), findsOneWidget);
    expect(find.text('Dis link yok'), findsOneWidget);
    expect(find.text('Kamera galeri yok'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('parent-back-button')));
    await tester.pumpAndSettle();

    expect(find.text('Boyama'), findsOneWidget);
  });
}
