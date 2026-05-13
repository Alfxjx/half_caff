import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MetabolismPathwayPage extends StatelessWidget {
  const MetabolismPathwayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('咖啡因在体内的代谢途径'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: '代谢流程',
              child: Column(
                children: [
                  _PathwayStep(
                    index: 1,
                    title: '口服摄入',
                    detail: '胃肠道吸收 (30-45分钟达峰)',
                    palette: p,
                  ),
                  _DottedLine(palette: p),
                  _PathwayStep(
                    index: 2,
                    title: '血液循环',
                    detail: '分布于全身 (Vd ≈ 0.7 L/kg)',
                    palette: p,
                  ),
                  _DottedLine(palette: p),
                  _PathwayStep(
                    index: 3,
                    title: '肝脏代谢',
                    detail: 'CYP1A2 酶系去甲基化 (95%)',
                    palette: p,
                  ),
                  _DottedLine(palette: p),
                  _PathwayStep(
                    index: 4,
                    title: '肾脏排泄',
                    detail: '以尿酸形式排出 (3% 原形)',
                    palette: p,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '主要代谢产物 (CYP1A2 催化)',
              child: Column(
                children: [
                  _MetaboliteRow(
                    name: '副黄嘌呤',
                    path: '3-N-去甲基化',
                    ratio: '84%',
                    isFirst: true,
                    palette: p,
                  ),
                  _MetaboliteRow(
                    name: '可可碱',
                    path: '1-N-去甲基化',
                    ratio: '12%',
                    palette: p,
                  ),
                  _MetaboliteRow(
                    name: '茶碱',
                    path: '7-N-去甲基化',
                    ratio: '4%',
                    isLast: true,
                    palette: p,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.hairline.withOpacity(0.6)),
              ),
              child: Text(
                '副黄嘌呤的药理活性与咖啡因相似，但毒性较低。',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: p.muted,
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
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
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

class _PathwayStep extends StatelessWidget {
  const _PathwayStep({
    required this.index,
    required this.title,
    required this.detail,
    required this.palette,
  });

  final int index;
  final String title;
  final String detail;
  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$index',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.body,
                    height: 1.5,
                  ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' → $detail'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DottedLine extends StatelessWidget {
  const _DottedLine({required this.palette});

  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 2,
        height: 24,
        color: palette.hairline,
      ),
    );
  }
}

class _MetaboliteRow extends StatelessWidget {
  const _MetaboliteRow({
    required this.name,
    required this.path,
    required this.ratio,
    required this.palette,
    this.isFirst = false,
    this.isLast = false,
  });

  final String name;
  final String path;
  final String ratio;
  final ClaudePalette palette;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: (!isLast)
              ? BorderSide(color: palette.hairline.withOpacity(0.5))
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ratio,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: palette.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
