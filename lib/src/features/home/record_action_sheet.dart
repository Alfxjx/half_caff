import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/drink_item.dart';
import '../../state/caffeine_journal_controller.dart';
import 'record_editor_sheet.dart';
import 'utils/formatters.dart';

Future<void> showRecordActionSheet(
  BuildContext context,
  CaffeineJournalController controller,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return _RecordActionSheetContent(controller: controller);
    },
  );
}

class _RecordActionSheetContent extends StatefulWidget {
  const _RecordActionSheetContent({required this.controller});

  final CaffeineJournalController controller;

  @override
  State<_RecordActionSheetContent> createState() => _RecordActionSheetState();
}

class _RecordActionSheetState extends State<_RecordActionSheetContent> {
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  List<DrinkItem> _rankedDrinks() {
    final freq = <String, int>{};
    for (final r in widget.controller.records) {
      if (r.sourceDrinkId != null) {
        freq[r.sourceDrinkId!] = (freq[r.sourceDrinkId!] ?? 0) + 1;
      }
    }
    final drinks = List<DrinkItem>.from(widget.controller.availableDrinks);
    drinks.sort((a, b) {
      final countA = freq[a.id] ?? 0;
      final countB = freq[b.id] ?? 0;
      if (countA != countB) return countB.compareTo(countA);
      return 0;
    });
    return drinks;
  }

  Future<void> _showTempEditSheet(
      BuildContext context, DrinkItem drink) async {
    final l10n = AppLocalizations.of(context)!;
    final defaultName = displayNameForDrink(l10n, drink);
    final caffeineController =
        TextEditingController(text: drink.caffeineMg.toString());
    final volumeController =
        TextEditingController(text: drink.volumeMl.toString());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16, 0, 16, 20 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  defaultName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: caffeineController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: l10n.caffeineAmountLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: volumeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.volumeLabel),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancelLabel),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () async {
                        final caffeine =
                            int.tryParse(caffeineController.text.trim());
                        final volume =
                            int.tryParse(volumeController.text.trim());
                        if (caffeine == null || caffeine <= 0) return;
                        final modified = drink.copyWith(
                          caffeineMg: caffeine,
                          volumeMl: volume ?? drink.volumeMl,
                        );
                        await widget.controller
                            .addDrink(modified, DateTime.now());
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.saveLabel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    caffeineController.dispose();
    volumeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final allDrinks = _rankedDrinks();
    final displayDrinks = _showAll ? allDrinks : allDrinks.take(5).toList();
    final canExpand = allDrinks.length > 5;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.recordHeadline,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showRecordEditorSheet(context, widget.controller);
                    },
                    icon: const Icon(Icons.edit_note_outlined, size: 18),
                    label: Text(l10n.customRecordButton),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: palette.paperAlt.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.hairline.withOpacity(0.6)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < displayDrinks.length; i++) ...[
                        _DrinkListTile(
                          emoji: displayDrinks[i].emoji,
                          name: displayNameForDrink(l10n, displayDrinks[i]),
                          caffeine: '${displayDrinks[i].caffeineMg}mg',
                          volume: '${displayDrinks[i].volumeMl}ml',
                          onTap: () {
                            widget.controller
                                .addDrink(displayDrinks[i], DateTime.now());
                            Navigator.of(context).pop();
                          },
                          onLongPress: () =>
                              _showTempEditSheet(context, displayDrinks[i]),
                        ),
                        if (i < displayDrinks.length - 1)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: palette.hairline.withOpacity(0.5),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              if (canExpand) ...[
                const SizedBox(height: 4),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    child: Text(
                      _showAll ? '收起' : '展开全部',
                      style: TextStyle(color: palette.primary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DrinkListTile extends StatelessWidget {
  const _DrinkListTile({
    required this.emoji,
    required this.name,
    required this.caffeine,
    required this.volume,
    required this.onTap,
    this.onLongPress,
  });

  final String emoji;
  final String name;
  final String caffeine;
  final String volume;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.surfaceCard,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: palette.hairline.withOpacity(0.5)),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  caffeine,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
                Text(
                  volume,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
