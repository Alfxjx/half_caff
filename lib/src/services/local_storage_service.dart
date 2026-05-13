import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/caffeine_profile.dart';
import '../models/drink_item.dart';
import '../models/intake_record.dart';

class LocalStorageService {
  static const _themeModeKey = 'app.themeMode';
  static const _localeKey = 'app.locale';
  static const _profileKey = 'journal.profile';
  static const _recordsKey = 'journal.records';
  static const _drinkPresetsKey = 'journal.drinkPresets';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String?> loadThemeMode() async {
    return (await _prefs).getString(_themeModeKey);
  }

  Future<void> saveThemeMode(String themeModeName) async {
    await (await _prefs).setString(_themeModeKey, themeModeName);
  }

  Future<String?> loadLocaleTag() async {
    return (await _prefs).getString(_localeKey);
  }

  Future<void> saveLocaleTag(String? tag) async {
    final prefs = await _prefs;
    if (tag == null || tag.isEmpty) {
      await prefs.remove(_localeKey);
      return;
    }

    await prefs.setString(_localeKey, tag);
  }

  Future<CaffeineProfile?> loadProfile() async {
    final raw = (await _prefs).getString(_profileKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return CaffeineProfile.fromJson(
      jsonDecode(raw) as Map<String, Object?>,
    );
  }

  Future<void> saveProfile(CaffeineProfile profile) async {
    await (await _prefs).setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<List<IntakeRecord>> loadRecords() async {
    final raw = (await _prefs).getString(_recordsKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final data = jsonDecode(raw) as List<dynamic>;
    return data
        .cast<Map<String, dynamic>>()
        .map((item) => IntakeRecord.fromJson(item))
        .toList(growable: false);
  }

  Future<void> saveRecords(List<IntakeRecord> records) async {
    final payload = records.map((record) => record.toJson()).toList();
    await (await _prefs).setString(_recordsKey, jsonEncode(payload));
  }

  Future<Map<String, DrinkItem>> loadDrinkPresets() async {
    final raw = (await _prefs).getString(_drinkPresetsKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, DrinkItem.fromJson(value as Map<String, dynamic>)));
  }

  Future<void> saveDrinkPresets(Map<String, DrinkItem> presets) async {
    final payload = presets.map((key, value) => MapEntry(key, value.toJson()));
    await (await _prefs).setString(_drinkPresetsKey, jsonEncode(payload));
  }
}
