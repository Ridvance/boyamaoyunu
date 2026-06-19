import 'package:flutter_test/flutter_test.dart';
import 'package:cocuk_oyun/services/audio_synth.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioSynth Cache & Preload Tests', () {
    test('preloadAllSounds completes successfully and plays sounds without error', () async {
      // Preload all sounds
      await expectLater(AudioSynth.preloadAllSounds(), completes);

      // Verify that playing synthesized sounds returns normally
      expect(() => AudioSynth.playSparkleSound(), returnsNormally);
      expect(() => AudioSynth.playRaindropSound(), returnsNormally);
      expect(() => AudioSynth.playXylophoneNote(0), returnsNormally);
      expect(() => AudioSynth.playXylophoneNote(7), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🐱'), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🐶'), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🦆'), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🐸'), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🐮'), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🐑'), returnsNormally);
      expect(() => AudioSynth.playAnimalSound('🐥'), returnsNormally);
    });
  });
}
