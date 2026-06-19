import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

final List<AudioPlayer> _playerPool = [];
int _currentPlayerIndex = 0;
final Map<String, File> _cachedFiles = {};

AudioPlayer _getPlayer() {
  if (_playerPool.length < 8) {
    final p = AudioPlayer();
    _playerPool.add(p);
    return p;
  }
  final p = _playerPool[_currentPlayerIndex];
  _currentPlayerIndex = (_currentPlayerIndex + 1) % _playerPool.length;
  return p;
}

Future<File> _getOrCreateWavFile(String filename, double durationSeconds, Function(Uint16List data, int sampleRate) generator) async {
  if (_cachedFiles.containsKey(filename)) {
    final file = _cachedFiles[filename]!;
    if (await file.exists()) {
      return file;
    }
  }
  
  try {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename.wav');
    
    const sampleRate = 22050;
    final numSamples = (sampleRate * durationSeconds).toInt();
    const numChannels = 1;
    const bitsPerSample = 16;
    const bytesPerSample = bitsPerSample ~/ 8;
    final subchunk2Size = numSamples * numChannels * bytesPerSample;
    final chunkSize = 36 + subchunk2Size;
    
    final header = Uint8List(44);
    final bd = ByteData.sublistView(header);
    
    // RIFF header
    bd.setUint8(0, 0x52); // 'R'
    bd.setUint8(1, 0x49); // 'I'
    bd.setUint8(2, 0x46); // 'F'
    bd.setUint8(3, 0x46); // 'F'
    bd.setUint32(4, chunkSize, Endian.little);
    bd.setUint8(8, 0x57); // 'W'
    bd.setUint8(9, 0x41); // 'A'
    bd.setUint8(10, 0x56); // 'V'
    bd.setUint8(11, 0x45); // 'E'
    
    // fmt subchunk
    bd.setUint8(12, 0x66); // 'f'
    bd.setUint8(13, 0x6d); // 'm'
    bd.setUint8(14, 0x74); // 't'
    bd.setUint8(15, 0x20); // ' '
    bd.setUint32(16, 16, Endian.little);
    bd.setUint16(20, 1, Endian.little); // PCM
    bd.setUint16(22, numChannels, Endian.little);
    bd.setUint32(24, sampleRate, Endian.little);
    bd.setUint32(28, sampleRate * numChannels * bytesPerSample, Endian.little);
    bd.setUint16(32, numChannels * bytesPerSample, Endian.little);
    bd.setUint16(34, bitsPerSample, Endian.little);
    
    // data subchunk
    bd.setUint8(36, 0x64); // 'd'
    bd.setUint8(37, 0x61); // 'a'
    bd.setUint8(38, 0x74); // 't'
    bd.setUint8(39, 0x61); // 'a'
    bd.setUint32(40, subchunk2Size, Endian.little);
    
    final data = Uint16List(numSamples);
    generator(data, sampleRate);
    
    final fileBytes = BytesBuilder();
    fileBytes.add(header);
    fileBytes.add(Uint8List.view(data.buffer));
    
    await file.writeAsBytes(fileBytes.takeBytes());
    _cachedFiles[filename] = file;
    return file;
  } catch (e) {
    rethrow;
  }
}

void _playFile(File file) {
  try {
    final player = _getPlayer();
    player.play(DeviceFileSource(file.path));
  } catch (e) {
    // Fail silently in case of file errors
  }
}

// ----------------------------------------------------
// Reusable Generator Implementations
// ----------------------------------------------------

void _generateXylophoneNoteData(Uint16List data, int sampleRate, double freq) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final decay = math.exp(-t * 6.0);

    // Triangle wave
    final period = 1.0 / freq;
    final phase = (t % period) / period;
    double sampleValue = 0.0;
    if (phase < 0.25) {
      sampleValue = phase * 4.0;
    } else if (phase < 0.75) {
      sampleValue = 2.0 - phase * 4.0;
    } else {
      sampleValue = phase * 4.0 - 4.0;
    }

    data[i] = (sampleValue * 0.45 * decay * 32767).toInt();
  }
}

