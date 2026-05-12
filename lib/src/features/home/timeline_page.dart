import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/caffeine_calculator.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
import 'widgets/section_header.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final points = CaffeineCalculator.buildTimeline(
      records: controller.records,
      profile: controller.profile,
      now: now,
      pastWindow: const Duration(hours: 8),
      futureWindow: const Duration(hours: 16),
      previewDoseMg: controller.whatIfDoseMg,
    );
    final insights = CaffeineCalculator.buildInsights(
      controller.records,
      controller.profile,
      now,
    );
    final peak = points.fold<double>(0, (max, p) => math.max(max, p.amountMg));
    final p = context.palette;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: l10n.timelineHeadline),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: p.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  child: CustomPaint(
                    painter: TimelineChartPainter(
                      points: points,
                      now: now,
                      palette: p,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('-8h', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: p.onDarkSoft)),
                    Text('now', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: p.onDarkSoft)),
                    Text('+16h', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: p.onDarkSoft)),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '${l10n.previewDoseLabel}: ${controller.whatIfDoseMg}${l10n.previewDoseUnit}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: p.onDark,
                      ),
                ),
                const SizedBox(height: 8),
                Slider(
                  min: 0,
                  max: 300,
                  divisions: 12,
                  value: controller.whatIfDoseMg.toDouble(),
                  onChanged: (v) => controller.setWhatIfDose(v.round()),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossCount = constraints.maxWidth > 480 ? 4 : 2;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: [
                        _DarkMetricTile(label: l10n.peakLevelLabel, value: '${peak.toStringAsFixed(0)} mg'),
                        _DarkMetricTile(
                          label: l10n.lowRiskWindowLabel,
                          value: insights.lowRiskTime == null
                              ? l10n.timeUnknown
                              : _formatClockTime(context, insights.lowRiskTime!),
                        ),
                        _DarkMetricTile(
                          label: l10n.fullyClearedLabel,
                          value: insights.fullyClearedTime == null
                              ? l10n.timeUnknown
                              : _formatClockTime(context, insights.fullyClearedTime!),
                        ),
                        _DarkMetricTile(
                          label: l10n.projectedAtSleepLabel,
                          value: '${insights.projectedAtSleepMg.toStringAsFixed(0)} mg',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.timelineNotice,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: p.onDarkSoft,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatClockTime(BuildContext context, DateTime dt) {
    return MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(dt));
  }
}

class _DarkMetricTile extends StatelessWidget {
  const _DarkMetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.surfaceDarkElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: p.onDarkSoft,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: p.onDark,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ],
      ),
    );
  }
}

class TimelineChartPainter extends CustomPainter {
  TimelineChartPainter({
    required this.points,
    required this.now,
    required this.palette,
  });

  final List<TimelinePoint> points;
  final DateTime now;
  final ClaudePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    const padding = EdgeInsets.fromLTRB(8, 12, 8, 18);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );
    final maxY = math.max(100.0, points.fold<double>(0, (max, p) => math.max(max, p.amountMg)));

    // Grid lines
    final gridPaint = Paint()
      ..color = palette.hairlineSoft.withOpacity(0.5)
      ..strokeWidth = 1;
    for (var step = 0; step <= 4; step++) {
      final dy = chartRect.top + chartRect.height * (step / 4);
      canvas.drawLine(Offset(chartRect.left, dy), Offset(chartRect.right, dy), gridPaint);
    }

    // Low-risk zone fill
    final lowRiskY = chartRect.bottom - (20 / maxY) * chartRect.height;
    final lowRiskPaint = Paint()
      ..color = palette.success.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(chartRect.left, lowRiskY, chartRect.right, chartRect.bottom - lowRiskY), lowRiskPaint);

    // Build path
    final linePath = Path();
    final fillPath = Path();
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final dx = chartRect.left + (index / (points.length - 1)) * chartRect.width;
      final dy = chartRect.bottom - (point.amountMg / maxY) * chartRect.height;
      if (index == 0) {
        linePath.moveTo(dx, dy);
        fillPath.moveTo(dx, chartRect.bottom);
        fillPath.lineTo(dx, dy);
      } else {
        linePath.lineTo(dx, dy);
        fillPath.lineTo(dx, dy);
      }
    }
    fillPath.lineTo(chartRect.right, chartRect.bottom);
    fillPath.close();

    // Fill
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = palette.primary.withOpacity(0.15)
        ..style = PaintingStyle.fill,
    );

    // Line
    canvas.drawPath(
      linePath,
      Paint()
        ..color = palette.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Now marker
    final nowIndex = _nearestIndexToNow();
    final nowDx = chartRect.left + (nowIndex / (points.length - 1)) * chartRect.width;
    canvas.drawLine(
      Offset(nowDx, chartRect.top),
      Offset(nowDx, chartRect.bottom),
      Paint()
        ..color = palette.accentAmber
        ..strokeWidth = 1.5,
    );
  }

  int _nearestIndexToNow() {
    var best = 0;
    var smallest = const Duration(days: 99);
    for (var i = 0; i < points.length; i++) {
      final diff = points[i].time.difference(now).abs();
      if (diff < smallest) {
        smallest = diff;
        best = i;
      }
    }
    return best;
  }

  @override
  bool shouldRepaint(TimelineChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.now != now || oldDelegate.palette != palette;
}
