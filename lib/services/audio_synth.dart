import 'audio_synth_stub.dart'
    if (dart.library.html) 'audio_synth_web.dart' as impl;

class AudioSynth {
  static void playXylophoneNote(int noteIndex) {
    impl.playXylophoneNote(noteIndex);
  }

  static void playAnimalSound(String animalEmoji) {
    impl.playAnimalSound(animalEmoji);
  }

  static void playSparkleSound() {
    impl.playSparkleSound();
  }

  static void playRaindropSound() {
    impl.playRaindropSound();
  }
}
