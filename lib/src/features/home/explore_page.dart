import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../features/explore/drink_encyclopedia_page.dart';
import '../../features/explore/drink_preset_manager_page.dart';
import '../../features/explore/factors_page.dart';
import '../../features/explore/formula_page.dart';
import '../../features/explore/half_life_table_page.dart';
import '../../features/explore/literature_page.dart';
import '../../features/explore/metabolism_pathway_page.dart';
import '../../features/explore/multi_dose_simulator_page.dart';
import '../../features/explore/single_dose_calculator_page.dart';
import '../../models/drink_item.dart';
import '../../state/caffeine_journal_controller.dart';
import 'widgets/section_header.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final drinks = controller.availableDrinks;

    final categoryCounts = <DrinkCategory, int>{};
    for (final drink in drinks) {
      categoryCounts[drink.category] =
          (categoryCounts[drink.category] ?? 0) + 1;
    }

    final categories = [
      (
        DrinkCategory.coffee,
        l10n.coffeeCategory,
        'Espresso · Americano · Latte · Cold Brew'
      ),
      (
        DrinkCategory.tea,
        l10n.teaCategory,
        'Black Tea · Green Tea · Matcha · Oolong'
      ),
      (DrinkCategory.soda, l10n.sodaCategory, 'Cola · Diet Cola'),
      (DrinkCategory.energy, l10n.energyCategory, 'Red Bull · Monster'),
      (
        DrinkCategory.supplement,
        l10n.supplementCategory,
        'Caffeine Pill · Pre-workout'
      ),
      (
        DrinkCategory.food,
        l10n.foodCategory,
        'Dark Chocolate · Milk Chocolate'
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: l10n.exploreHeadline),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 480;
              final cardWidth = isWide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(
                      emoji: '☕',
                      title: l10n.encyclopediaCardTitle,
                      body: l10n.encyclopediaCardBody,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const DrinkEncyclopediaPage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(
                      emoji: '⚗️',
                      title: l10n.metabolismCardTitle,
                      body: l10n.metabolismCardBody,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const MetabolismPathwayPage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(
                      emoji: '∑',
                      title: l10n.formulaCardTitle,
                      body: l10n.formulaCardBody,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FormulaPage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(
                      emoji: '🧬',
                      title: l10n.factorsCardTitle,
                      body: l10n.factorsCardBody,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FactorsPage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(
                      emoji: '📊',
                      title: '单次摄入计算器',
                      body: '模拟单次咖啡因摄入后的体内衰减过程，对比不同代谢速度。',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const SingleDoseCalculatorPage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(
                      emoji: '📈',
                      title: '多次摄入模拟器',
                      body: '输入多组摄入时间和剂量，计算24小时内的咖啡因累积效应。',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const MultiDoseSimulatorPage()),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: palette.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.hairline.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.referenceTableTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              DrinkPresetManagerPage(controller: controller),
                        ),
                      ),
                      child: Text(l10n.manageDrinksLabel),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...categories.map((entry) {
                  final (category, label, examples) = entry;
                  final count = categoryCounts[category] ?? 0;
                  final isLast = category == categories.last.$1;
                  return _ReferenceRow(
                    label: label,
                    count: count.toString(),
                    examples: examples,
                    isLast: isLast,
                    onTap: count > 0
                        ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DrinkPresetManagerPage(
                                  controller: controller,
                                  initialCategory: category,
                                ),
                              ),
                            )
                        : null,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionLinkTile(
            icon: Icons.timer_outlined,
            title: '个体化半衰期参考值',
            subtitle: '7 类人群的代谢速度对比',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HalfLifeTablePage()),
            ),
          ),
          const SizedBox(height: 10),
          _SectionLinkTile(
            icon: Icons.menu_book_outlined,
            title: '关键参考文献',
            subtitle: '10 篇药代动力学核心文献',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LiteraturePage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLinkTile extends StatelessWidget {
  const _SectionLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: palette.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.hairline.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.surfaceCreamStrong,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: palette.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, size: 16, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.emoji,
    required this.title,
    required this.body,
    this.onTap,
  });

  final String emoji;
  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: palette.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.hairline.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.surfaceCreamStrong,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward, size: 16, color: palette.muted),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: palette.muted, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  const _ReferenceRow({
    required this.label,
    required this.count,
    required this.examples,
    this.isLast = false,
    this.onTap,
  });

  final String label;
  final String count;
  final String examples;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final child = Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border:
            isLast ? null : Border(bottom: BorderSide(color: palette.hairline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 32,
            child: Text(
              count,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.primary,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            child: Text(examples,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: palette.muted)),
          ),
          if (onTap != null)
            Icon(Icons.chevron_right, size: 16, color: palette.muted),
        ],
      ),
    );

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }
}
