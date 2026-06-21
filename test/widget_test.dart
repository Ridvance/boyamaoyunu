import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cocuk_oyun/main.dart';
import 'package:cocuk_oyun/games/magic_colors/chameleon_painter.dart';
import 'package:cocuk_oyun/services/guidance_widgets.dart';
import 'package:cocuk_oyun/games/shape_sorter_game.dart';
import 'package:cocuk_oyun/games/sound_board_game.dart';
import 'package:cocuk_oyun/games/habits_game.dart';
import 'package:cocuk_oyun/games/learning_packs_game.dart';
import 'package:cocuk_oyun/services/app_settings_service.dart';
import 'package:cocuk_oyun/services/progress_service.dart';

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

  testWidgets('dashboard shows persisted progress for each game', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'journey_completed_coloring': ['0'],
      'journey_stars_coloring_0': 3,
    });
    await ProgressService.instance.init();
    await AppSettingsService.instance.init();
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    expect(find.byKey(const ValueKey('game-progress-coloring')), findsOneWidget);
    expect(find.text('1 tamamlandı  •  3 ⭐'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('game-progress-learning_packs')),
      findsOneWidget,
    );
  });

  testWidgets('parent controls persist preferences and confirm progress reset', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'journey_completed_coloring': ['0'],
      'journey_stars_coloring_0': 3,
    });
    await ProgressService.instance.init();
    await AppSettingsService.instance.init();
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());
    await tester.tap(find.byKey(const ValueKey('parent-gate-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('parent-gate-option-correct')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('parent-progress-summary')), findsOneWidget);
    expect(find.text('1 bölüm  •  3 yıldız'), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byKey(const ValueKey('sound-toggle')),
      matching: find.byType(Switch),
    ));
    await tester.tap(find.descendant(
      of: find.byKey(const ValueKey('haptics-toggle')),
      matching: find.byType(Switch),
    ));
    await tester.pumpAndSettle();
    expect(AppSettingsService.instance.soundEnabled, isFalse);
    expect(AppSettingsService.instance.hapticsEnabled, isFalse);

    await tester.tap(find.byKey(const ValueKey('reset-progress-button')));
    await tester.pumpAndSettle();
    expect(find.text('İlerleme sıfırlansın mı?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm-reset-progress')));
    await tester.pumpAndSettle();

    expect(ProgressService.instance.totalCompletedCount, 0);
    expect(find.text('0 bölüm  •  0 yıldız'), findsOneWidget);
  });

  testWidgets('fullscreen button does not show PWA hint on native platforms', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    expect(find.byKey(const ValueKey('fullscreen-hint')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('fullscreen-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('fullscreen-hint')), findsNothing);
  });

  testWidgets('opens parent safety screen through the math parent gate', (
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

    // Verify wrong answer logic
    // Tap a wrong answer button (wrong-0)
    await tester.tap(find.byKey(const ValueKey('parent-gate-option-wrong-0')));
    await tester.pumpAndSettle();

    // Verify we are still on the dialog (ParentSafetyScreen not opened)
    expect(find.text('Ebeveyn Kontrol Paneli'), findsNothing);
    expect(find.text('Tekrar deneyin.'), findsOneWidget);

    // Tap the correct answer button
    await tester.tap(find.byKey(const ValueKey('parent-gate-option-correct')));
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

  testWidgets('habits game completes eight tasks across four categories', (
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

    const taskIds = [
      'toys', 'teeth', 'trash', 'hands', 'bed', 'table', 'flowers', 'laundry',
    ];
    const categories = {
      'toys': 'Düzen',
      'teeth': 'Öz Bakım',
      'trash': 'Temizlik',
      'hands': 'Öz Bakım',
      'bed': 'Düzen',
      'table': 'Yardım',
      'flowers': 'Yardım',
      'laundry': 'Temizlik',
    };
    for (final taskId in taskIds) {
      expect(
        find.byKey(ValueKey('habit-progress-$taskId')),
        findsOneWidget,
      );
      final categoryText = tester.widget<Text>(
        find.byKey(ValueKey('habit-category-$taskId')),
      );
      expect(categoryText.data, categories[taskId]);
      await tester.tap(find.byKey(ValueKey('habit-action-$taskId')));
      await tester.pump();
    }

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

  testWidgets('learning packs exposes three packs and completes an inline activity', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await ProgressService.instance.init();
    await AppSettingsService.instance.init();
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

    expect(find.byKey(const ValueKey('learning-pack-first-skills')), findsOneWidget);
    expect(find.byKey(const ValueKey('learning-pack-colors-shapes')), findsOneWidget);
    expect(find.byKey(const ValueKey('learning-pack-daily-heroes')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('learning-pack-colors-shapes')));
    await tester.pump();
    expect(find.byKey(const ValueKey('learning-activity-color-mix-practice')), findsOneWidget);
    expect(find.byKey(const ValueKey('learning-activity-color-sequence')), findsOneWidget);
    expect(find.byKey(const ValueKey('learning-activity-shape-path')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('learning-activity-color-sequence')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    for (var index = 0; index < 3; index++) {
      await tester.tap(
        find.byKey(ValueKey('pack-mini-step-color-sequence-$index')),
      );
      await tester.pump();
    }
    await tester.tap(
      find.byKey(const ValueKey('pack-mini-complete-color-sequence')),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('1 / 3'), findsOneWidget);
    expect(
      ProgressService.instance.isLevelCompleted(
        ProgressChapters.learningPacks,
        5,
      ),
      isTrue,
    );
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

  testWidgets('sound board game inactivity triggers GhostHandHint and PulseTarget, and interaction hides it', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-sound_board')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify GhostHandHint is not visible initially
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity timer to fire (fires at 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Trigger an activity by tapping on the first cloud
    await tester.tap(find.byType(CloudWidget).first);
    await tester.pump();

    // The hint should be gone
    expect(find.byType(GhostHandHint), findsNothing);

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('sound board game key and animal tap triggers Kamo happy expression', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-sound_board')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    final dynamic state = tester.state(find.byType(SoundBoardGame));
    expect(state.kamoExpression, equals('neutral'));

    // Tap on the first animal card
    final animalFinder = find.byType(AnimalCardWidget);
    expect(animalFinder, findsWidgets);
    await tester.tap(animalFinder.first);
    await tester.pump();

    // Kamo should be happy
    expect(state.kamoExpression, equals('happy'));

    // Wait 700ms for Kamo happy duration (600ms) to end and return to neutral
    await tester.pump(const Duration(milliseconds: 700));
    expect(state.kamoExpression, equals('neutral'));

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('habits game inactivity triggers GhostHandHint on active button', (
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

    // Verify GhostHandHint is not visible initially
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity timer to fire (fires at 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Trigger activity by tapping on reset button
    await tester.tap(find.byKey(const ValueKey('habits-reset-button')));
    await tester.pump();

    // The hint should be gone
    expect(find.byType(GhostHandHint), findsNothing);

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('habits game task completion triggers Kamo happy expression', (
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

    final dynamic state = tester.state(find.byType(HabitsGame));
    expect(state.kamoExpression, equals('neutral'));

    // Tap on the active action button
    await tester.tap(find.byKey(const ValueKey('habit-action-toys')));
    await tester.pump();

    // Kamo should be happy
    expect(state.kamoExpression, equals('happy'));

    // Wait 1.3 seconds for Kamo happy duration (1.2s) to end and return to neutral
    await tester.pump(const Duration(milliseconds: 1300));
    expect(state.kamoExpression, equals('neutral'));

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('habits game tapping completed task triggers Kamo surprised expression and soft wrong feedback', (
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

    final dynamic state = tester.state(find.byType(HabitsGame));
    expect(state.kamoExpression, equals('neutral'));

    // Complete the first task
    await tester.tap(find.byKey(const ValueKey('habit-action-toys')));
    await tester.pump();

    // Wait for happy reaction to finish (1.3 seconds)
    await tester.pump(const Duration(milliseconds: 1300));
    expect(state.kamoExpression, equals('neutral'));

    // Tap the completed progress tile (toys)
    await tester.tap(find.byKey(const ValueKey('habit-progress-toys')));
    await tester.pump();

    // Kamo should be surprised
    expect(state.kamoExpression, equals('surprised'));

    // Wait 1.3 seconds for Kamo surprised duration (1.2s) to end and return to neutral
    await tester.pump(const Duration(milliseconds: 1300));
    expect(state.kamoExpression, equals('neutral'));

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('habits game all tasks complete triggers temporary celebration effect and permanent Kamo happy', (
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

    final dynamic state = tester.state(find.byType(HabitsGame));
    expect(state.kamoExpression, equals('neutral'));
    expect(state.isCelebrationActive, isFalse);

    // Complete all 8 tasks
    const taskIds = [
      'toys', 'teeth', 'trash', 'hands', 'bed', 'table', 'flowers', 'laundry',
    ];
    for (final taskId in taskIds) {
      await tester.tap(find.byKey(ValueKey('habit-action-$taskId')));
      await tester.pump();
    }

    // Celebration should be active and Kamo should be happy
    expect(state.isCelebrationActive, isTrue);
    expect(state.kamoExpression, equals('happy'));

    // Wait 3.5 seconds (celebration lasts 3s)
    await tester.pump(const Duration(seconds: 4));
    expect(state.isCelebrationActive, isFalse);
    // Kamo should remain permanently happy
    expect(state.kamoExpression, equals('happy'));

    // Pop the route
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('learning packs inactivity triggers GhostHandHint on first pack and then first activity', (
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

    final dynamic state = tester.state(find.byType(LearningPacksGame));
    expect(state.kamoExpression, equals('neutral'));
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait 4 seconds for inactivity on pack selection screen
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Tap first pack
    await tester.tap(find.byKey(const ValueKey('learning-pack-first-skills')));
    await tester.pump();

    // Verify Kamo gets happy on selection
    expect(state.kamoExpression, equals('happy'));
    expect(find.byType(GhostHandHint), findsNothing);

    // Wait for Kamo happy reaction to end (700ms)
    await tester.pump(const Duration(milliseconds: 800));
    expect(state.kamoExpression, equals('neutral'));

    // We are now in detail screen. Wait 4 seconds for inactivity on activity detail screen
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(GhostHandHint), findsOneWidget);

    // Tap the first activity card
    await tester.tap(find.byKey(const ValueKey('learning-activity-story-coloring')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Pop coloring game
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Pop the detail view to pack selection screen
    await tester.tap(find.byKey(const ValueKey('learning-packs-back-button')));
    await tester.pump();

    // Pop learning packs screen
    await tester.tap(find.byKey(const ValueKey('learning-packs-back-button')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('magic colors works in compact landscape layout height < 400 without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(640, 320);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CocukOyunApp());

    await tester.tap(find.byKey(const ValueKey('game-card-magic_colors')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('🧪 Sihirli Renk Laboratuvarı'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('magic-colors-mode-sandbox')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('magic-colors-tube-Kırmızı')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('magic-colors-tube-Sarı')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('magic-colors-mix-button')));
    await tester.pump();

    expect(find.text('Turuncu'), findsWidgets);
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
