import 'dart:math';

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class _HalfLifeRow {
  const _HalfLifeRow({
    required this.type,
    required this.population,
    required this.halfLifeHours,
  });

  final String type;
  final String population;
  final double halfLifeHours;
}

const _halfLifeData = [
  _HalfLifeRow(type: '超快速代谢者', population: '极少数', halfLifeHours: 2.0),
  _HalfLifeRow(type: '快速代谢者 (AA)', population: '~45%人群', halfLifeHours: 3.0),
  _HalfLifeRow(type: '正常代谢者', population: '一般健康成人', halfLifeHours: 5.0),
  _HalfLifeRow(type: '慢速代谢者 (AC)', population: '~45%人群', halfLifeHours: 7.0),
  _HalfLifeRow(type: '超慢代谢者 (CC)', population: '~10%人群', halfLifeHours: 10.0),
  _HalfLifeRow(type: '口服避孕药使用者', population: '服用OC女性', halfLifeHours: 10.0),
  _HalfLifeRow(type: '孕妇(晚期)', population: '妊娠晚期女性', halfLifeHours: 15.0),
];

class HalfLifeTablePage extends StatelessWidget {
  const HalfLifeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('个体化半衰期参考值'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: p.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: p.hairline.withOpacity(0.6)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 480;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(p.surfaceDark),
                      dataRowMinHeight: 48,
                      horizontalMargin: 16,
                      columnSpacing: isNarrow ? 16 : 24,
                      columns: [
                        DataColumn(
                          label: Text(
                            '代谢类型',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '代表人群',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            't₁/₂ (h)',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'ke (h⁻¹)',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            '1h后',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            '4h后',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            '8h后',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: p.onDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                      rows: _halfLifeData.asMap().entries.map((entry) {
                        final row = entry.value;
                        final ke = 0.693 / row.halfLifeHours;
                        final r1 = pow(0.5, 1 / row.halfLifeHours) * 100;
                        final r4 = pow(0.5, 4 / row.halfLifeHours) * 100;
                        final r8 = pow(0.5, 8 / row.halfLifeHours) * 100;
                        final isEven = entry.key % 2 == 0;

                        return DataRow(
                          color: WidgetStateProperty.all(
                            isEven ? p.surfaceCard : p.canvas.withOpacity(0.5),
                          ),
                          cells: [
                            DataCell(
                              Text(
                                row.type,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            DataCell(
                              Text(
                                row.population,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: p.muted,
                                    ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${row.halfLifeHours}h',
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: p.primary,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                ke.toStringAsFixed(4),
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${r1.toStringAsFixed(1)}%',
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${r4.toStringAsFixed(1)}%',
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${r8.toStringAsFixed(1)}%',
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
