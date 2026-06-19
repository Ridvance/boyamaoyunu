import 'dart:math';
import 'package:web/web.dart' as web;

web.AudioContext? _audioContext;

web.AudioContext get audioContext {
  _audioContext ??= web.AudioContext();
  return _audioContext!;
}

void playXylophoneNote(int noteIndex) {
  try {
    final ctx = audioContext;
    if (ctx.state == 'suspended') {
      ctx.resume();
    }
    
    final frequencies = [
      261.63, // C4 (Red)
      293.66, // D4 (Orange)
      329.63, // E4 (Yellow)
      349.23, // F4 (Green)
      392.00, // G4 (Teal)
      440.00, // A4 (Blue)
      493.88, // B4 (Purple)
      523.25, // C5 (Pink)
    ];
    if (noteIndex < 0 || noteIndex >= frequencies.length) return;
    final freq = frequencies[noteIndex];

    final osc = ctx.createOscillator();
    final gain = ctx.createGain();

    osc.type = 'triangle';
    osc.frequency.value = freq;

    final now = ctx.currentTime;
    
    // Smooth attack and ringing decay
    gain.gain.setValueAtTime(0, now);
    gain.gain.linearRampToValueAtTime(0.6, now + 0.01);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.6);

    osc.connect(gain);
    gain.connect(ctx.destination);

    osc.start(now);
    osc.stop(now + 0.6);
  } catch (e) {
    // Fail silently in case of unsupported platforms/states
  }
}

void playAnimalSound(String animalEmoji) {
  try {
    final ctx = audioContext;
    if (ctx.state == 'suspended') {
      ctx.resume();
    }
    final now = ctx.currentTime;

    if (animalEmoji == '🐱') {
      // Cat "Meow": Frequency sweep up and then down slightly
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();
      
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(320, now);
      osc.frequency.exponentialRampToValueAtTime(680, now + 0.22);
      osc.frequency.exponentialRampToValueAtTime(500, now + 0.45);
      
      gain.gain.setValueAtTime(0, now);
      gain.gain.linearRampToValueAtTime(0.35, now + 0.06);
      gain.gain.linearRampToValueAtTime(0.35, now + 0.35);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.45);
      
      osc.connect(gain);
      gain.connect(ctx.destination);
      
      osc.start(now);
      osc.stop(now + 0.45);
    } 
    else if (animalEmoji == '🐶') {
      // Dog "Woof-Woof": Two quick bark sweeps
      void bark(double startTime) {
        final osc = ctx.createOscillator();
        final gain = ctx.createGain();
        
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(200, startTime);
        osc.frequency.exponentialRampToValueAtTime(80, startTime + 0.12);
        
        gain.gain.setValueAtTime(0, startTime);
        gain.gain.linearRampToValueAtTime(0.5, startTime + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.12);
        
        osc.connect(gain);
        gain.connect(ctx.destination);
        
        osc.start(startTime);
        osc.stop(startTime + 0.12);
      }
      bark(now);
      bark(now + 0.16);
    } 
    else if (animalEmoji == '🦆') {
      // Duck "Quack": Quick nasal sound
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();
      
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(420, now);
      osc.frequency.exponentialRampToValueAtTime(240, now + 0.18);
      
      gain.gain.setValueAtTime(0, now);
      gain.gain.linearRampToValueAtTime(0.25, now + 0.02);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.18);
      
      osc.connect(gain);
      gain.connect(ctx.destination);
      
      osc.start(now);
      osc.stop(now + 0.18);
    } 
    else if (animalEmoji == '🐸') {
      // Frog "Ribbit": Rapid pulse sequence
      for (int i = 0; i < 4; i++) {
        final startTime = now + (i * 0.035);
        final osc = ctx.createOscillator();
        final gain = ctx.createGain();
        
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(130 + (i * 8), startTime);
        
        gain.gain.setValueAtTime(0, startTime);
        gain.gain.linearRampToValueAtTime(0.35, startTime + 0.005);
        gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.028);
        
        osc.connect(gain);
        gain.connect(ctx.destination);
        
        osc.start(startTime);
        osc.stop(startTime + 0.028);
      }
    } 
    else if (animalEmoji == '🐮') {
      // Cow "Moo": Long low slide with rich timbre
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();
      
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(110, now);
      osc.frequency.linearRampToValueAtTime(80, now + 0.8);
      
      gain.gain.setValueAtTime(0, now);
      gain.gain.linearRampToValueAtTime(0.3, now + 0.15);
      gain.gain.linearRampToValueAtTime(0.3, now + 0.6);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.85);
      
      osc.connect(gain);
      gain.connect(ctx.destination);
      
      osc.start(now);
      osc.stop(now + 0.85);
    }
    else if (animalEmoji == '🐑') {
      // Sheep "Baa": Trembling medium pitch tone
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();
      
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(240, now);
      osc.frequency.linearRampToValueAtTime(180, now + 0.65);
      
      // Simulating LFO vibrato with rapid scheduled frequency updates
      for (double t = 0; t <= 0.65; t += 0.05) {
        final lfoVal = 15.0 * sin(2 * pi * 14 * t);
        final freqAtT = (240.0 - (240.0 - 180.0) * (t / 0.65)) + lfoVal;
        osc.frequency.setValueAtTime(freqAtT, now + t);
      }
      
      gain.gain.setValueAtTime(0, now);
      gain.gain.linearRampToValueAtTime(0.3, now + 0.05);
      gain.gain.linearRampToValueAtTime(0.25, now + 0.45);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.65);
      
      osc.connect(gain);
      gain.connect(ctx.destination);
      
      osc.start(now);
      osc.stop(now + 0.65);
    }
    else if (animalEmoji == '🐥') {
      // Chick "Cheep": Two quick high-pitched sweeps
      void cheep(double startTime) {
        final osc = ctx.createOscillator();
        final gain = ctx.createGain();
        
        osc.type = 'sine';
        osc.frequency.setValueAtTime(1500, startTime);
        osc.frequency.exponentialRampToValueAtTime(3200, startTime + 0.08);
        
        gain.gain.setValueAtTime(0, startTime);
        gain.gain.linearRampToValueAtTime(0.2, startTime + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.08);
        
        osc.connect(gain);
        gain.connect(ctx.destination);
        
        osc.start(startTime);
        osc.stop(startTime + 0.08);
      }
      cheep(now);
      cheep(now + 0.15);
    }
  } catch (e) {
    // Fail silently in case of unsupported platforms/states
  }
}

