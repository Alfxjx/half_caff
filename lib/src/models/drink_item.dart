enum DrinkCategory { coffee, tea, soda, energy, supplement, food }

class DrinkItem {
  const DrinkItem({
    required this.id,
    required this.category,
    required this.caffeineMg,
    required this.volumeMl,
    required this.emoji,
    this.customName,
  });

  final String id;
  final DrinkCategory category;
  final int caffeineMg;
  final int volumeMl;
  final String emoji;
  final String? customName;

  DrinkItem copyWith({
    String? id,
    DrinkCategory? category,
    int? caffeineMg,
    int? volumeMl,
    String? emoji,
    String? customName,
    bool clearCustomName = false,
  }) {
    return DrinkItem(
      id: id ?? this.id,
      category: category ?? this.category,
      caffeineMg: caffeineMg ?? this.caffeineMg,
      volumeMl: volumeMl ?? this.volumeMl,
      emoji: emoji ?? this.emoji,
      customName: clearCustomName ? null : (customName ?? this.customName),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'category': category.name,
      'caffeineMg': caffeineMg,
      'volumeMl': volumeMl,
      'emoji': emoji,
      if (customName != null) 'customName': customName,
    };
  }

  factory DrinkItem.fromJson(Map<String, Object?> json) {
    return DrinkItem(
      id: json['id'] as String,
      category: DrinkCategory.values.byName(json['category'] as String),
      caffeineMg: json['caffeineMg'] as int,
      volumeMl: json['volumeMl'] as int,
      emoji: json['emoji'] as String,
      customName: json['customName'] as String?,
    );
  }
}
