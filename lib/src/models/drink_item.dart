enum DrinkCategory { coffee, tea, soda, energy, supplement, food }

class DrinkItem {
  const DrinkItem({
    required this.id,
    required this.category,
    required this.caffeineMg,
    required this.volumeMl,
    required this.emoji,
  });

  final String id;
  final DrinkCategory category;
  final int caffeineMg;
  final int volumeMl;
  final String emoji;
}
