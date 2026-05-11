import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/caffeine_profile.dart';
import '../models/drink_item.dart';
import '../models/intake_record.dart';
import '../services/local_storage_service.dart';

class CaffeineJournalController extends ChangeNotifier {
  CaffeineJournalController(this._storage);

  final LocalStorageService _storage;

  final List<DrinkItem> availableDrinks = const [
    DrinkItem(
      id: 'americano',
      category: DrinkCategory.coffee,
      caffeineMg: 150,
      volumeMl: 240,
      emoji: '☕',
    ),
    DrinkItem(
      id: 'latte',
      category: DrinkCategory.coffee,
      caffeineMg: 80,
      volumeMl: 300,
      emoji: '🥛',
    ),
    DrinkItem(
      id: 'espresso',
      category: DrinkCategory.coffee,
      caffeineMg: 65,
      volumeMl: 30,
      emoji: '⚗️',
    ),
    DrinkItem(
      id: 'cold_brew',
      category: DrinkCategory.coffee,
      caffeineMg: 190,
      volumeMl: 355,
      emoji: '🧊',
    ),
    DrinkItem(
      id: 'black_tea',
      category: DrinkCategory.tea,
      caffeineMg: 45,
      volumeMl: 240,
      emoji: '🫖',
    ),
    DrinkItem(
      id: 'green_tea',
      category: DrinkCategory.tea,
      caffeineMg: 28,
      volumeMl: 240,
      emoji: '🍃',
    ),
    DrinkItem(
      id: 'cola',
      category: DrinkCategory.soda,
      caffeineMg: 34,
      volumeMl: 330,
      emoji: '🥤',
    ),
    DrinkItem(
      id: 'energy_drink',
      category: DrinkCategory.energy,
      caffeineMg: 110,
      volumeMl: 250,
      emoji: '⚡',
    ),
  ];

  int _selectedTab = 0;
  int _whatIfDoseMg = 120;
  CaffeineProfile _profile = CaffeineProfile.defaults();
  List<IntakeRecord> _records = const [];
  Timer? _refreshTicker;

  int get selectedTab => _selectedTab;
  int get whatIfDoseMg => _whatIfDoseMg;
  CaffeineProfile get profile => _profile;
  List<IntakeRecord> get records => List.unmodifiable(_records);

  Future<void> load() async {
    _profile = await _storage.loadProfile() ?? CaffeineProfile.defaults();

    final storedRecords = await _storage.loadRecords();
    _records =
        storedRecords.isEmpty ? _seedRecords() : _sortRecords(storedRecords);

    _refreshTicker ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => notifyListeners(),
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTicker?.cancel();
    super.dispose();
  }

  void selectTab(int value) {
    if (_selectedTab == value) {
      return;
    }

    _selectedTab = value;
    notifyListeners();
  }

  void setWhatIfDose(int value) {
    if (_whatIfDoseMg == value) {
      return;
    }

    _whatIfDoseMg = value;
    notifyListeners();
  }

  Future<void> updateProfile(CaffeineProfile value) async {
    _profile = value;
    notifyListeners();
    await _storage.saveProfile(_profile);
  }

  Future<void> addDrink(DrinkItem drink, DateTime consumedAt) async {
    final now = DateTime.now();
    final nextRecord = IntakeRecord(
      id: _createId(now),
      consumedAt: consumedAt,
      loggedAt: now,
      caffeineAmountMg: drink.caffeineMg,
      emoji: drink.emoji,
      sourceDrinkId: drink.id,
    );

    _records = _sortRecords([..._records, nextRecord]);
    notifyListeners();
    await _storage.saveRecords(_records);
  }

  Future<void> addCustomRecord({
    required String name,
    required int caffeineAmountMg,
    required DateTime consumedAt,
  }) async {
    final now = DateTime.now();
    final nextRecord = IntakeRecord(
      id: _createId(now),
      consumedAt: consumedAt,
      loggedAt: now,
      caffeineAmountMg: caffeineAmountMg,
      emoji: '🧪',
      customName: name,
    );

    _records = _sortRecords([..._records, nextRecord]);
    notifyListeners();
    await _storage.saveRecords(_records);
  }

  Future<void> updateRecord(IntakeRecord value) async {
    _records = _sortRecords([
      for (final record in _records)
        if (record.id == value.id) value else record,
    ]);
    notifyListeners();
    await _storage.saveRecords(_records);
  }

  Future<void> removeRecord(String id) async {
    _records =
        _records.where((record) => record.id != id).toList(growable: false);
    notifyListeners();
    await _storage.saveRecords(_records);
  }

  List<IntakeRecord> _sortRecords(List<IntakeRecord> input) {
    final sorted = [...input]
      ..sort((left, right) => right.consumedAt.compareTo(left.consumedAt));
    return List.unmodifiable(sorted);
  }

  List<IntakeRecord> _seedRecords() {
    final now = DateTime.now();
    return _sortRecords([
      IntakeRecord(
        id: 'seed-1',
        consumedAt: now.subtract(const Duration(hours: 3, minutes: 30)),
        loggedAt: now.subtract(const Duration(hours: 3, minutes: 25)),
        caffeineAmountMg: 150,
        emoji: '☕',
        sourceDrinkId: 'americano',
      ),
      IntakeRecord(
        id: 'seed-2',
        consumedAt: now.subtract(const Duration(hours: 1)),
        loggedAt: now.subtract(const Duration(minutes: 55)),
        caffeineAmountMg: 80,
        emoji: '🥛',
        sourceDrinkId: 'latte',
      ),
    ]);
  }

  String _createId(DateTime timestamp) {
    return 'record-${timestamp.microsecondsSinceEpoch}';
  }
}
