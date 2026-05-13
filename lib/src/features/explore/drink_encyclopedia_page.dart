import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class _BeanType {
  const _BeanType({required this.name, required this.caffeinePercent});
  final String name;
  final String caffeinePercent;
}

const _beanTypes = [
  _BeanType(name: '罗布斯塔 Robusta', caffeinePercent: '2.2-2.7%'),
  _BeanType(name: '阿拉比卡 Arabica', caffeinePercent: '1.2-1.5%'),
  _BeanType(name: '低因品种 Laurina', caffeinePercent: '0.4-0.6%'),
  _BeanType(name: '脱因咖啡 Decaf', caffeinePercent: '<0.1%'),
];

class _BrewMethod {
  const _BrewMethod({required this.name, required this.coefficient});
  final String name;
  final String coefficient;
}

const _brewMethods = [
  _BrewMethod(name: '冷萃 Cold Brew', coefficient: '0.80-0.90'),
  _BrewMethod(name: '手冲/滴滤 Pour Over', coefficient: '0.85-0.90'),
  _BrewMethod(name: '法压壶 French Press', coefficient: '0.85-0.90'),
  _BrewMethod(name: '爱乐压 AeroPress', coefficient: '0.80'),
  _BrewMethod(name: '摩卡壶 Moka Pot', coefficient: '0.75-0.80'),
  _BrewMethod(name: '意式浓缩 Espresso', coefficient: '0.70'),
];

class _DrinkItem {
  const _DrinkItem({
    required this.name,
    required this.size,
    required this.caffeine,
    required this.note,
  });
  final String name;
  final String size;
  final String caffeine;
  final String note;
}

const _drinkItems = [
  _DrinkItem(name: '意式浓缩 (Single)', size: '30ml', caffeine: '60-75', note: '浓度最高'),
  _DrinkItem(name: '意式浓缩 (Double)', size: '60ml', caffeine: '120-150', note: '咖啡店标准'),
  _DrinkItem(name: '滴滤/美式咖啡', size: '240ml', caffeine: '95-120', note: '最普遍的基准'),
  _DrinkItem(name: '大杯滴滤咖啡', size: '480ml', caffeine: '200-300', note: '接近日上限'),
  _DrinkItem(name: '手冲咖啡', size: '240ml', caffeine: '80-130', note: '取决于粉量'),
  _DrinkItem(name: '冷萃咖啡', size: '240ml', caffeine: '150-200', note: '高粉水比'),
  _DrinkItem(name: '大杯冷萃', size: '480ml', caffeine: '280-320', note: '可能超安全量'),
  _DrinkItem(name: '拿铁/卡布奇诺', size: '350ml', caffeine: '63-126', note: '取决于浓缩份数'),
  _DrinkItem(name: '速溶咖啡', size: '240ml', caffeine: '60-80', note: '品牌差异大'),
  _DrinkItem(name: '红茶', size: '240ml', caffeine: '40-50', note: ''),
  _DrinkItem(name: '绿茶', size: '240ml', caffeine: '20-30', note: ''),
  _DrinkItem(name: '可乐', size: '330ml', caffeine: '30-40', note: ''),
];

class DrinkEncyclopediaPage extends StatelessWidget {
  const DrinkEncyclopediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('一杯咖啡含多少咖啡因'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: '核心计算公式',
              palette: p,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.canvas.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '咖啡因 (mg) = 咖啡粉重量 (g) × 豆种咖啡因% × 1000 × 萃取系数',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'serif',
                        color: p.ink,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.hairline.withOpacity(0.6)),
              ),
              child: Text(
                '简化记忆：阿拉比卡每克粉 ≈ 10mg 咖啡因（考虑萃取率后）',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: p.body,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 480;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SimpleTableCard(
                          title: '豆种咖啡因含量（干重）',
                          header1: '品种',
                          header2: '咖啡因%',
                          rows: _beanTypes
                              .map((b) => (b.name, b.caffeinePercent))
                              .toList(),
                          palette: p,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SimpleTableCard(
                          title: '冲泡方式萃取系数',
                          header1: '冲泡方式',
                          header2: '萃取系数',
                          rows: _brewMethods
                              .map((b) => (b.name, b.coefficient))
                              .toList(),
                          palette: p,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    _SimpleTableCard(
                      title: '豆种咖啡因含量（干重）',
                      header1: '品种',
                      header2: '咖啡因%',
                      rows: _beanTypes
                          .map((b) => (b.name, b.caffeinePercent))
                          .toList(),
                      palette: p,
                    ),
                    const SizedBox(height: 12),
                    _SimpleTableCard(
                      title: '冲泡方式萃取系数',
                      header1: '冲泡方式',
                      header2: '萃取系数',
                      rows: _brewMethods
                          .map((b) => (b.name, b.coefficient))
                          .toList(),
                      palette: p,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '常见饮品的咖啡因含量速查',
              palette: p,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(p.surfaceDark),
                  dataRowMinHeight: 48,
                  horizontalMargin: 16,
                  columnSpacing: 24,
                  columns: [
                    DataColumn(
                      label: Text(
                        '饮品',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: p.onDark,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '容量',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: p.onDark,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text(
                        '咖啡因 (mg)',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: p.onDark,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '备注',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: p.onDark,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                  rows: _drinkItems.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isEven = entry.key % 2 == 0;
                    return DataRow(
                      color: WidgetStateProperty.all(
                        isEven ? p.surfaceCard : p.canvas.withOpacity(0.5),
                      ),
                      cells: [
                        DataCell(
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item.size,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.caffeine}mg',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: p.primary,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item.note,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: p.muted,
                                ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.palette,
    required this.child,
  });

  final String title;
  final Widget child;
  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.hairline.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SimpleTableCard extends StatelessWidget {
  const _SimpleTableCard({
    required this.title,
    required this.header1,
    required this.header2,
    required this.rows,
    required this.palette,
  });

  final String title;
  final String header1;
  final String header2;
  final List<(String, String)> rows;
  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.hairline.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          ...rows.asMap().entries.map((entry) {
            final row = entry.value;
            final isLast = entry.key == rows.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: palette.hairline.withOpacity(0.5),
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    row.$2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: palette.primary,
                        ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
