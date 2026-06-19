import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocuk_oyun/services/progress_service.dart';

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
      await ProgressService.instance.completeLevel('colors', 0);
      expect(ProgressService.instance.isLevelCompleted('colors', 0), isTrue);
      expect(ProgressService.instance.getCompletedCount('colors'), 1);

      // Verify second level complete
      await ProgressService.instance.completeLevel('colors', 1);
      expect(ProgressService.instance.getCompletedLevels('colors'), [0, 1]);
      expect(ProgressService.instance.getCompletedCount('colors'), 2);
    });

    test('resetAllProgress clears saved levels', () async {
      await ProgressService.instance.completeLevel('colors', 0);
      await ProgressService.instance.completeLevel('shapes', 0);
      expect(ProgressService.instance.isLevelCompleted('colors', 0), isTrue);
      expect(ProgressService.instance.isLevelCompleted('shapes', 0), isTrue);

      await ProgressService.instance.resetAllProgress();
      expect(ProgressService.instance.isLevelCompleted('colors', 0), isFalse);
      expect(ProgressService.instance.isLevelCompleted('shapes', 0), isFalse);
    });
  });
}
