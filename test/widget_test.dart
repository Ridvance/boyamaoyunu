import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocuk_oyun/main.dart';

void main() {
  testWidgets(
    'shows the dashboard with five games and the parent gate button',
    (WidgetTester tester) async {
      // Set screen size to landscape for testing
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const CocukOyunApp());

      expect(find.text('🎨 Sihirli Oyun Dünyası'), findsOneWidget);
      expect(find.byKey(const ValueKey('game-card-coloring')), findsOneWidget);
      expect(find.byKey(const ValueKey('game-card-tracing')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('game-card-balloon_pop')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('game-card-shape_sorter')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('game-card-sound_board')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('game-card-magic_colors')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('parent-gate-button')), findsOneWidget);
    },
  );

  testWidgets('opens parent safety screen through the multi-finger gate', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    // Open gate dialog
    await tester.tap(find.byKey(const ValueKey('parent-gate-button')));
    await tester.pumpAndSettle();

    expect(find.text('Ebeveyn Doğrulaması'), findsOneWidget);

    // Simulate touching screen with 3 fingers simultaneously
    final gesture1 = await tester.startGesture(
      const Offset(500, 350),
      pointer: 1,
    );
    final gesture2 = await tester.startGesture(
      const Offset(600, 350),
      pointer: 2,
    );
    final gesture3 = await tester.startGesture(
      const Offset(700, 350),
      pointer: 3,
    );

    // Pump and wait for 3 seconds timer
    await tester.pump(const Duration(seconds: 4));

    // Lift fingers up
    await gesture1.up();
    await gesture2.up();
    await gesture3.up();
    await tester.pumpAndSettle();

    // Verify parent screen is opened
    expect(find.text('Ebeveyn Kontrol Paneli'), findsOneWidget);
    expect(find.text('Sıfır Reklam Gösterimi'), findsOneWidget);
    expect(find.text('Ödeme Duvarı Yok'), findsOneWidget);
    expect(find.text('İnternetsiz / Çevrimdışı Çalışma'), findsOneWidget);

    // Go back
    await tester.tap(find.byKey(const ValueKey('parent-back-button')));
    await tester.pumpAndSettle();

    expect(find.text('🎨 Sihirli Oyun Dünyası'), findsOneWidget);
  });

  testWidgets('can open each game from the dashboard and return', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    // 1. Coloring Game
    await tester.tap(find.byKey(const ValueKey('game-card-coloring')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // 2. Tracing Game
    await tester.tap(find.byKey(const ValueKey('game-card-tracing')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back_rounded), findsAtLeast(1));
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // 3. Balloon Pop Game
    await tester.tap(find.byKey(const ValueKey('game-card-balloon_pop')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    final backBtn = find.byKey(const ValueKey('balloon-game-back-button'));
    await tester.tap(backBtn);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(backBtn);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // 4. Shape Sorter Game
    await tester.tap(find.byKey(const ValueKey('game-card-shape_sorter')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back_rounded), findsAtLeast(1));
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // 5. Sound Board Game
    await tester.tap(find.byKey(const ValueKey('game-card-sound_board')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back_rounded), findsAtLeast(1));
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // 6. Magic Colors Game
    await tester.tap(find.byKey(const ValueKey('game-card-magic_colors')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('magic-colors-back-button')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('magic-colors-back-button')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('🎨 Sihirli Oyun Dünyası'), findsOneWidget);
  });

  testWidgets('coloring game advances the three-step story flow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-coloring')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.byKey(const ValueKey('story-flow-panel')), findsOneWidget);
    expect(find.byKey(const ValueKey('story-step-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('story-step-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('story-step-2')), findsOneWidget);

    await tapColoringCanvasAt(tester, const Offset(160, 145)); // roof
    await tester.pump();
    await tapColoringCanvasAt(tester, const Offset(170, 250)); // wall
    await tester.pump();
    await tapColoringCanvasAt(tester, const Offset(200, 300)); // door
    await tester.pump();
    await tapColoringCanvasAt(tester, const Offset(130, 235)); // left window
    await tester.pump();
    await tapColoringCanvasAt(tester, const Offset(270, 235)); // right window
    await tester.pump();
    await tapColoringCanvasAt(tester, const Offset(200, 115)); // attic window
    await tester.pump();

    expect(find.byKey(const ValueKey('story-complete-panel')), findsOneWidget);
  });

  testWidgets('magic colors mixes two primary colors into orange', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-magic_colors')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('magic-colors-mode-sandbox')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('magic-colors-tube-Kırmızı')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('magic-colors-tube-Sarı')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('magic-colors-mix-button')));
    await tester.pump();

    expect(find.text('Turuncu'), findsWidgets);
  });

  testWidgets('habits game completes three daily habit tasks', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('game-card-habits')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('game-card-habits')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('habit-action-toys')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('habit-action-teeth')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('habit-action-trash')));
    await tester.pump();

    expect(find.byKey(const ValueKey('habits-complete-panel')), findsOneWidget);
  });
}

Future<void> tapColoringCanvasAt(
  WidgetTester tester,
  Offset virtualPoint,
) async {
  final finder = find.byKey(const ValueKey('coloring-canvas-touch-area'));
  final topLeft = tester.getTopLeft(finder);
  final size = tester.getSize(finder);
  final side = size.shortestSide;
  final offsetX = (size.width - side) / 2;
  final offsetY = (size.height - side) / 2;
  final localPoint = Offset(
    offsetX + (virtualPoint.dx / 400) * side,
    offsetY + (virtualPoint.dy / 400) * side,
  );

  await tester.tapAt(topLeft + localPoint);
}