void playSparkleSound() {
  try {
    final ctx = audioContext;
    if (ctx.state == 'suspended') {
      ctx.resume();
    }
    final now = ctx.currentTime;

    // Magical 3-note arpeggio (Sparkle)
    void playChime(double startTime, double freq) {
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();

      osc.type = 'sine';
      osc.frequency.value = freq;

      gain.gain.setValueAtTime(0, startTime);
      gain.gain.linearRampToValueAtTime(0.25, startTime + 0.01);
      gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.15);

      osc.connect(gain);
      gain.connect(ctx.destination);

      osc.start(startTime);
      osc.stop(startTime + 0.15);
    }

    playChime(now, 880);
    playChime(now + 0.05, 1109.73); // C#6
    playChime(now + 0.10, 1318.51); // E6
  } catch (e) {
    // Fail silently
  }
}

void playRaindropSound() {
  try {
    final ctx = audioContext;
    if (ctx.state == 'suspended') {
      ctx.resume();
    }
    final now = ctx.currentTime;

    final osc = ctx.createOscillator();
    final gain = ctx.createGain();

    osc.type = 'sine';
    // Quick sweep upwards for a cute pop/water drop sound
    osc.frequency.setValueAtTime(500, now);
    osc.frequency.exponentialRampToValueAtTime(950, now + 0.08);

    gain.gain.setValueAtTime(0, now);
    gain.gain.linearRampToValueAtTime(0.3, now + 0.005);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.08);

    osc.connect(gain);
    gain.connect(ctx.destination);

    osc.start(now);
    osc.stop(now + 0.08);
  } catch (e) {
    // Fail silently
  }
}

Future<void> preloadAllSounds() async {
  // Web Audio API dynamically synthesizes sounds on-demand with zero latency.
  // No files or assets to preload.
}
