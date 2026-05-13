import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/drink_item.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
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

  Future<void> _showPresetEditSheet(BuildContext context, DrinkItem drink) async {
    final l10n = AppLocalizations.of(context)!;
    final defaultName = displayNameForDrink(l10n, drink);
    final nameController = TextEditingController(text: defaultName);
    final amountController = TextEditingController(text: drink.caffeineMg.toString());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.editRecordTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.customNameLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.caffeineAmountLabel),
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
                        final name = nameController.text.trim();
                        final amount = int.tryParse(amountController.text.trim());
                        if (name.isEmpty || amount == null || amount <= 0) return;
                        final shouldClearCustomName = name == defaultName;
                        await widget.controller.updateDrinkPreset(
                          drink.copyWith(
                            caffeineMg: amount,
                            customName: shouldClearCustomName ? null : name,
                            clearCustomName: shouldClearCustomName,
                          ),
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.presetUpdatedMessage)),
                        );
                      },
                      child: Text(l10n.updateLabel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    nameController.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.recordHeadline,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.quickAddLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 420 ? 4 : 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width > 420 ? 0.85 : 1.1,
              ),
              itemCount: widget.controller.availableDrinks.length,
              itemBuilder: (context, index) {
                final drink = widget.controller.availableDrinks[index];
                return _DrinkTile(
                  emoji: drink.emoji,
                  name: displayNameForDrink(l10n, drink),
                  caffeine: '${drink.caffeineMg}mg',
                  onTap: () {
                    widget.controller.addDrink(drink, DateTime.now());
                    Navigator.of(context).pop();
                  },
                  onLongPress: () => _showPresetEditSheet(context, drink),
                );
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                showRecordEditorSheet(context, widget.controller);
              },
              icon: const Icon(Icons.edit_note_outlined),
              label: Text(l10n.customRecordButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrinkTile extends StatelessWidget {
  const _DrinkTile({
    required this.emoji,
    required this.name,
    required this.caffeine,
    required this.onTap,
    this.onLongPress,
  });

  final String emoji;
  final String name;
  final String caffeine;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.paperAlt.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.hairline.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: palette.hairline.withOpacity(0.5)),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
            const Spacer(),
            Text(
              name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              caffeine,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
