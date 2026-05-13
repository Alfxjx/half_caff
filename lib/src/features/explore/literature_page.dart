import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class _Paper {
  const _Paper({
    required this.authors,
    required this.year,
    required this.title,
    required this.journal,
    required this.cites,
  });

  final String authors;
  final String year;
  final String title;
  final String journal;
  final int cites;
}

const _literature = [
  _Paper(
    authors: 'Alsabri et al.',
    year: '2018',
    title: 'Kinetic and dynamic description of caffeine',
    journal: 'J Caffeine Adenosine Res',
    cites: 94,
  ),
  _Paper(
    authors: 'Matthaei et al.',
    year: '2016',
    title: 'Heritability of caffeine metabolism: CYP1A2 activity',
    journal: 'Clin Pharmacol Ther',
    cites: 42,
  ),
  _Paper(
    authors: 'Günes & Dahl',
    year: '2008',
    title: 'Variation in CYP1A2 activity and clinical implications',
    journal: 'Pharmacogenomics',
    cites: 335,
  ),
  _Paper(
    authors: 'Carrillo & Benitez',
    year: '2000',
    title: 'Clinically significant pharmacokinetic interactions of caffeine',
    journal: 'Clin Pharmacokinet',
    cites: 593,
  ),
  _Paper(
    authors: 'Rétey et al.',
    year: '2007',
    title: 'ADORA2A variation and sensitivity to caffeine effects on sleep',
    journal: 'Clin Pharmacol Ther',
    cites: 375,
  ),
  _Paper(
    authors: 'Childs et al.',
    year: '2008',
    title: 'ADORA2A and DRD2 polymorphisms and caffeine-induced anxiety',
    journal: 'Neuropsychopharmacology',
    cites: 349,
  ),
  _Paper(
    authors: 'Patwardhan et al.',
    year: '1980',
    title: 'Impaired elimination of caffeine by oral contraceptive steroids',
    journal: 'J Lab Clin Med',
    cites: 257,
  ),
  _Paper(
    authors: 'Csajka et al.',
    year: '2005',
    title: 'Mechanistic PK modelling of caffeine in healthy subjects',
    journal: 'Br J Clin Pharmacol',
    cites: 46,
  ),
  _Paper(
    authors: 'Newton et al.',
    year: '1981',
    title: 'Plasma and salivary pharmacokinetics of caffeine',
    journal: 'Eur J Clin Pharmacol',
    cites: 296,
  ),
  _Paper(
    authors: 'Barreto et al.',
    year: '2021',
    title: 'CYP1A2 genotype, physiological responses and exercise',
    journal: 'Eur J Appl Physiol',
    cites: 87,
  ),
];

class LiteraturePage extends StatelessWidget {
  const LiteraturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      appBar: AppBar(
        title: const Text('关键参考文献'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: p.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: p.hairline.withOpacity(0.6)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 480;
              final spacing = isWide ? 12.0 : 0.0;
              return Wrap(
                spacing: spacing,
                runSpacing: 12,
                children: _literature.asMap().entries.map((entry) {
                  final paper = entry.value;
                  return SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - spacing) / 2
                        : constraints.maxWidth,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: p.canvas.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            paper.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${paper.authors} (${paper.year}) · ${paper.journal} · 被引${paper.cites}次',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: p.muted,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
