import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocuk_oyun/screens/kamo_journey_screen.dart';
import 'package:cocuk_oyun/services/progress_service.dart';
import 'package:cocuk_oyun/games/coloring_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KamoJourneyScreen Widget Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await ProgressService.instance.init();
    });

    testWidgets('renders KamoJourneyScreen successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: KamoJourneyScreen(),
        ),
      );

      expect(find.text("Kamo'nun Yolculuğu"), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget); // Back button

      // First few chapters should be immediately visible
      expect(find.text('Renkler'), findsOneWidget);
      expect(find.text('Şekiller'), findsOneWidget);
      expect(find.text('Sesler'), findsOneWidget);

      // Drag horizontal list to show the other chapters
      final listFinder = find.byType(ListView);
      await tester.drag(listFinder, const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Alışkanlıklar'), findsOneWidget);
      expect(find.text('Çizgi Takip'), findsOneWidget);
    });

    testWidgets('tapping chapter card opens level selection dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: KamoJourneyScreen(),
        ),
      );

      // Tap on Colors chapter card
      final colorsCard = find.byKey(const ValueKey('chapter-card-colors'));
      expect(colorsCard, findsOneWidget);
      await tester.tap(colorsCard);
      await tester.pumpAndSettle();

      // Check level selection modal content
      expect(find.text('Boyama Kitabı'), findsOneWidget);
      expect(find.text('Renk Laboratuvarı'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('tapping level button navigates to game', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: KamoJourneyScreen(),
        ),
      );

      // Tap on Colors chapter card
      await tester.tap(find.byKey(const ValueKey('chapter-card-colors')));
      await tester.pumpAndSettle();

      // Tap on Boyama Kitabı level button
      final boyamaBtn = find.text('Boyama Kitabı');
      expect(boyamaBtn, findsOneWidget);
      await tester.tap(boyamaBtn);
      
      // Use pump instead of pumpAndSettle to avoid infinite animation timeouts
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify navigation to ColoringGame
      expect(find.byType(ColoringGame), findsOneWidget);
    });
  });
}
