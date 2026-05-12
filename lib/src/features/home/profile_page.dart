import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/caffeine_profile.dart';
import '../../services/caffeine_calculator.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';
import 'utils/formatters.dart';
import 'widgets/section_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = controller.profile;
    final halfLife = CaffeineCalculator.calculateHalfLife(profile);
    final palette = context.palette;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: l10n.profileHeadline),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: palette.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.halfLifeLabel,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: palette.muted,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${halfLife.toStringAsFixed(1)} h',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.3,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(l10n.metabolismPresetLabel, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                SegmentedButton<MetabolismPreset>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: MetabolismPreset.fast, label: Text(l10n.presetFast)),
                    ButtonSegment(value: MetabolismPreset.normal, label: Text(l10n.presetNormal)),
                    ButtonSegment(value: MetabolismPreset.slow, label: Text(l10n.presetSlow)),
                    ButtonSegment(value: MetabolismPreset.unknown, label: Text(l10n.presetUnknown)),
                  ],
                  selected: {profile.metabolismPreset},
                  onSelectionChanged: (selection) {
                    controller.updateProfile(profile.copyWith(metabolismPreset: selection.first));
                  },
                ),
                const SizedBox(height: 20),
                _ProfileSwitch(title: l10n.smokerLabel, value: profile.isSmoker, onChanged: (v) => controller.updateProfile(profile.copyWith(isSmoker: v))),
                _ProfileSwitch(title: l10n.oralContraceptivesLabel, value: profile.usesOralContraceptives, onChanged: (v) => controller.updateProfile(profile.copyWith(usesOralContraceptives: v))),
                _ProfileSwitch(title: l10n.pregnantLabel, value: profile.isPregnant, onChanged: (v) => controller.updateProfile(profile.copyWith(isPregnant: v))),
                _ProfileSwitch(title: l10n.drinksAlcoholLabel, value: profile.drinksAlcohol, onChanged: (v) => controller.updateProfile(profile.copyWith(drinksAlcohol: v))),
                const SizedBox(height: 12),
                DropdownButtonFormField<LiverStatus>(
                  value: profile.liverStatus,
                  decoration: InputDecoration(labelText: l10n.liverStatusLabel),
                  items: LiverStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(localizedLiverStatus(l10n, s)))).toList(),
                  onChanged: (v) {
                    if (v != null) controller.updateProfile(profile.copyWith(liverStatus: v));
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Cyp1a2Genotype>(
                  value: profile.genotype,
                  decoration: InputDecoration(labelText: l10n.genotypeLabel),
                  items: Cyp1a2Genotype.values.map((v) => DropdownMenuItem(value: v, child: Text(localizedGenotype(l10n, v)))).toList(),
                  onChanged: (v) {
                    if (v != null) controller.updateProfile(profile.copyWith(genotype: v));
                  },
                ),
                const SizedBox(height: 20),
                Text('${l10n.ageLabel}: ${profile.age}', style: Theme.of(context).textTheme.bodyMedium),
                Slider(
                  min: 18,
                  max: 80,
                  divisions: 62,
                  value: profile.age.toDouble(),
                  onChanged: (v) => controller.updateProfile(profile.copyWith(age: v.round())),
                ),
                Text('${l10n.dailyBudgetLabel}: ${profile.dailyBudgetMg}mg', style: Theme.of(context).textTheme.bodyMedium),
                Slider(
                  min: 100,
                  max: 500,
                  divisions: 8,
                  value: profile.dailyBudgetMg.toDouble(),
                  onChanged: (v) => controller.updateProfile(profile.copyWith(dailyBudgetMg: v.round())),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bedtime_outlined),
                  title: Text(l10n.sleepTargetLabel),
                  subtitle: Text(formatMinutesAsTime(context, profile.targetSleepMinutes)),
                  onTap: () async {
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: profile.targetSleepMinutes ~/ 60, minute: profile.targetSleepMinutes % 60),
                    );
                    if (selected != null) {
                      controller.updateProfile(profile.copyWith(targetSleepMinutes: selected.hour * 60 + selected.minute));
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(label: l10n.dataManagementLabel),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: palette.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.hairline.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () => controller.loadDemoData(),
                  icon: const Icon(Icons.auto_fix_high_outlined),
                  label: Text(l10n.loadDemoDataButton),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    await controller.exportToClipboard();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.exportSuccessMessage)));
                  },
                  icon: const Icon(Icons.upload_outlined),
                  label: Text(l10n.exportDataButton),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final ok = await controller.importFromClipboard();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ok ? l10n.importSuccessMessage : l10n.importFailureMessage)),
                    );
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l10n.importDataButton),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _confirmClearData(context, controller),
                  icon: Icon(Icons.delete_forever_outlined, color: palette.error),
                  label: Text(l10n.clearAllDataButton, style: TextStyle(color: palette.error)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearData(BuildContext context, CaffeineJournalController controller) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearDataConfirmTitle),
        content: Text(l10n.clearDataConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancelLabel)),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(foregroundColor: context.palette.error),
            child: Text(l10n.clearDataConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.clearAllData();
  }
}

class _ProfileSwitch extends StatelessWidget {
  const _ProfileSwitch({required this.title, required this.value, required this.onChanged});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
