import 'audio_synth_stub.dart'
    if (dart.library.html) 'audio_synth_web.dart' as impl;
import 'app_settings_service.dart';

class AudioSynth {
  static Future<void> preloadAllSounds() {
    return impl.preloadAllSounds();
  }

  static void playXylophoneNote(int noteIndex) {
    if (!AppSettingsService.instance.soundEnabled) return;
    impl.playXylophoneNote(noteIndex);
  }

  static void playAnimalSound(String animalEmoji) {
    if (!AppSettingsService.instance.soundEnabled) return;
    impl.playAnimalSound(animalEmoji);
  }

  static void playSparkleSound() {
    if (!AppSettingsService.instance.soundEnabled) return;
    impl.playSparkleSound();
  }

  static void playRaindropSound() {
    if (!AppSettingsService.instance.soundEnabled) return;
    impl.playRaindropSound();
  }
}
