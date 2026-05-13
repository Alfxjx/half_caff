import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/drink_item.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
import '../home/utils/formatters.dart';

class DrinkPresetManagerPage extends StatefulWidget {
  const DrinkPresetManagerPage({
    super.key,
    required this.controller,
    this.initialCategory,
  });

  final CaffeineJournalController controller;
  final DrinkCategory? initialCategory;

  @override
  State<DrinkPresetManagerPage> createState() => _DrinkPresetManagerPageState();
}

class _DrinkPresetManagerPageState extends State<DrinkPresetManagerPage> {
  DrinkCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
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

  List<DrinkItem> get _filteredDrinks {
    final drinks = widget.controller.availableDrinks;
    if (_selectedCategory == null) return drinks;
    return drinks.where((d) => d.category == _selectedCategory).toList();
  }

  String _categoryLabel(AppLocalizations l10n, DrinkCategory category) {
    switch (category) {
      case DrinkCategory.coffee:
        return l10n.coffeeCategory;
      case DrinkCategory.tea:
        return l10n.teaCategory;
      case DrinkCategory.soda:
        return l10n.sodaCategory;
      case DrinkCategory.energy:
        return l10n.energyCategory;
      case DrinkCategory.supplement:
        return l10n.supplementCategory;
      case DrinkCategory.food:
        return l10n.foodCategory;
    }
  }

  Future<void> _showEditSheet(BuildContext context, DrinkItem drink) async {
    final l10n = AppLocalizations.of(context)!;
    final defaultDrink = CaffeineJournalController.defaultDrinks.firstWhere(
      (d) => d.id == drink.id,
      orElse: () => drink,
    );
    final defaultName = displayNameForDrink(l10n, defaultDrink);
    final nameController = TextEditingController(
      text: drink.customName ?? displayNameForDrink(l10n, drink),
    );
    final amountController = TextEditingController(text: drink.caffeineMg.toString());
    final volumeController = TextEditingController(text: drink.volumeMl.toString());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20 + MediaQuery.of(context).viewInsets.bottom,
            ),
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
                    if (widget.controller.isPresetModified(drink.id))
                      TextButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(l10n.resetPresetConfirmTitle),
                              content: Text(l10n.resetPresetConfirmBody),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(false),
                                  child: Text(l10n.cancelLabel),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: context.palette.error,
                                    foregroundColor: context.palette.onPrimary,
                                  ),
                                  child: Text(l10n.resetLabel),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          await widget.controller.resetDrinkPreset(drink.id);
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: Text(l10n.resetLabel),
                      ),
                    FilledButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final amount = int.tryParse(amountController.text.trim());
                        final volume = int.tryParse(volumeController.text.trim());
                        if (name.isEmpty || amount == null || amount <= 0 || volume == null || volume <= 0) {
                          return;
                        }
                        final shouldClearCustomName = name == defaultName;
                        await widget.controller.updateDrinkPreset(
                          drink.copyWith(
                            caffeineMg: amount,
                            volumeMl: volume,
                            customName: shouldClearCustomName ? null : name,
                            clearCustomName: shouldClearCustomName,
                          ),
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
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
    volumeController.dispose();
  }

  Future<void> _showResetAllConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.resetPresetConfirmTitle),
        content: Text(l10n.resetPresetConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.palette.error,
              foregroundColor: context.palette.onPrimary,
            ),
            child: Text(l10n.resetAllPresetsButton),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.controller.resetAllDrinkPresets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    const categories = DrinkCategory.values;
    final drinks = _filteredDrinks;
    final hasAnyPresets = widget.controller.hasAnyPresets;

    return Scaffold(
      backgroundColor: palette.canvas,
      appBar: AppBar(
        title: Text(l10n.manageDrinksLabel),
        actions: [
          if (hasAnyPresets)
            TextButton(
              onPressed: () => _showResetAllConfirmation(context),
              child: Text(l10n.resetAllPresetsButton),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<DrinkCategory?>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<DrinkCategory?>(
                    value: null,
                    label: Text(l10n.recordFilterAll),
                  ),
                  ...categories.map(
                    (c) => ButtonSegment<DrinkCategory?>(
                      value: c,
                      label: Text(_categoryLabel(l10n, c)),
                    ),
                  ),
                ],
                selected: {_selectedCategory},
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedCategory = selection.first;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: drinks.length,
              itemBuilder: (context, index) {
                final drink = drinks[index];
                final isModified = widget.controller.isPresetModified(drink.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: palette.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isModified
                          ? palette.primary.withOpacity(0.5)
                          : palette.hairline.withOpacity(0.6),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: palette.surfaceCreamStrong,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(drink.emoji, style: const TextStyle(fontSize: 18)),
                    ),
                    title: Text(
                      displayNameForDrink(l10n, drink),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Text(
                      '${drink.caffeineMg}mg · ${drink.volumeMl}ml',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: palette.primary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isModified)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: palette.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(Icons.edit_outlined, size: 18, color: palette.muted),
                      ],
                    ),
                    onTap: () => _showEditSheet(context, drink),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
