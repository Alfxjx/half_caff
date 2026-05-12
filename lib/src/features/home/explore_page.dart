import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
import 'widgets/section_header.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;

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
              final cardWidth = isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(emoji: '☕', title: l10n.encyclopediaCardTitle, body: l10n.encyclopediaCardBody),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(emoji: '⚗️', title: l10n.metabolismCardTitle, body: l10n.metabolismCardBody),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(emoji: '∑', title: l10n.formulaCardTitle, body: l10n.formulaCardBody),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ExploreCard(emoji: '🧬', title: l10n.factorsCardTitle, body: l10n.factorsCardBody),
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
                Text(l10n.referenceTableTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                _ReferenceRow(label: l10n.coffeeCategory, count: '15', examples: 'Espresso · Americano · Latte · Cold Brew'),
                _ReferenceRow(label: l10n.teaCategory, count: '4', examples: 'Black Tea · Green Tea · Matcha · Oolong'),
                _ReferenceRow(label: l10n.sodaCategory, count: '2', examples: 'Cola · Diet Cola'),
                _ReferenceRow(label: l10n.energyCategory, count: '2', examples: 'Red Bull · Monster'),
                _ReferenceRow(label: l10n.supplementCategory, count: '2', examples: 'Caffeine Pill · Pre-workout'),
                _ReferenceRow(label: l10n.foodCategory, count: '2', examples: 'Dark Chocolate · Milk Chocolate', isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.emoji, required this.title, required this.body});

  final String emoji;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
  });

  final String label;
  final String count;
  final String examples;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: palette.hairline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
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
            child: Text(examples, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted)),
          ),
        ],
      ),
    );
  }
}
