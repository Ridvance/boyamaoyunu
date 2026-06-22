import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocuk_oyun/services/progress_service.dart';
import 'package:cocuk_oyun/games/balloon_pop_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProgressService Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await ProgressService.instance.init();
    });

    test('isLevelCompleted returns false by default', () {
      expect(ProgressService.instance.isLevelCompleted('colors', 0), isFalse);
      expect(ProgressService.instance.getCompletedCount('colors'), 0);
    });

    test('completeLevel updates state and persists', () async {
      await ProgressService.instance.completeLevel(
        ProgressChapters.coloring,
        0,
        stars: 2,
      );
      expect(
        ProgressService.instance.isLevelCompleted(ProgressChapters.coloring, 0),
        isTrue,
      );
      expect(ProgressService.instance.getStars(ProgressChapters.coloring, 0), 2);

      await ProgressService.instance.completeLevel(
        ProgressChapters.coloring,
        0,
        stars: 3,
      );
      await ProgressService.instance.init();
      expect(
        ProgressService.instance.getCompletedLevels(ProgressChapters.coloring),
        [0],
      );
      expect(ProgressService.instance.getTotalStars(ProgressChapters.coloring), 3);
    });

    test('resetAllProgress clears saved levels', () async {
      await ProgressService.instance.completeLevel('colors', 0);
      await ProgressService.instance.completeLevel('shapes', 0);
      expect(ProgressService.instance.isLevelCompleted('colors', 0), isTrue);
      expect(ProgressService.instance.isLevelCompleted('shapes', 0), isTrue);

      await ProgressService.instance.resetAllProgress();
      expect(ProgressService.instance.isLevelCompleted('colors', 0), isFalse);
      expect(ProgressService.instance.isLevelCompleted('shapes', 0), isFalse);
      expect(ProgressService.instance.getStars('colors', 0), 0);
    });

    test('chapter identifiers are unique', () {
      expect(ProgressChapters.all.toSet().length, ProgressChapters.all.length);
    });

    test(
      'balloon completion records balloon progress without changing tracing',
      () async {
        await ProgressService.instance.completeLevel('tracing', 0);

        await recordBalloonLevelCompletion();

        expect(ProgressService.instance.getCompletedLevels('balloon'), [1]);
        expect(ProgressService.instance.getCompletedLevels('tracing'), [0]);
      },
    );

    test('balloon levels cycle through distinct challenge types', () {
      expect(balloonChallenges.length, 3);
      expect(
        balloonChallenges.map((challenge) => challenge.type).toSet(),
        {
          BalloonChallengeType.relaxed,
          BalloonChallengeType.targetColor,
          BalloonChallengeType.timedSpecial,
        },
      );
      expect(balloonChallenges[1].targetColor, isNotNull);
      expect(balloonChallenges[2].seconds, greaterThan(0));
    });
  });
}
