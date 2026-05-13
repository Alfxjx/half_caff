import 'dart:math';

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class _MetabolismOption {
  const _MetabolismOption({required this.label, required this.halfLifeHours});

  final String label;
  final double halfLifeHours;
}

const _metabolismOptions = [
  _MetabolismOption(label: '超快速代谢 (2h)', halfLifeHours: 2.0),
  _MetabolismOption(label: '快速代谢 AA (3h)', halfLifeHours: 3.0),
  _MetabolismOption(label: '正常代谢 (5h)', halfLifeHours: 5.0),
  _MetabolismOption(label: '慢速代谢 AC (7h)', halfLifeHours: 7.0),
  _MetabolismOption(label: '超慢代谢 CC (10h)', halfLifeHours: 10.0),
  _MetabolismOption(label: '孕妇晚期 (15h)', halfLifeHours: 15.0),
];

class MultiDoseSimulatorPage extends StatefulWidget {
  const MultiDoseSimulatorPage({super.key});

  @override
  State<MultiDoseSimulatorPage> createState() => _MultiDoseSimulatorPageState();
}

class _MultiDoseSimulatorPageState extends State<MultiDoseSimulatorPage> {
  double _selectedHalfLife = 5.0;
  final List<_DoseEntry> _doses = [
    _DoseEntry(time: 0, dose: 120),
    _DoseEntry(time: 2.5, dose: 80),
    _DoseEntry(time: 6, dose: 150),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('多次摄入模拟器'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: p.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.hairline.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '代谢类型',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: p.muted,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _metabolismOptions.map((option) {
                      final isSelected =
                          option.halfLifeHours == _selectedHalfLife;
                      return ChoiceChip(
                        label: Text(option.label),
                        selected: isSelected,
                        onSelected: (_) => setState(
                            () => _selectedHalfLife = option.halfLifeHours),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '摄入记录',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ..._doses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final dose = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                  text: dose.time.toString()),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '时间(h) #${index + 1}',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                              onSubmitted: (value) {
                                final t = double.tryParse(value);
                                if (t != null) {
                                  setState(() => _doses[index].time = t);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                  text: dose.dose.toString()),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '剂量(mg) #${index + 1}',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                              onSubmitted: (value) {
                                final d = int.tryParse(value);
                                if (d != null) {
                                  setState(() => _doses[index].dose = d);
                                }
                              },
                            ),
                          ),
                          if (_doses.length > 1)
                            IconButton(
                              onPressed: () =>
                                  setState(() => _doses.removeAt(index)),
                              icon: Icon(Icons.remove_circle_outline,
                                  color: p.error),
                            ),
                        ],
                      ),
                    );
                  }),
                  if (_doses.length < 6)
                    TextButton.icon(
                      onPressed: () => setState(
                          () => _doses.add(_DoseEntry(time: 0, dose: 0))),
                      icon: const Icon(Icons.add),
                      label: const Text('添加记录'),
                    ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(() {}),
                    child: const Text('计算累积效应'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.hairline.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '多次摄入累积效应',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240,
                    child: CustomPaint(
                      painter: _MultiDoseChartPainter(
                        doses: _doses
                            .where((d) => d.dose > 0)
                            .map((d) => (d.time, d.dose.toDouble()))
                            .toList(),
                        halfLife: _selectedHalfLife,
                        palette: p,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0h',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: p.muted,
                            ),
                      ),
                      Text(
                        '12h',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: p.muted,
                            ),
                      ),
                      Text(
                        '24h',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: p.muted,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SummaryCard(
              doses: _doses.where((d) => d.dose > 0).toList(),
              halfLife: _selectedHalfLife,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoseEntry {
  _DoseEntry({required this.time, required this.dose});

  double time;
  int dose;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.doses, required this.halfLife});

  final List<_DoseEntry> doses;
  final double halfLife;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    var totalInput = 0;
    var peakAmount = 0.0;

    for (final dose in doses) {
      totalInput += dose.dose;
    }

    for (var minute = 0; minute <= 24 * 60; minute += 15) {
      final t = minute / 60.0;
      var amount = 0.0;
      for (final dose in doses) {
        if (t >= dose.time) {
          amount += dose.dose * pow(0.5, (t - dose.time) / halfLife);
        }
      }
      if (amount > peakAmount) peakAmount = amount;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '汇总',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: p.onDark,
                ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 480 ? 4 : 2;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _ResultTile(
                    label: '总摄入量',
                    value: '$totalInput mg',
                    palette: p,
                  ),
                  _ResultTile(
                    label: '峰值体内量',
                    value: '${peakAmount.toStringAsFixed(1)} mg',
                    palette: p,
                  ),
                  _ResultTile(
                    label: '24h 后剩余',
                    value:
                        '${_calculateAt(doses, 24, halfLife).toStringAsFixed(1)} mg',
                    palette: p,
                  ),
                  _ResultTile(
                    label: '半衰期',
                    value: '${halfLife}h',
                    palette: p,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculateAt(List<_DoseEntry> doses, double time, double halfLife) {
    var amount = 0.0;
    for (final dose in doses) {
      if (time >= dose.time) {
        amount += dose.dose * pow(0.5, (time - dose.time) / halfLife);
      }
    }
    return amount;
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surfaceDarkElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.onDarkSoft,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.onDark,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ],
      ),
    );
  }
}

