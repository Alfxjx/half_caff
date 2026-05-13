import 'dart:math';

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class _MetabolismOption {
  const _MetabolismOption({
    required this.label,
    required this.halfLifeHours,
    required this.color,
  });

  final String label;
  final double halfLifeHours;
  final Color color;
}

const _metabolismOptions = [
  _MetabolismOption(label: '超快速代谢', halfLifeHours: 2.0, color: Color(0xFF06A77D)),
  _MetabolismOption(label: '快速代谢 AA', halfLifeHours: 3.0, color: Color(0xFF2E86AB)),
  _MetabolismOption(label: '正常代谢', halfLifeHours: 5.0, color: Color(0xFFA23B72)),
  _MetabolismOption(label: '慢速代谢 AC', halfLifeHours: 7.0, color: Color(0xFFF18F01)),
  _MetabolismOption(label: '超慢代谢 CC', halfLifeHours: 10.0, color: Color(0xFFC73E1D)),
  _MetabolismOption(label: '孕妇晚期', halfLifeHours: 15.0, color: Color(0xFF6B2D5C)),
];

class SingleDoseCalculatorPage extends StatefulWidget {
  const SingleDoseCalculatorPage({super.key});

  @override
  State<SingleDoseCalculatorPage> createState() =>
      _SingleDoseCalculatorPageState();
}

class _SingleDoseCalculatorPageState extends State<SingleDoseCalculatorPage> {
  double _doseMg = 200;
  double _hours = 6;
  double _selectedHalfLife = 5.0;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ke = 0.693 / _selectedHalfLife;
    final remaining = _doseMg * pow(0.5, _hours / _selectedHalfLife);
    final percent = remaining / _doseMg * 100;

    String status;
    if (remaining > 100) {
      status = '高 ⚠️';
    } else if (remaining > 50) {
      status = '中等';
    } else if (remaining > 10) {
      status = '低';
    } else {
      status = '可忽略';
    }

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('单次摄入计算器'),
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
                    '摄入咖啡因量 (mg)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: p.muted,
                        ),
                  ),
                  Slider(
                    min: 50,
                    max: 400,
                    divisions: 7,
                    value: _doseMg,
                    onChanged: (v) => setState(() => _doseMg = v),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_doseMg.round()} mg',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: p.primary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '经过时间 (小时)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: p.muted,
                        ),
                  ),
                  Slider(
                    min: 0,
                    max: 24,
                    divisions: 48,
                    value: _hours,
                    onChanged: (v) => setState(() => _hours = v),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_hours.toStringAsFixed(1)} h',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: p.primary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                        label: Text(
                            '${option.label} (${option.halfLifeHours}h)'),
                        selected: isSelected,
                        onSelected: (_) => setState(
                            () => _selectedHalfLife = option.halfLifeHours),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
                    '计算结果',
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
                            label: '剩余咖啡因',
                            value: '${remaining.toStringAsFixed(1)} mg',
                            palette: p,
                          ),
                          _ResultTile(
                            label: '剩余比例',
                            value: '${percent.toStringAsFixed(1)}%',
                            palette: p,
                          ),
                          _ResultTile(
                            label: '消除速率 ke',
                            value: '${ke.toStringAsFixed(4)} h⁻¹',
                            palette: p,
                          ),
                          _ResultTile(
                            label: '状态评估',
                            value: status,
                            palette: p,
                          ),
                        ],
                      );
                    },
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
                    '单次摄入衰减曲线对比',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: CustomPaint(
                      painter: _DecayChartPainter(
                        dose: _doseMg,
                        selectedHalfLife: _selectedHalfLife,
                        palette: p,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: _metabolismOptions.map((option) {
                      final isSelected =
                          option.halfLifeHours == _selectedHalfLife;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 3,
                            decoration: BoxDecoration(
                              color: option.color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            option.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: isSelected ? p.ink : p.muted,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

class _DecayChartPainter extends CustomPainter {
  _DecayChartPainter({
    required this.dose,
    required this.selectedHalfLife,
    required this.palette,
  });

  final double dose;
  final double selectedHalfLife;
  final ClaudePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    const padding = EdgeInsets.fromLTRB(8, 12, 8, 18);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    const times = 25;
    double maxY = dose;
    for (final option in _metabolismOptions) {
      for (var t = 0; t < times; t++) {
        final y = dose * pow(0.5, t / option.halfLifeHours);
        if (y > maxY) maxY = y;
      }
    }
    maxY = max(maxY * 1.1, 50);

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

    // Draw each curve
    for (final option in _metabolismOptions) {
      final path = Path();
      for (var t = 0; t < times; t++) {
        final dx = chartRect.left + (t / (times - 1)) * chartRect.width;
        final y = dose * pow(0.5, t / option.halfLifeHours);
        final dy = chartRect.bottom - (y / maxY) * chartRect.height;
        if (t == 0) {
          path.moveTo(dx, dy);
        } else {
          path.lineTo(dx, dy);
        }
      }

      final isSelected = option.halfLifeHours == selectedHalfLife;
      canvas.drawPath(
        path,
        Paint()
          ..color = option.color
          ..strokeWidth = isSelected ? 3 : 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DecayChartPainter oldDelegate) {
    return oldDelegate.dose != dose ||
        oldDelegate.selectedHalfLife != selectedHalfLife ||
        oldDelegate.palette != palette;
  }
}
