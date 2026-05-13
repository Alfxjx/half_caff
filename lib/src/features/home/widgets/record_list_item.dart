import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/intake_record.dart';
import '../../../theme/app_theme.dart';
import '../utils/formatters.dart';

class RecordListItem extends StatelessWidget {
  const RecordListItem({
    super.key,
    required this.record,
    required this.index,
    required this.l10n,
  });

  final IntakeRecord record;
  final int index;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.hairline.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.surfaceCreamStrong,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(record.emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayNameForRecord(l10n, record),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRelativeRecordTime(context, record.consumedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                      ),
                ),
              ],
            ),
          ),
          Text(
            '+${record.caffeineAmountMg}mg',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