void _generateCatSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final decay = math.exp(-t * 2.0) * (t < 0.05 ? t / 0.05 : 1.0);
    double freq = 320.0;
    if (t < 0.22) {
      final frac = t / 0.22;
      freq = 320.0 + (680.0 - 320.0) * frac;
    } else {
      final frac = (t - 0.22) / 0.23;
      freq = 680.0 + (500.0 - 680.0) * frac;
    }
    final sampleValue = math.sin(2 * math.pi * freq * t);
    data[i] = (sampleValue * 0.3 * decay * 32767).toInt();
  }
}

void _generateDogSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    double sampleValue = 0.0;
    double decay = 0.0;
    if (t < 0.12) {
      decay = math.exp(-t * 15.0);
      final freq = 200.0 - (200.0 - 80.0) * (t / 0.12);
      sampleValue = math.sin(2 * math.pi * freq * t);
    } else if (t >= 0.16 && t < 0.28) {
      final t2 = t - 0.16;
      decay = math.exp(-t2 * 15.0);
      final freq = 200.0 - (200.0 - 80.0) * (t2 / 0.12);
      sampleValue = math.sin(2 * math.pi * freq * t2);
    }
    data[i] = (sampleValue * 0.4 * decay * 32767).toInt();
  }
}

void _generateDuckSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final decay = math.exp(-t * 8.0);
    final freq = 420.0 - (420.0 - 240.0) * (t / 0.2);
    final period = 1.0 / freq;
    final phase = (t % period) / period;
    final sampleValue = phase * 2.0 - 1.0;
    data[i] = (sampleValue * 0.2 * decay * 32767).toInt();
  }
}

void _generateFrogSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final pulseIndex = (t / 0.035).floor();
    double sampleValue = 0.0;
    if (pulseIndex < 4) {
      final tPulse = t % 0.035;
      if (tPulse < 0.028) {
        final decay = math.exp(-tPulse * 30.0);
        final freq = 130.0 + (pulseIndex * 8.0);
        final period = 1.0 / freq;
        final phase = (tPulse % period) / period;
        sampleValue = (phase * 2.0 - 1.0) * decay;
      }
    }
    data[i] = (sampleValue * 0.25 * 32767).toInt();
  }
}

void _generateCowSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final decay = math.exp(-t * 2.0) * (t < 0.15 ? t / 0.15 : 1.0);
    final freq = 110.0 - (110.0 - 80.0) * (t / 0.8);
    final period = 1.0 / freq;
    final phase = (t % period) / period;
    final sampleValue = phase * 2.0 - 1.0;
    data[i] = (sampleValue * 0.22 * decay * 32767).toInt();
  }
}

void _generateSheepSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final decay = math.exp(-t * 3.0) * (t < 0.05 ? t / 0.05 : 1.0);

    final lfo = math.sin(2 * math.pi * 14 * t);
    final freq = (240.0 - (240.0 - 180.0) * (t / 0.65)) + lfo * 15.0;

    final period = 1.0 / freq;
    final phase = (t % period) / period;
    double sampleValue = 0.0;
    if (phase < 0.25) {
      sampleValue = phase * 4.0;
    } else if (phase < 0.75) {
      sampleValue = 2.0 - phase * 4.0;
    } else {
      sampleValue = phase * 4.0 - 4.0;
    }

    data[i] = (sampleValue * 0.25 * decay * 32767).toInt();
  }
}

void _generateChickSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    double sampleValue = 0.0;
    double decay = 0.0;

    if (t < 0.08) {
      decay = math.exp(-t * 20.0);
      final freq = 1500.0 + (3200.0 - 1500.0) * (t / 0.08);
      sampleValue = math.sin(2 * math.pi * freq * t);
    } else if (t >= 0.15 && t < 0.23) {
      final t2 = t - 0.15;
      decay = math.exp(-t2 * 20.0);
      final freq = 1500.0 + (3200.0 - 1500.0) * (t2 / 0.08);
      sampleValue = math.sin(2 * math.pi * freq * t2);
    }

    data[i] = (sampleValue * 0.2 * decay * 32767).toInt();
  }
}

void _generateSparkleSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    double sampleValue = 0.0;

    // Chime 1
    if (t < 0.15) {
      final decay = math.exp(-t * 20.0);
      sampleValue += math.sin(2 * math.pi * 880 * t) * decay * 0.2;
    }
    // Chime 2
    if (t >= 0.05 && t < 0.20) {
      final t2 = t - 0.05;
      final decay = math.exp(-t2 * 20.0);
      sampleValue += math.sin(2 * math.pi * 1109.73 * t2) * decay * 0.2;
    }
    // Chime 3
    if (t >= 0.10 && t < 0.25) {
      final t3 = t - 0.10;
      final decay = math.exp(-t3 * 20.0);
      sampleValue += math.sin(2 * math.pi * 1318.51 * t3) * decay * 0.2;
    }

    data[i] = (sampleValue * 32767).toInt();
  }
}

