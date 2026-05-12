import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/caffeine_calculator.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
import 'widgets/empty_card.dart';
import 'widgets/record_list_item.dart';
import 'widgets/section_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final insights = CaffeineCalculator.buildInsights(
      controller.records,
      controller.profile,
      now,
    );
    final progress = (insights.currentAmountMg / 220).clamp(0.0, 1.0);
    final recentRecords = controller.records.take(5).toList(growable: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: l10n.dashboardHeadline),
          const SizedBox(height: 24),
          _StatusCard(
            currentMg: insights.currentAmountMg.toStringAsFixed(0),
            risk: insights.risk,
            lowRiskTime: insights.lowRiskTime,
            progress: progress,
            l10n: l10n,
          ),
          const SizedBox(height: 24),
          _MetricGrid(insights: insights, l10n: l10n),
          const SizedBox(height: 32),
          SectionHeader(label: l10n.recentSamplesLabel),
          const SizedBox(height: 16),
          if (recentRecords.isEmpty)
            EmptyCard(title: l10n.noRecordsTitle, body: l10n.noRecordsBody)
          else
            ...recentRecords.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecordListItem(
                  record: entry.value,
                  index: entry.key,
                  l10n: l10n,
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.currentMg,
    required this.risk,
    required this.lowRiskTime,
    required this.progress,
    required this.l10n,
  });

  final String currentMg;
  final CaffeineRisk risk;
  final DateTime? lowRiskTime;
  final double progress;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.hairline.withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.labEstimate,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: palette.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$currentMg mg',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.5,
                        color: palette.ink,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _riskTint(risk, palette),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: _riskBorder(risk, palette)),
                  ),
                  child: Text(
                    _riskLabel(context, risk, lowRiskTime),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.bodyStrong,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    backgroundColor: palette.hairline,
                    color: palette.primary,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentMg,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: palette.ink,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                    Text(
                      'mg',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: palette.muted,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _riskTint(CaffeineRisk risk, ClaudePalette p) {
    switch (risk) {
      case CaffeineRisk.low:
        return p.success.withOpacity(0.15);
      case CaffeineRisk.medium:
        return p.warning.withOpacity(0.15);
      case CaffeineRisk.high:
        return p.error.withOpacity(0.1);
    }
  }

  Color _riskBorder(CaffeineRisk risk, ClaudePalette p) {
    switch (risk) {
      case CaffeineRisk.low:
        return p.success.withOpacity(0.3);
      case CaffeineRisk.medium:
        return p.warning.withOpacity(0.3);
      case CaffeineRisk.high:
        return p.error.withOpacity(0.25);
    }
  }

  String _riskLabel(BuildContext context, CaffeineRisk risk, DateTime? lowRiskTime) {
    final l10n = AppLocalizations.of(context)!;
    switch (risk) {
      case CaffeineRisk.low:
        return l10n.riskLowBody;
      case CaffeineRisk.medium:
        return l10n.riskMediumBody;
      case CaffeineRisk.high:
        final t = lowRiskTime == null ? l10n.lowRiskTimeUnavailable : _formatTime(context, lowRiskTime);
        return l10n.riskHighBody(t);
    }
  }

  String _formatTime(BuildContext context, DateTime dt) {
    return MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(dt));
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.insights, required this.l10n});

  final dynamic insights;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (l10n.dailyBudgetUsedLabel, '${insights.dailyTotalMg} mg'),
      (l10n.halfLifeLabel, '${insights.halfLifeHours.toStringAsFixed(1)} h'),
      (l10n.budgetRemainingLabel, '${insights.budgetRemainingMg} mg'),
      (l10n.projectedAtSleepLabel, '${insights.projectedAtSleepMg.toStringAsFixed(0)} mg'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 480 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: metrics.map((m) => _MetricTile(label: m.$1, value: m.$2)).toList(),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.hairline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.ink,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ],
      ),
    );
  }
}
