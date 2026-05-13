import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FormulaPage extends StatelessWidget {
  const FormulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('核心计算公式推导'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FormulaCard(
              index: 1,
              title: '单次摄入 N 小时后体内咖啡因剩余量（最简版）',
              formula: _Formula1(palette: p),
              params: const [
                ('A(N)', 'N 时刻体内咖啡因量 (mg)'),
                ('X', 'T=0 摄入的咖啡因量 (mg)'),
                ('N', '经过的时间 (小时)'),
                ('t₁/₂', '个体消除半衰期 (小时)'),
              ],
              palette: p,
            ),
            const SizedBox(height: 16),
            _FormulaCard(
              index: 2,
              title: '多次摄入的叠加计算',
              formula: _Formula2(palette: p),
              note: 'Xi = 第 i 次摄入的剂量，Ti = 第 i 次摄入的时间（仅当 N > Ti 时计入）',
              palette: p,
            ),
            const SizedBox(height: 16),
            _FormulaCard(
              index: 3,
              title: '含吸收相的血浆浓度（完整版一室模型）',
              formula: _Formula3(palette: p),
              params: const [
                ('F', '生物利用度 ≈1.0'),
                ('ka', '吸收速率 ≈3.5 h⁻¹'),
                ('ke', '消除速率 =0.693/t₁/₂'),
                ('Vd', '分布容积 =0.7×体重'),
                ('X', '摄入剂量 (mg)'),
                ('C(N)', '血浆浓度 (mg/L)'),
              ],
              palette: p,
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({
    required this.index,
    required this.title,
    required this.formula,
    required this.palette,
    this.params,
    this.note,
  });

  final int index;
  final String title;
  final Widget formula;
  final ClaudePalette palette;
  final List<(String, String)>? params;
  final String? note;

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '公式 $index',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: palette.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: palette.canvas.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: formula,
          ),
          if (params != null) ...[
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossCount = constraints.maxWidth > 480 ? 4 : 2;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossCount,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.8,
                  children: params!.map((param) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: palette.canvas.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            param.$1,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: palette.primary,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            param.$2,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: palette.muted,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
          if (note != null) ...[
            const SizedBox(height: 12),
            Text(
              note!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Formula1 extends StatelessWidget {
  const _Formula1({required this.palette});

  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'serif',
              color: palette.ink,
            ),
        children: const [
          TextSpan(text: 'A(N) = X × ('),
          TextSpan(
            text: '1',
            style: TextStyle(fontSize: 18),
          ),
          TextSpan(text: ' / '),
          TextSpan(
            text: '2',
            style: TextStyle(fontSize: 18),
          ),
          TextSpan(text: ')'),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: SizedBox.shrink(),
          ),
          TextSpan(
            text: 'N / t₁/₂',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _Formula2 extends StatelessWidget {
  const _Formula2({required this.palette});

  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'serif',
              color: palette.ink,
            ),
        children: const [
          TextSpan(text: 'A'),
          TextSpan(
            text: 'total',
            style: TextStyle(fontSize: 14),
          ),
          TextSpan(text: '(N) = Σ  X'),
          TextSpan(
            text: 'i',
            style: TextStyle(fontSize: 14),
          ),
          TextSpan(text: ' × ('),
          TextSpan(
            text: '1',
            style: TextStyle(fontSize: 18),
          ),
          TextSpan(text: ' / '),
          TextSpan(
            text: '2',
            style: TextStyle(fontSize: 18),
          ),
          TextSpan(text: ')'),
          TextSpan(
            text: '(N-Ti) / t₁/₂',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _Formula3 extends StatelessWidget {
  const _Formula3({required this.palette});

  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'serif',
              color: palette.ink,
            ),
        children: const [
          TextSpan(text: 'C(N) = '),
          TextSpan(
            text: 'F · X · ka',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(text: ' / '),
          TextSpan(
            text: 'Vd · (ka - ke)',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(text: ' × (e'),
          TextSpan(
            text: '-ke·N',
            style: TextStyle(fontSize: 12),
          ),
          TextSpan(text: ' - e'),
          TextSpan(
            text: '-ka·N',
            style: TextStyle(fontSize: 12),
          ),
          TextSpan(text: ')'),
        ],
      ),
    );
  }
}