void _generateRaindropSoundData(Uint16List data, int sampleRate) {
  for (int i = 0; i < data.length; i++) {
    final t = i / sampleRate;
    final decay = math.exp(-t * 40.0);
    final freq = 500.0 + (950.0 - 500.0) * (t / 0.08);
    final sampleValue = math.sin(2 * math.pi * freq * t);
    data[i] = (sampleValue * 0.25 * decay * 32767).toInt();
  }
}

// ----------------------------------------------------
// Preloading Helpers
// ----------------------------------------------------

Future<File> _preloadXylophoneNote(int noteIndex) {
  final frequencies = [
    261.63, // C4
    293.66, // D4
    329.63, // E4
    349.23, // F4
    392.00, // G4
    440.00, // A4
    493.88, // B4
    523.25, // C5
  ];
  if (noteIndex < 0 || noteIndex >= frequencies.length) {
    return Future.error(ArgumentError('Invalid note index'));
  }
  final freq = frequencies[noteIndex];
  return _getOrCreateWavFile('xylo_$noteIndex', 0.6, (data, sampleRate) {
    _generateXylophoneNoteData(data, sampleRate, freq);
  });
}

Future<File> _preloadAnimalSound(String animalEmoji) {
  String filename;
  double duration;
  void Function(Uint16List, int) generator;

  if (animalEmoji == '🐱') {
    filename = 'cat_meow';
    duration = 0.45;
    generator = _generateCatSoundData;
  } else if (animalEmoji == '🐶') {
    filename = 'dog_bark';
    duration = 0.35;
    generator = _generateDogSoundData;
  } else if (animalEmoji == '🦆') {
    filename = 'duck_quack';
    duration = 0.2;
    generator = _generateDuckSoundData;
  } else if (animalEmoji == '🐸') {
    filename = 'frog_ribbit';
    duration = 0.2;
    generator = _generateFrogSoundData;
  } else if (animalEmoji == '🐮') {
    filename = 'cow_moo';
    duration = 0.85;
    generator = _generateCowSoundData;
  } else if (animalEmoji == '🐑') {
    filename = 'sheep_baa';
    duration = 0.65;
    generator = _generateSheepSoundData;
  } else if (animalEmoji == '🐥') {
    filename = 'chick_cheep';
    duration = 0.23;
    generator = _generateChickSoundData;
  } else {
    return Future.error(ArgumentError('Unknown animal emoji'));
  }

  return _getOrCreateWavFile(filename, duration, generator);
}

Future<File> _preloadSparkleSound() {
  return _getOrCreateWavFile('sparkle', 0.25, _generateSparkleSoundData);
}

Future<File> _preloadRaindropSound() {
  return _getOrCreateWavFile('raindrop', 0.08, _generateRaindropSoundData);
}

// ----------------------------------------------------
// Public APIs
// ----------------------------------------------------

Future<void> preloadAllSounds() async {
  try {
    // 8 ksilofon notası (sırayla, disk ve CPU yükünü azaltmak için)
    for (int i = 0; i < 8; i++) {
      await _preloadXylophoneNote(i);
    }
    // 7 hayvan sesi
    final animals = ['🐱', '🐶', '🦆', '🐸', '🐮', '🐑', '🐥'];
    for (final emoji in animals) {
      await _preloadAnimalSound(emoji);
    }
    // sistem sesleri
    await _preloadSparkleSound();
    await _preloadRaindropSound();
  } catch (e) {
    // Preload hataları sessizce geçiştirilir (çökmeyi önlemek için)
  }
}

void playXylophoneNote(int noteIndex) {
  _preloadXylophoneNote(noteIndex).then(_playFile).catchError((_) {});
}

void playAnimalSound(String animalEmoji) {
  _preloadAnimalSound(animalEmoji).then(_playFile).catchError((_) {});
}

void playSparkleSound() {
  _preloadSparkleSound().then(_playFile).catchError((_) {});
}

void playRaindropSound() {
  _preloadRaindropSound().then(_playFile).catchError((_) {});
}
