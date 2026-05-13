import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.hairline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.surfaceCreamStrong,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.science_outlined, color: palette.muted, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
