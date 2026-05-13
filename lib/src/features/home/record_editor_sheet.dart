import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/intake_record.dart';
import '../../state/caffeine_journal_controller.dart';
import 'utils/formatters.dart';

Future<void> showRecordEditorSheet(
  BuildContext context,
  CaffeineJournalController controller, {
  IntakeRecord? existingRecord,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final isEditing = existingRecord != null;
  final nameController = TextEditingController(
    text: isEditing ? displayNameForRecord(l10n, existingRecord) : '',
  );
  final amountController = TextEditingController(
    text: isEditing ? existingRecord.caffeineAmountMg.toString() : '',
  );
  var consumedAt = existingRecord?.consumedAt ?? DateTime.now();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing
                        ? l10n.editRecordTitle
                        : l10n.addCustomRecordTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                      controller: nameController,
                      decoration:
                          InputDecoration(labelText: l10n.customNameLabel)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: l10n.caffeineAmountLabel),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.schedule_outlined),
                    title: Text(l10n.consumedAtLabel),
                    subtitle: Text(formatDateTime(context, consumedAt)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now().add(const Duration(days: 1)),
                        initialDate: consumedAt,
                      );
                      if (date == null || !context.mounted) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(consumedAt),
                      );
                      if (time == null) return;
                      setModalState(() {
                        consumedAt = DateTime(date.year, date.month, date.day,
                            time.hour, time.minute);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancelLabel)),
                      const Spacer(),
                      FilledButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final amount =
                              int.tryParse(amountController.text.trim());
                          if (name.isEmpty || amount == null || amount <= 0)
                            return;
                          if (existingRecord == null) {
                            await controller.addCustomRecord(
                                name: name,
                                caffeineAmountMg: amount,
                                consumedAt: consumedAt);
                          } else {
                            final canonicalName =
                                existingRecord.sourceDrinkId == null
                                    ? null
                                    : localizedDrinkName(
                                        l10n, existingRecord.sourceDrinkId!);
                            final shouldClearCustomName =
                                canonicalName != null && name == canonicalName;
                            await controller
                                .updateRecord(existingRecord.copyWith(
                              consumedAt: consumedAt,
                              caffeineAmountMg: amount,
                              customName: shouldClearCustomName ? null : name,
                              clearCustomName: shouldClearCustomName,
                            ));
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child:
                            Text(isEditing ? l10n.updateLabel : l10n.saveLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  nameController.dispose();
  amountController.dispose();
}

Future<void> showDeleteConfirmation(
  BuildContext context,
  CaffeineJournalController controller,
  IntakeRecord record,
) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteRecordTitle),
      content: Text(l10n.deleteRecordBody(displayNameForRecord(l10n, record))),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelLabel)),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: context.palette.error,
            foregroundColor: context.palette.onPrimary,
          ),
          child: Text(l10n.confirmDeleteLabel),
        ),
      ],
    ),
  );
  if (confirmed == true) await controller.removeRecord(record.id);
}
