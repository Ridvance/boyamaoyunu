import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  AppSettingsService._();

  static final instance = AppSettingsService._();

  static const _soundKey = 'parent_sound_enabled';
  static const _hapticsKey = 'parent_haptics_enabled';

  SharedPreferences? _prefs;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _soundEnabled = _prefs!.getBool(_soundKey) ?? true;
    _hapticsEnabled = _prefs!.getBool(_hapticsKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_soundKey, enabled);
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    _hapticsEnabled = enabled;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_hapticsKey, enabled);
  }
}

abstract final class AppHaptics {
  static Future<void> lightImpact() async {
    if (AppSettingsService.instance.hapticsEnabled) {
      await HapticFeedback.lightImpact();
    }
  }

  static Future<void> mediumImpact() async {
    if (AppSettingsService.instance.hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
  }

  static Future<void> heavyImpact() async {
    if (AppSettingsService.instance.hapticsEnabled) {
      await HapticFeedback.heavyImpact();
    }
  }

  static Future<void> selectionClick() async {
    if (AppSettingsService.instance.hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
  }

  static Future<void> vibrate() async {
    if (AppSettingsService.instance.hapticsEnabled) {
      await HapticFeedback.vibrate();
    }
  }
}

abstract final class AppSounds {
  static Future<void> systemClick() async {
    if (AppSettingsService.instance.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }
}
