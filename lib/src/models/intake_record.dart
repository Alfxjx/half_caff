class IntakeRecord {
  const IntakeRecord({
    required this.id,
    required this.consumedAt,
    required this.loggedAt,
    required this.caffeineAmountMg,
    required this.emoji,
    this.sourceDrinkId,
    this.customName,
  });

  final String id;
  final DateTime consumedAt;
  final DateTime loggedAt;
  final int caffeineAmountMg;
  final String emoji;
  final String? sourceDrinkId;
  final String? customName;

  IntakeRecord copyWith({
    String? id,
    DateTime? consumedAt,
    DateTime? loggedAt,
    int? caffeineAmountMg,
    String? emoji,
    String? sourceDrinkId,
    bool clearSourceDrinkId = false,
    String? customName,
    bool clearCustomName = false,
  }) {
    return IntakeRecord(
      id: id ?? this.id,
      consumedAt: consumedAt ?? this.consumedAt,
      loggedAt: loggedAt ?? this.loggedAt,
      caffeineAmountMg: caffeineAmountMg ?? this.caffeineAmountMg,
      emoji: emoji ?? this.emoji,
      sourceDrinkId:
          clearSourceDrinkId ? null : sourceDrinkId ?? this.sourceDrinkId,
      customName: clearCustomName ? null : customName ?? this.customName,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'consumedAt': consumedAt.toIso8601String(),
      'loggedAt': loggedAt.toIso8601String(),
      'caffeineAmountMg': caffeineAmountMg,
      'emoji': emoji,
      'sourceDrinkId': sourceDrinkId,
      'customName': customName,
    };
  }

  factory IntakeRecord.fromJson(Map<String, Object?> json) {
    return IntakeRecord(
      id: json['id'] as String,
      consumedAt: DateTime.parse(json['consumedAt'] as String),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      caffeineAmountMg: json['caffeineAmountMg'] as int,
      emoji: json['emoji'] as String? ?? '☕',
      sourceDrinkId: json['sourceDrinkId'] as String?,
      customName: json['customName'] as String?,
    );
  }
}