class _MultiDoseChartPainter extends CustomPainter {
  _MultiDoseChartPainter({
    required this.doses,
    required this.halfLife,
    required this.palette,
  });

  final List<(double, double)> doses;
  final double halfLife;
  final ClaudePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    if (doses.isEmpty) return;

    const padding = EdgeInsets.fromLTRB(8, 12, 8, 18);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    const pointCount = 97;
    var maxY = 50.0;
    final amounts = List<double>.filled(pointCount, 0);

    for (var i = 0; i < pointCount; i++) {
      final t = i * 0.25;
      var amount = 0.0;
      for (final (dt, dd) in doses) {
        if (t >= dt) {
          amount += dd * pow(0.5, (t - dt) / halfLife);
        }
      }
      amounts[i] = amount;
      if (amount > maxY) maxY = amount;
    }
    maxY = max(maxY * 1.1, 10);

    // Grid lines
    final gridPaint = Paint()
      ..color = palette.hairlineSoft.withOpacity(0.4)
      ..strokeWidth = 1;
    for (var step = 0; step <= 4; step++) {
      final dy = chartRect.top + chartRect.height * (step / 4);
      canvas.drawLine(
        Offset(chartRect.left, dy),
        Offset(chartRect.right, dy),
        gridPaint,
      );
    }

    // Fill area
    final fillPath = Path();
    for (var i = 0; i < pointCount; i++) {
      final dx = chartRect.left + (i / (pointCount - 1)) * chartRect.width;
      final dy = chartRect.bottom - (amounts[i] / maxY) * chartRect.height;
      if (i == 0) {
        fillPath.moveTo(dx, chartRect.bottom);
        fillPath.lineTo(dx, dy);
      } else {
        fillPath.lineTo(dx, dy);
      }
    }
    fillPath.lineTo(chartRect.right, chartRect.bottom);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = palette.primary.withOpacity(0.12)
        ..style = PaintingStyle.fill,
    );

    // Line
    final linePath = Path();
    for (var i = 0; i < pointCount; i++) {
      final dx = chartRect.left + (i / (pointCount - 1)) * chartRect.width;
      final dy = chartRect.bottom - (amounts[i] / maxY) * chartRect.height;
      if (i == 0) {
        linePath.moveTo(dx, dy);
      } else {
        linePath.lineTo(dx, dy);
      }
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = palette.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dose markers
    for (final (dt, _) in doses) {
      final idx = (dt * 4).round();
      if (idx >= 0 && idx < pointCount) {
        final dx = chartRect.left +
            (idx / (pointCount - 1)) * chartRect.width;
        final markerY = chartRect.bottom -
            (amounts[idx] / maxY) * chartRect.height;
        canvas.drawCircle(
          Offset(dx, markerY),
          5,
          Paint()..color = palette.accentAmber,
        );
        canvas.drawCircle(
          Offset(dx, markerY),
          5,
          Paint()
            ..color = palette.accentAmber
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MultiDoseChartPainter oldDelegate) {
    return oldDelegate.doses != doses ||
        oldDelegate.halfLife != halfLife ||
        oldDelegate.palette != palette;
  }
}
