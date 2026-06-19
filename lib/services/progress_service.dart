import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> completeLevel(String chapterId, int levelIndex) async {
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
    } catch (_) {
      // Swallowed
    }
  }

  Future<void> resetAllProgress() async {
    if (_prefs == null) return;
    try {
      final keys = _prefs!.getKeys();
      for (final key in keys) {
        if (key.startsWith('journey_completed_')) {
          await _prefs!.remove(key);
        }
      }
    } catch (_) {
      // Swallowed
    }
  }
}
