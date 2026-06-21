import 'package:shared_preferences/shared_preferences.dart';

abstract final class ProgressChapters {
  static const coloring = 'coloring';
  static const tracing = 'tracing';
  static const balloon = 'balloon';
  static const shapes = 'shapes';
  static const sounds = 'sounds';
  static const magicColors = 'magic_colors';
  static const habits = 'habits';
  static const learningPacks = 'learning_packs';

  static const all = <String>[
    coloring, tracing, balloon, shapes, sounds, magicColors, habits,
    learningPacks,
  ];
}

class ProgressService {
  ProgressService._privateConstructor();
  static final ProgressService instance = ProgressService._privateConstructor();

  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Fail silently
    }
  }

  List<int> getCompletedLevels(String chapterId) {
    if (_prefs == null) return [];
    try {
      final key = 'journey_completed_$chapterId';
      final stringList = _prefs!.getStringList(key);
      if (stringList == null) return [];
      return stringList.map((e) => int.tryParse(e) ?? 0).toList();
    } catch (_) {
      return [];
    }
  }

  bool isLevelCompleted(String chapterId, int levelIndex) {
    return getCompletedLevels(chapterId).contains(levelIndex);
  }

  int getCompletedCount(String chapterId) {
    return getCompletedLevels(chapterId).length;
  }

  int getStars(String chapterId, int levelIndex) {
    if (_prefs == null) return 0;
    return _prefs!.getInt(_starsKey(chapterId, levelIndex)) ?? 0;
  }

  int getTotalStars(String chapterId) {
    return getCompletedLevels(chapterId).fold(
      0, (total, level) => total + getStars(chapterId, level),
    );
  }

  int get totalCompletedCount => ProgressChapters.all.fold(
    0, (total, chapter) => total + getCompletedCount(chapter),
  );

  int get totalStars => ProgressChapters.all.fold(
    0, (total, chapter) => total + getTotalStars(chapter),
  );

  Future<void> completeLevel(
    String chapterId,
    int levelIndex, {
    int stars = 1,
  }) async {
    if (_prefs == null) {
      await init();
      if (_prefs == null) return;
    }
    try {
      final completed = getCompletedLevels(chapterId);
      if (!completed.contains(levelIndex)) {
        completed.add(levelIndex);
        completed.sort();
        final key = 'journey_completed_$chapterId';
        await _prefs!.setStringList(
          key,
          completed.map((e) => e.toString()).toList(),
        );
      }
      final normalizedStars = stars.clamp(1, 3);
      final starsKey = _starsKey(chapterId, levelIndex);
      final currentStars = _prefs!.getInt(starsKey) ?? 0;
      if (normalizedStars > currentStars) {
        await _prefs!.setInt(starsKey, normalizedStars);
      }
    } catch (_) {
      // Swallowed
    }
  }

  String _starsKey(String chapterId, int levelIndex) {
    return 'journey_stars_${chapterId}_$levelIndex';
  }

  Future<void> resetAllProgress() async {
    if (_prefs == null) return;
    try {
      final keys = _prefs!.getKeys();
      for (final key in keys) {
        if (key.startsWith('journey_completed_') ||
            key.startsWith('journey_stars_')) {
          await _prefs!.remove(key);
        }
      }
    } catch (_) {
      // Swallowed
    }
  }
}
