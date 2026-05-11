import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class AppController extends ChangeNotifier {
  AppController(this._storage);

  final LocalStorageService _storage;

  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  String get localeTag => _locale?.toLanguageTag() ?? 'system';

  Future<void> load() async {
    final storedTheme = await _storage.loadThemeMode();
    final storedLocale = await _storage.loadLocaleTag();

    _themeMode = _themeModeFromName(storedTheme);
    _locale = _localeFromTag(storedLocale);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    if (_themeMode == value) {
      return;
    }

    _themeMode = value;
    notifyListeners();
    await _storage.saveThemeMode(value.name);
  }

  Future<void> setLocaleTag(String tag) async {
    final nextLocale = tag == 'system' ? null : _localeFromTag(tag);
    final nextTag = nextLocale?.toLanguageTag() ?? 'system';
    if (nextTag == localeTag) {
      return;
    }

    _locale = nextLocale;
    notifyListeners();
    await _storage.saveLocaleTag(_locale?.toLanguageTag());
  }

  ThemeMode _themeModeFromName(String? name) {
    return ThemeMode.values.firstWhere(
      (value) => value.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  Locale? _localeFromTag(String? tag) {
    if (tag == null || tag.isEmpty) {
      return null;
    }

    switch (tag) {
      case 'en':
        return const Locale('en');
      case 'zh':
        return const Locale('zh');
      case 'zh-Hant':
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
      default:
        return null;
    }
  }
}
