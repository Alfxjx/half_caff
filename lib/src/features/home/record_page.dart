import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/intake_record.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
import 'utils/formatters.dart';
import 'widgets/empty_card.dart';
import 'widgets/section_header.dart';

enum RecordHistoryFilter { all, today, week }

class RecordPage extends StatefulWidget {
  const RecordPage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  RecordHistoryFilter _historyFilter = RecordHistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final records = _filteredRecords(widget.controller.records);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: l10n.recordHeadline),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: palette.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.hairline.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    childAspectRatio: 1.1,
                  ),
                  itemCount: widget.controller.availableDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = widget.controller.availableDrinks[index];
                    return _DrinkTile(
                      emoji: drink.emoji,
                      name: localizedDrinkName(l10n, drink.id),
                      caffeine: '${drink.caffeineMg}mg',
                      onTap: () => widget.controller.addDrink(drink, DateTime.now()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _showRecordSheet(context, widget.controller),
                  icon: const Icon(Icons.edit_note_outlined),
                  label: Text(l10n.customRecordButton),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: palette.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.hairline.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.recordFilterLabel, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.recordFilterAll),
                      selected: _historyFilter == RecordHistoryFilter.all,
                      onSelected: (_) => setState(() => _historyFilter = RecordHistoryFilter.all),
                    ),
                    ChoiceChip(
                      label: Text(l10n.recordFilterToday),
                      selected: _historyFilter == RecordHistoryFilter.today,
                      onSelected: (_) => setState(() => _historyFilter = RecordHistoryFilter.today),
                    ),
                    ChoiceChip(
                      label: Text(l10n.recordFilterWeek),
                      selected: _historyFilter == RecordHistoryFilter.week,
                      onSelected: (_) => setState(() => _historyFilter = RecordHistoryFilter.week),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(label: l10n.recordHistoryLabel),
          const SizedBox(height: 16),
          if (records.isEmpty)
            EmptyCard(title: l10n.noRecordsTitle, body: l10n.noRecordsBody)
          else
            ...records.asMap().entries.map((entry) {
              final record = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
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
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${formatDateTime(context, record.consumedAt)} · ${record.caffeineAmountMg}mg',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.muted),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showRecordSheet(context, widget.controller, existingRecord: record),
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: l10n.editRecordTooltip,
                      ),
                      IconButton(
                        onPressed: () => _confirmDeleteRecord(context, record),
                        icon: Icon(Icons.delete_outline, size: 20, color: palette.error),
                        tooltip: l10n.deleteRecordTooltip,
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  List<IntakeRecord> _filteredRecords(List<IntakeRecord> records) {
    final now = DateTime.now();
    switch (_historyFilter) {
      case RecordHistoryFilter.all:
        return records;
      case RecordHistoryFilter.today:
        return records.where((r) => r.consumedAt.year == now.year && r.consumedAt.month == now.month && r.consumedAt.day == now.day).toList();
      case RecordHistoryFilter.week:
        final cutoff = now.subtract(const Duration(days: 7));
        return records.where((r) => !r.consumedAt.isBefore(cutoff)).toList();
    }
  }

  Future<void> _confirmDeleteRecord(BuildContext context, IntakeRecord record) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteRecordTitle),
        content: Text(l10n.deleteRecordBody(displayNameForRecord(l10n, record))),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancelLabel)),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(foregroundColor: context.palette.error),
            child: Text(l10n.confirmDeleteLabel),
          ),
        ],
      ),
    );
    if (confirmed == true) await widget.controller.removeRecord(record.id);
  }

  Future<void> _showRecordSheet(
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
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? l10n.editRecordTitle : l10n.addCustomRecordTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(controller: nameController, decoration: InputDecoration(labelText: l10n.customNameLabel)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.caffeineAmountLabel),
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
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
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
                          consumedAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancelLabel)),
                        const Spacer(),
                        FilledButton(
                          onPressed: () async {
                            final name = nameController.text.trim();
                            final amount = int.tryParse(amountController.text.trim());
                            if (name.isEmpty || amount == null || amount <= 0) return;
                            if (existingRecord == null) {
                              await controller.addCustomRecord(name: name, caffeineAmountMg: amount, consumedAt: consumedAt);
                            } else {
                              final canonicalName = existingRecord.sourceDrinkId == null
                                  ? null
                                  : localizedDrinkName(l10n, existingRecord.sourceDrinkId!);
                              final shouldClearCustomName = canonicalName != null && name == canonicalName;
                              await controller.updateRecord(existingRecord.copyWith(
                                consumedAt: consumedAt,
                                caffeineAmountMg: amount,
                                customName: shouldClearCustomName ? null : name,
                                clearCustomName: shouldClearCustomName,
                              ));
                            }
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          },
                          child: Text(isEditing ? l10n.updateLabel : l10n.saveLabel),
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
}

class _DrinkTile extends StatelessWidget {
  const _DrinkTile({
    required this.emoji,
    required this.name,
    required this.caffeine,
    required this.onTap,
  });

  final String emoji;
  final String name;
  final String caffeine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
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
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: palette.hairline.withOpacity(0.5)),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
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
