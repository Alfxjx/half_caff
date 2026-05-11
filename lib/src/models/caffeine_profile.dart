enum MetabolismPreset { fast, normal, slow, unknown }

enum Cyp1a2Genotype { aa, ac, cc, unknown }

enum LiverStatus { none, mild, moderate, severe }

class CaffeineProfile {
  const CaffeineProfile({
    required this.dailyBudgetMg,
    required this.targetSleepMinutes,
    required this.metabolismPreset,
    required this.isSmoker,
    required this.usesOralContraceptives,
    required this.isPregnant,
    required this.liverStatus,
    required this.age,
    required this.drinksAlcohol,
    required this.genotype,
    this.customHalfLifeHours,
  });

  final int dailyBudgetMg;
  final int targetSleepMinutes;
  final MetabolismPreset metabolismPreset;
  final double? customHalfLifeHours;
  final bool isSmoker;
  final bool usesOralContraceptives;
  final bool isPregnant;
  final LiverStatus liverStatus;
  final int age;
  final bool drinksAlcohol;
  final Cyp1a2Genotype genotype;

  factory CaffeineProfile.defaults() {
    return const CaffeineProfile(
      dailyBudgetMg: 400,
      targetSleepMinutes: 23 * 60,
      metabolismPreset: MetabolismPreset.normal,
      customHalfLifeHours: null,
      isSmoker: false,
      usesOralContraceptives: false,
      isPregnant: false,
      liverStatus: LiverStatus.none,
      age: 29,
      drinksAlcohol: false,
      genotype: Cyp1a2Genotype.unknown,
    );
  }

  CaffeineProfile copyWith({
    int? dailyBudgetMg,
    int? targetSleepMinutes,
    MetabolismPreset? metabolismPreset,
    double? customHalfLifeHours,
    bool clearCustomHalfLife = false,
    bool? isSmoker,
    bool? usesOralContraceptives,
    bool? isPregnant,
    LiverStatus? liverStatus,
    int? age,
    bool? drinksAlcohol,
    Cyp1a2Genotype? genotype,
  }) {
    return CaffeineProfile(
      dailyBudgetMg: dailyBudgetMg ?? this.dailyBudgetMg,
      targetSleepMinutes: targetSleepMinutes ?? this.targetSleepMinutes,
      metabolismPreset: metabolismPreset ?? this.metabolismPreset,
      customHalfLifeHours: clearCustomHalfLife
          ? null
          : customHalfLifeHours ?? this.customHalfLifeHours,
      isSmoker: isSmoker ?? this.isSmoker,
      usesOralContraceptives:
          usesOralContraceptives ?? this.usesOralContraceptives,
      isPregnant: isPregnant ?? this.isPregnant,
      liverStatus: liverStatus ?? this.liverStatus,
      age: age ?? this.age,
      drinksAlcohol: drinksAlcohol ?? this.drinksAlcohol,
      genotype: genotype ?? this.genotype,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'dailyBudgetMg': dailyBudgetMg,
      'targetSleepMinutes': targetSleepMinutes,
      'metabolismPreset': metabolismPreset.name,
      'customHalfLifeHours': customHalfLifeHours,
      'isSmoker': isSmoker,
      'usesOralContraceptives': usesOralContraceptives,
      'isPregnant': isPregnant,
      'liverStatus': liverStatus.name,
      'age': age,
      'drinksAlcohol': drinksAlcohol,
      'genotype': genotype.name,
    };
  }

  factory CaffeineProfile.fromJson(Map<String, Object?> json) {
    return CaffeineProfile(
      dailyBudgetMg: json['dailyBudgetMg'] as int? ?? 400,
      targetSleepMinutes: json['targetSleepMinutes'] as int? ?? 23 * 60,
      metabolismPreset: MetabolismPreset.values.firstWhere(
        (value) => value.name == json['metabolismPreset'],
        orElse: () => MetabolismPreset.normal,
      ),
      customHalfLifeHours: (json['customHalfLifeHours'] as num?)?.toDouble(),
      isSmoker: json['isSmoker'] as bool? ?? false,
      usesOralContraceptives: json['usesOralContraceptives'] as bool? ?? false,
      isPregnant: json['isPregnant'] as bool? ?? false,
      liverStatus: LiverStatus.values.firstWhere(
        (value) => value.name == json['liverStatus'],
        orElse: () => LiverStatus.none,
      ),
      age: json['age'] as int? ?? 29,
      drinksAlcohol: json['drinksAlcohol'] as bool? ?? false,
      genotype: Cyp1a2Genotype.values.firstWhere(
        (value) => value.name == json['genotype'],
        orElse: () => Cyp1a2Genotype.unknown,
      ),
    );
  }
}
