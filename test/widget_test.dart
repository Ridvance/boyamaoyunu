import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocuk_oyun/main.dart';
import 'package:cocuk_oyun/games/magic_colors/chameleon_painter.dart';
import 'package:cocuk_oyun/services/guidance_widgets.dart';
import 'package:cocuk_oyun/games/shape_sorter_game.dart';

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
      expect(find.byKey(const ValueKey('fullscreen-button')), findsOneWidget);
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

  testWidgets('learning packs opens an example pack and activity', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('game-card-learning_packs')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('game-card-learning_packs')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('learning-pack-first-skills')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('learning-activity-story-coloring')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('learning-activity-color-mix')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('learning-activity-habits')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('learning-activity-habits')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.byKey(const ValueKey('habit-action-toys')), findsOneWidget);
  });

  testWidgets('coloring game inactivity triggers GhostHandHint and interaction hides it', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-coloring')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify GhostHandHint is not visible initially
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity timer to fire (fires at 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsWidgets);

    // Perform an activity (e.g., tap on the reset button to hide hint)
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();

    // The hint should be gone
    expect(find.byType(GhostHandHint), findsNothing);

    // Pop the route to clean up timers
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('magic colors sandbox mode triggers guidance hand pointing to red tube then mix button', (
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

    // Wait for inactivity timer to fire
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Tap Kırmızı tube
    await tester.tap(find.byKey(const ValueKey('magic-colors-tube-Kırmızı')));
    await tester.pump();

    // Hint should disappear
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait for inactivity again (now it should point to mix button since beaker has 1 slot and next is mix button)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Pop route to clean up timers
    await tester.tap(find.byKey(const ValueKey('magic-colors-back-button')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('ChameleonPainter renders expressions neutral, happy, surprised without error', (
    WidgetTester tester,
  ) async {
    for (final expr in ['neutral', 'happy', 'surprised']) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: ChameleonPainter(
                chameleonColor: Colors.green,
                tongueProgress: 0.0,
                lookTarget: Offset.zero,
                flies: [],
                idleProgress: 0.0,
                isCamouflaged: false,
                chameleonPos: Offset.zero,
                expression: expr,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }
  });

  testWidgets('tracing game inactivity triggers GhostHandHint and interaction hides it', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-tracing')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify GhostHandHint is not visible initially
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity timer to fire (fires at 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsWidgets);

    // Perform an activity (e.g. tap on the reset/refresh button to hide hint)
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();

    // The hint should be gone
    expect(find.byType(GhostHandHint), findsNothing);

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('balloon pop game inactivity triggers GhostHandHint on active balloon', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-balloon_pop')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify GhostHandHint is not visible initially
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity timer to fire (fires at 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsWidgets);

    // Tap on the back button to show exit tooltip, which should reset inactivity
    final backBtn = find.byKey(const ValueKey('balloon-game-back-button'));
    await tester.tap(backBtn);
    await tester.pump();

    // The hint should be gone
    expect(find.byType(GhostHandHint), findsNothing);

    // Double tap back button to exit
    await tester.tap(backBtn);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('shape sorter game inactivity triggers GhostHandHint and PulseTarget, and interaction hides it', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-shape_sorter')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify GhostHandHint is not visible initially
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity timer to fire (fires at 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Trigger an activity by tapping the level badge to reset inactivity
    await tester.tap(find.byKey(const ValueKey('shape-sorter-level-badge')));
    await tester.pump();

    // The hint should be gone
    expect(find.byType(GhostHandHint), findsNothing);

    // Pop the route
    expect(find.byIcon(Icons.arrow_back_rounded), findsAtLeast(1));
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('shape sorter game drag cancel triggers Kamo surprised expression and wiggle feedback', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-shape_sorter')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    final draggableFinder = find.byType(Draggable<ShapeType>);
    expect(draggableFinder, findsWidgets);

    // Cancel drag by dropping in blank space
    final gesture = await tester.startGesture(tester.getCenter(draggableFinder.first));
    await gesture.moveBy(const Offset(0, -100));
    await gesture.up();
    await tester.pump();

    final chameleonFinder = find.byWidgetPredicate(
      (widget) => widget is CustomPaint && widget.painter is ChameleonPainter,
    );
    expect(chameleonFinder, findsOneWidget);
    final kamoPainter = (tester.widget<CustomPaint>(chameleonFinder).painter) as ChameleonPainter;
    expect(kamoPainter.expression, equals('surprised'));

    // Wait for the surprised expression timer to end
    await tester.pump(const Duration(milliseconds: 1300));
    final kamoPainterAfter = (tester.widget<CustomPaint>(chameleonFinder).painter) as ChameleonPainter;
    expect(kamoPainterAfter.expression, equals('neutral'));

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('shape sorter game correct drop updates score and advances level', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-shape_sorter')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    final dynamic state = tester.state(find.byType(ShapeSorterGame));
    final List<dynamic> leftItems = state.leftItems;
    final List<dynamic> rightItems = state.rightItems;

    expect(state.matchesThisLevel, equals(0));

    // Match all 4 shapes to trigger level completion
    for (int i = 0; i < 4; i++) {
      final unplacedLeft = leftItems.firstWhere((item) => !item.isPlaced);
      final matchingRight = rightItems.firstWhere((item) => item.type == unplacedLeft.type);

      final sourceFinder = find.byKey(unplacedLeft.key as Key);
      final targetFinder = find.byKey(matchingRight.key as Key);

      final gesture = await tester.startGesture(tester.getCenter(sourceFinder));
      await gesture.moveTo(tester.getCenter(targetFinder));
      await gesture.up();

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(state.isCelebrationActive, isTrue);
    expect(state.kamoExpression, equals('happy'));

    await tester.pump(const Duration(seconds: 4));
    expect(state.isCelebrationActive, isFalse);
    expect(state.levelNumber, equals(2));
    expect(state.matchesThisLevel, equals(0));

    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
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
