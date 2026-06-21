import 'package:cocuk_oyun/services/app_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSettingsService.instance.init();
  });

  test(
    'sound and haptics preferences persist after reinitialization',
    () async {
      await AppSettingsService.instance.setSoundEnabled(false);
      await AppSettingsService.instance.setHapticsEnabled(false);

      await AppSettingsService.instance.init();

      expect(AppSettingsService.instance.soundEnabled, isFalse);
      expect(AppSettingsService.instance.hapticsEnabled, isFalse);
    },
  );
}
