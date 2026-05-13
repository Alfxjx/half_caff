import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class _Factor {
  const _Factor({
    required this.title,
    required this.body,
    required this.colorValue,
  });

  final String title;
  final String body;
  final int colorValue;
}

const _factors = [
  _Factor(
    title: '1. 遗传因素 (最重要，解释32-50%变异)',
    body:
        'CYP1A2 基因多态性 (rs762551) 决定代谢速度。AA型代谢最快，CC型最慢，AC型居中。遗传率 h² = 0.725 (Matthaei et al., 2016)。同卵双胞胎代谢动力学高度一致。',
    colorValue: 0xFFE57373,
  ),
  _Factor(
    title: '2. 吸烟 (t₁/₂ × 0.6)',
    body:
        '尼古丁诱导 CYP1A2 酶活性，使代谢速度加快约50-60%。戒烟后代谢恢复正常，此时不改变咖啡因摄入量会导致体内咖啡因水平升高。',
    colorValue: 0xFFFFB74D,
  ),
  _Factor(
    title: '3. 口服避孕药 (t₁/₂ × 2.0)',
    body:
        '雌激素竞争性抑制 CYP1A2，使半衰期几乎翻倍 (Patwardhan et al., 1980)。停药后代谢能力恢复。',
    colorValue: 0xFFFFF176,
  ),
  _Factor(
    title: '4. 妊娠晚期 (t₁/₂ × 3.0)',
    body:
        '孕酮水平升高抑制 CYP1A2 活性，半衰期可达 15-18 小时。建议孕妇每日咖啡因摄入不超过 200mg (EFSA 建议)。',
    colorValue: 0xFFF06292,
  ),
  _Factor(
    title: '5. 肝功能状态 (t₁/₂ × 2~4)',
    body:
        '咖啡因几乎完全依赖肝脏代谢。肝硬化/肝炎患者清除率可降至正常的 1/4。咖啡因代谢测试实际上被用作肝功能评估工具 (Renner et al., 1984)。',
    colorValue: 0xFFBA68C8,
  ),
  _Factor(
    title: '6. 年龄 (老年人 t₁/₂ × 1.3)',
    body:
        '新生儿半衰期可达 30-100 小时（肝酶未发育），6个月后接近成人。老年人肝酶活性下降，代谢速度降低约30%。',
    colorValue: 0xFF64B5F6,
  ),
  _Factor(
    title: '7. 饮酒 (t₁/₂ × 1.4)',
    body:
        '酒精抑制 CYP1A2 活性。研究显示每日 50g 酒精可使咖啡因半衰期延长 72%，清除率降低 36%。',
    colorValue: 0xFF7986CB,
  ),
  _Factor(
    title: '8. 药物相互作用',
    body:
        '氟伏沙明 (SSRI) 可显著抑制代谢，半衰期延至 12h+；西咪替丁、环丙沙星减慢代谢；部分抗癫痫药可能加速代谢。',
    colorValue: 0xFF81C784,
  ),
];

class FactorsPage extends StatelessWidget {
  const FactorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('影响代谢速度的关键因素'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 480;
            final cardWidth = isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _factors.map((factor) {
                return SizedBox(
                  width: cardWidth,
                  child: _FactorCard(factor: factor, palette: p),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({required this.factor, required this.palette});

  final _Factor factor;
  final ClaudePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: Color(factor.colorValue), width: 4),
          top: BorderSide(color: palette.hairline.withOpacity(0.6)),
          right: BorderSide(color: palette.hairline.withOpacity(0.6)),
          bottom: BorderSide(color: palette.hairline.withOpacity(0.6)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            factor.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            factor.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.body,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
