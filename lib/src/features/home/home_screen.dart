import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/app_controller.dart';
import '../../models/caffeine_profile.dart';
import '../../models/intake_record.dart';
import '../../services/caffeine_calculator.dart';
import '../../state/caffeine_journal_controller.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.appController,
    required this.journalController,
  });

  final AppController appController;
  final CaffeineJournalController journalController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appController, journalController]),
      builder: (context, child) {
        final l10n = AppLocalizations.of(context)!;
        final noteDate =
            MaterialLocalizations.of(context).formatCompactDate(DateTime.now());
        final pages = [
          DashboardPage(controller: journalController),
          TimelinePage(controller: journalController),
          RecordPage(controller: journalController),
          ExplorePage(controller: journalController),
          ProfilePage(controller: journalController),
        ];

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: AppBar(
            toolbarHeight: 88,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.palette.paper.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: context.palette.border.withOpacity(0.7)),
                  ),
                  child: Text(
                    noteDate,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.palette.inkMuted,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.appTitle),
                Text(
                  _titleForIndex(l10n, journalController.selectedTab),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.inkMuted,
                        letterSpacing: 0.6,
                      ),
                ),
              ],
            ),
            actions: [
              IconButton.filledTonal(
                onPressed: () => _openSettingsSheet(context, l10n),
                icon: const Icon(Icons.tune_rounded),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.palette.backgroundAccent,
                  context.palette.background,
                ],
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: LabWorkbenchBackground()),
                SafeArea(
                  top: false,
                  child: IndexedStack(
                    index: journalController.selectedTab,
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    context.palette.paper.withOpacity(0.94),
                    context.palette.paperAlt.withOpacity(0.82),
                  ],
                ),
                border:
                    Border.all(color: context.palette.border.withOpacity(0.72)),
                boxShadow: [
                  BoxShadow(
                    color: context.palette.shadow.withOpacity(0.6),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: journalController.selectedTab,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: journalController.selectTab,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home_rounded),
                    label: l10n.dashboardTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.show_chart_rounded),
                    label: l10n.timelineTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.science_outlined),
                    selectedIcon: const Icon(Icons.science_rounded),
                    label: l10n.recordTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.auto_stories_outlined),
                    selectedIcon: const Icon(Icons.auto_stories_rounded),
                    label: l10n.exploreTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.tune_outlined),
                    selectedIcon: const Icon(Icons.tune_rounded),
                    label: l10n.profileTab,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _titleForIndex(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.dashboardHeadline;
      case 1:
        return l10n.timelineHeadline;
      case 2:
        return l10n.recordHeadline;
      case 3:
        return l10n.exploreHeadline;
      case 4:
        return l10n.profileHeadline;
      default:
        return l10n.appTitle;
    }
  }

  Future<void> _openSettingsSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsTitle,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.themeModeLabel,
                  style: Theme.of(sheetContext).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(l10n.themeSystem),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(l10n.themeLight),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(l10n.themeDark),
                    ),
                  ],
                  selected: {appController.themeMode},
                  onSelectionChanged: (selection) {
                    appController.setThemeMode(selection.first);
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.languageLabel,
                  style: Theme.of(sheetContext).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: appController.localeTag,
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(l10n.languageSystem),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(l10n.languageEnglish),
                    ),
                    DropdownMenuItem(
                      value: 'zh',
                      child: Text(l10n.languageSimplifiedChinese),
                    ),
                    DropdownMenuItem(
                      value: 'zh-Hant',
                      child: Text(l10n.languageTraditionalChinese),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      appController.setLocaleTag(value);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final insights = CaffeineCalculator.buildInsights(
      controller.records,
      controller.profile,
      now,
    );
    final palette = context.palette;
    final progress = (insights.currentAmountMg / 220).clamp(0.0, 1.0);
    final recentRecords = controller.records.take(5).toList(growable: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            title: l10n.dashboardHeadline,
            subtitle: l10n.dashboardSubtitle,
          ),
          const SizedBox(height: 16),
          LabCard(
            sampleNumber: '001',
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.labEstimate,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: palette.inkMuted,
                                  letterSpacing: 0.8,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${insights.currentAmountMg.toStringAsFixed(0)} mg',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: palette.ink,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _riskTint(insights.risk, palette),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              _riskMessage(
                                  context, insights.risk, insights.lowRiskTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: palette.ink,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 132,
                      height: 132,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor:
                                  palette.paperAlt.withOpacity(0.55),
                              color: palette.coffee,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                insights.currentAmountMg.toStringAsFixed(0),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              Text(
                                'mg',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: palette.inkMuted,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    MetricNote(
                      label: l10n.dailyBudgetUsedLabel,
                      value: '${insights.dailyTotalMg} mg',
                    ),
                    MetricNote(
                      label: l10n.halfLifeLabel,
                      value: '${insights.halfLifeHours.toStringAsFixed(1)} h',
                    ),
                    MetricNote(
                      label: l10n.budgetRemainingLabel,
                      value: '${insights.budgetRemainingMg} mg',
                    ),
                    MetricNote(
                      label: l10n.projectedAtSleepLabel,
                      value:
                          '${insights.projectedAtSleepMg.toStringAsFixed(0)} mg',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionLabel(text: l10n.recentSamplesLabel),
          const SizedBox(height: 10),
          if (recentRecords.isEmpty)
            LabCard(
              sampleNumber: '002',
              child: EmptyState(
                title: l10n.noRecordsTitle,
                body: l10n.noRecordsBody,
              ),
            )
          else
            Column(
              children: recentRecords
                  .map(
                    (record) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LabCard(
                        sampleNumber:
                            _sampleNumberForRecord(record, recentRecords),
                        compact: true,
                        child: Row(
                          children: [
                            Text(record.emoji,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayNameForRecord(l10n, record),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatRelativeRecordTime(
                                        context, record.consumedAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: palette.inkMuted,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+${record.caffeineAmountMg}mg',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: palette.coffee,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  Color _riskTint(CaffeineRisk risk, LabPalette palette) {
    switch (risk) {
      case CaffeineRisk.low:
        return palette.success.withOpacity(0.22);
      case CaffeineRisk.medium:
        return palette.warning.withOpacity(0.22);
      case CaffeineRisk.high:
        return Colors.redAccent.withOpacity(0.16);
    }
  }

  String _riskMessage(
    BuildContext context,
    CaffeineRisk risk,
    DateTime? lowRiskTime,
  ) {
    final l10n = AppLocalizations.of(context)!;
    switch (risk) {
      case CaffeineRisk.low:
        return l10n.riskLowBody;
      case CaffeineRisk.medium:
        return l10n.riskMediumBody;
      case CaffeineRisk.high:
        final lowRiskText = lowRiskTime == null
            ? l10n.lowRiskTimeUnavailable
            : formatClockTime(context, lowRiskTime);
        return l10n.riskHighBody(lowRiskText);
    }
  }

  String _sampleNumberForRecord(
    IntakeRecord record,
    List<IntakeRecord> visibleRecords,
  ) {
    final index = visibleRecords.indexOf(record) + 1;
    return index.toString().padLeft(3, '0');
  }
}

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final points = CaffeineCalculator.buildTimeline(
      records: controller.records,
      profile: controller.profile,
      now: now,
      pastWindow: const Duration(hours: 8),
      futureWindow: const Duration(hours: 16),
      previewDoseMg: controller.whatIfDoseMg,
    );
    final insights = CaffeineCalculator.buildInsights(
      controller.records,
      controller.profile,
      now,
    );
    final peak = points.fold<double>(0, (maxValue, point) {
      return math.max(maxValue, point.amountMg);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            title: l10n.timelineHeadline,
            subtitle: l10n.timelineSubtitle,
          ),
          const SizedBox(height: 16),
          LabCard(
            sampleNumber: '101',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 240,
                  child: CustomPaint(
                    painter: TimelineChartPainter(
                      points: points,
                      now: now,
                      palette: context.palette,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('-8h', style: Theme.of(context).textTheme.bodySmall),
                    Text('now', style: Theme.of(context).textTheme.bodySmall),
                    Text('+16h', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '${l10n.previewDoseLabel}: ${controller.whatIfDoseMg}${l10n.previewDoseUnit}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Slider(
                  min: 0,
                  max: 300,
                  divisions: 12,
                  value: controller.whatIfDoseMg.toDouble(),
                  onChanged: (value) => controller.setWhatIfDose(value.round()),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    MetricNote(
                      label: l10n.peakLevelLabel,
                      value: '${peak.toStringAsFixed(0)} mg',
                    ),
                    MetricNote(
                      label: l10n.lowRiskWindowLabel,
                      value: insights.lowRiskTime == null
                          ? l10n.timeUnknown
                          : formatClockTime(context, insights.lowRiskTime!),
                    ),
                    MetricNote(
                      label: l10n.fullyClearedLabel,
                      value: insights.fullyClearedTime == null
                          ? l10n.timeUnknown
                          : formatClockTime(
                              context, insights.fullyClearedTime!),
                    ),
                    MetricNote(
                      label: l10n.projectedAtSleepLabel,
                      value:
                          '${insights.projectedAtSleepMg.toStringAsFixed(0)} mg',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.timelineNotice,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.inkMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum RecordHistoryFilter {
  all,
  today,
  week,
}

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
    final records = _filteredRecords(widget.controller.records);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            title: l10n.recordHeadline,
            subtitle: l10n.recordSubtitle,
          ),
          const SizedBox(height: 16),
          LabCard(
            sampleNumber: '201',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quickAddLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.18,
                  ),
                  itemCount: widget.controller.availableDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = widget.controller.availableDrinks[index];
                    return InkWell(
                      onTap: () =>
                          widget.controller.addDrink(drink, DateTime.now()),
                      borderRadius: BorderRadius.circular(18),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: context.palette.paperAlt.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: context.palette.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(drink.emoji,
                                  style: const TextStyle(fontSize: 26)),
                              const Spacer(),
                              Text(
                                localizedDrinkName(l10n, drink.id),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${drink.caffeineMg} mg · ${drink.volumeMl} ml',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: context.palette.inkMuted,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: () => showRecordSheet(context, widget.controller),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: Text(l10n.customRecordButton),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LabCard(
            sampleNumber: '202',
            compact: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recordFilterLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.recordFilterAll),
                      selected: _historyFilter == RecordHistoryFilter.all,
                      onSelected: (_) {
                        setState(() {
                          _historyFilter = RecordHistoryFilter.all;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text(l10n.recordFilterToday),
                      selected: _historyFilter == RecordHistoryFilter.today,
                      onSelected: (_) {
                        setState(() {
                          _historyFilter = RecordHistoryFilter.today;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text(l10n.recordFilterWeek),
                      selected: _historyFilter == RecordHistoryFilter.week,
                      onSelected: (_) {
                        setState(() {
                          _historyFilter = RecordHistoryFilter.week;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionLabel(text: l10n.recordHistoryLabel),
          const SizedBox(height: 10),
          if (records.isEmpty)
            LabCard(
              sampleNumber: '203',
              child: EmptyState(
                title: l10n.noRecordsTitle,
                body: l10n.noRecordsBody,
              ),
            )
          else
            Column(
              children: records
                  .map(
                    (record) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LabCard(
                        sampleNumber:
                            'R-${record.id.substring(record.id.length - 3)}',
                        compact: true,
                        child: Row(
                          children: [
                            Text(record.emoji,
                                style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayNameForRecord(l10n, record),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${formatDateTime(context, record.consumedAt)} · ${record.caffeineAmountMg}mg',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: context.palette.inkMuted,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: l10n.editRecordTooltip,
                              onPressed: () => showRecordSheet(
                                context,
                                widget.controller,
                                existingRecord: record,
                              ),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: l10n.deleteRecordTooltip,
                              onPressed: () =>
                                  confirmDeleteRecord(context, record),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
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
        return records
            .where(
              (record) =>
                  record.consumedAt.year == now.year &&
                  record.consumedAt.month == now.month &&
                  record.consumedAt.day == now.day,
            )
            .toList(growable: false);
      case RecordHistoryFilter.week:
        final cutoff = now.subtract(const Duration(days: 7));
        return records
            .where((record) => !record.consumedAt.isBefore(cutoff))
            .toList(growable: false);
    }
  }

  Future<void> confirmDeleteRecord(
    BuildContext context,
    IntakeRecord record,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteRecordTitle),
          content: Text(
            l10n.deleteRecordBody(displayNameForRecord(l10n, record)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancelLabel),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.confirmDeleteLabel),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await widget.controller.removeRecord(record.id);
    }
  }

  Future<void> showRecordSheet(
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
                      isEditing
                          ? l10n.editRecordTitle
                          : l10n.addCustomRecordTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration:
                          InputDecoration(labelText: l10n.customNameLabel),
                    ),
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
                      leading: const Icon(Icons.schedule_rounded),
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
                        if (date == null) {
                          return;
                        }
                        if (!context.mounted) {
                          return;
                        }
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(consumedAt),
                        );
                        if (time == null) {
                          return;
                        }
                        setModalState(() {
                          consumedAt = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      },
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
                            final amount =
                                int.tryParse(amountController.text.trim());
                            if (name.isEmpty || amount == null || amount <= 0) {
                              return;
                            }
                            if (existingRecord == null) {
                              await controller.addCustomRecord(
                                name: name,
                                caffeineAmountMg: amount,
                                consumedAt: consumedAt,
                              );
                            } else {
                              final canonicalName =
                                  existingRecord.sourceDrinkId == null
                                      ? null
                                      : localizedDrinkName(
                                          l10n,
                                          existingRecord.sourceDrinkId!,
                                        );
                              final shouldClearCustomName =
                                  canonicalName != null &&
                                      name == canonicalName;

                              await controller.updateRecord(
                                existingRecord.copyWith(
                                  consumedAt: consumedAt,
                                  caffeineAmountMg: amount,
                                  customName:
                                      shouldClearCustomName ? null : name,
                                  clearCustomName: shouldClearCustomName,
                                ),
                              );
                            }
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              isEditing ? l10n.updateLabel : l10n.saveLabel),
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

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            title: l10n.exploreHeadline,
            subtitle: l10n.exploreSubtitle,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 340,
                child: LabCard(
                  sampleNumber: '301',
                  child: ExplorePanel(
                    emoji: '☕',
                    title: l10n.encyclopediaCardTitle,
                    body: l10n.encyclopediaCardBody,
                  ),
                ),
              ),
              SizedBox(
                width: 340,
                child: LabCard(
                  sampleNumber: '302',
                  child: ExplorePanel(
                    emoji: '⚗️',
                    title: l10n.metabolismCardTitle,
                    body: l10n.metabolismCardBody,
                  ),
                ),
              ),
              SizedBox(
                width: 340,
                child: LabCard(
                  sampleNumber: '303',
                  child: ExplorePanel(
                    emoji: '∑',
                    title: l10n.formulaCardTitle,
                    body: l10n.formulaCardBody,
                  ),
                ),
              ),
              SizedBox(
                width: 340,
                child: LabCard(
                  sampleNumber: '304',
                  child: ExplorePanel(
                    emoji: '🧬',
                    title: l10n.factorsCardTitle,
                    body: l10n.factorsCardBody,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LabCard(
            sampleNumber: '305',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.referenceTableTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                _ReferenceRow(
                  label: l10n.coffeeCategory,
                  count: '15',
                  examples: 'Espresso · Americano · Latte · Cold Brew',
                ),
                _ReferenceRow(
                  label: l10n.teaCategory,
                  count: '4',
                  examples: 'Black Tea · Green Tea · Matcha · Oolong',
                ),
                _ReferenceRow(
                  label: l10n.sodaCategory,
                  count: '2',
                  examples: 'Cola · Diet Cola',
                ),
                _ReferenceRow(
                  label: l10n.energyCategory,
                  count: '2',
                  examples: 'Red Bull · Monster',
                ),
                _ReferenceRow(
                  label: l10n.supplementCategory,
                  count: '2',
                  examples: 'Caffeine Pill · Pre-workout',
                ),
                _ReferenceRow(
                  label: l10n.foodCategory,
                  count: '2',
                  examples: 'Dark Chocolate · Milk Chocolate',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.controller});

  final CaffeineJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = controller.profile;
    final halfLife = CaffeineCalculator.calculateHalfLife(profile);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            title: l10n.profileHeadline,
            subtitle: l10n.profileSubtitle,
          ),
          const SizedBox(height: 16),
          LabCard(
            sampleNumber: '401',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: context.palette.coffee.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.halfLifeLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: context.palette.inkMuted,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${halfLife.toStringAsFixed(1)} h',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(l10n.metabolismPresetLabel),
                const SizedBox(height: 8),
                SegmentedButton<MetabolismPreset>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: MetabolismPreset.fast,
                      label: Text(l10n.presetFast),
                    ),
                    ButtonSegment(
                      value: MetabolismPreset.normal,
                      label: Text(l10n.presetNormal),
                    ),
                    ButtonSegment(
                      value: MetabolismPreset.slow,
                      label: Text(l10n.presetSlow),
                    ),
                    ButtonSegment(
                      value: MetabolismPreset.unknown,
                      label: Text(l10n.presetUnknown),
                    ),
                  ],
                  selected: {profile.metabolismPreset},
                  onSelectionChanged: (selection) {
                    controller.updateProfile(
                      profile.copyWith(metabolismPreset: selection.first),
                    );
                  },
                ),
                const SizedBox(height: 18),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.smokerLabel),
                  value: profile.isSmoker,
                  onChanged: (value) => controller.updateProfile(
                    profile.copyWith(isSmoker: value),
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.oralContraceptivesLabel),
                  value: profile.usesOralContraceptives,
                  onChanged: (value) => controller.updateProfile(
                    profile.copyWith(usesOralContraceptives: value),
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.pregnantLabel),
                  value: profile.isPregnant,
                  onChanged: (value) => controller.updateProfile(
                    profile.copyWith(isPregnant: value),
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.drinksAlcoholLabel),
                  value: profile.drinksAlcohol,
                  onChanged: (value) => controller.updateProfile(
                    profile.copyWith(drinksAlcohol: value),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<LiverStatus>(
                  value: profile.liverStatus,
                  decoration: InputDecoration(labelText: l10n.liverStatusLabel),
                  items: LiverStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(localizedLiverStatus(l10n, status)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      controller
                          .updateProfile(profile.copyWith(liverStatus: value));
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Cyp1a2Genotype>(
                  value: profile.genotype,
                  decoration: InputDecoration(labelText: l10n.genotypeLabel),
                  items: Cyp1a2Genotype.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(localizedGenotype(l10n, value)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      controller
                          .updateProfile(profile.copyWith(genotype: value));
                    }
                  },
                ),
                const SizedBox(height: 18),
                Text('${l10n.ageLabel}: ${profile.age}'),
                Slider(
                  min: 18,
                  max: 80,
                  divisions: 62,
                  value: profile.age.toDouble(),
                  onChanged: (value) => controller.updateProfile(
                    profile.copyWith(age: value.round()),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${l10n.dailyBudgetLabel}: ${profile.dailyBudgetMg}mg'),
                Slider(
                  min: 100,
                  max: 500,
                  divisions: 8,
                  value: profile.dailyBudgetMg.toDouble(),
                  onChanged: (value) => controller.updateProfile(
                    profile.copyWith(dailyBudgetMg: value.round()),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bedtime_outlined),
                  title: Text(l10n.sleepTargetLabel),
                  subtitle: Text(
                    formatMinutesAsTime(context, profile.targetSleepMinutes),
                  ),
                  onTap: () async {
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: profile.targetSleepMinutes ~/ 60,
                        minute: profile.targetSleepMinutes % 60,
                      ),
                    );
                    if (selected == null) {
                      return;
                    }
                    controller.updateProfile(
                      profile.copyWith(
                        targetSleepMinutes:
                            selected.hour * 60 + selected.minute,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageIntro extends StatelessWidget {
  const PageIntro({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          width: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.palette.coffee,
                context.palette.accent.withOpacity(0.24),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.15,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.palette.inkMuted,
              ),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.palette.border.withOpacity(0.85),
                  context.palette.border.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LabCard extends StatelessWidget {
  const LabCard({
    super.key,
    required this.sampleNumber,
    required this.child,
    this.compact = false,
  });

  final String sampleNumber;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: palette.shadow.withOpacity(0.75),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      palette.paper,
                      palette.paperAlt.withOpacity(0.28),
                    ],
                  ),
                  border: Border.all(color: palette.border.withOpacity(0.72)),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _PaperTexturePainter(palette)),
              ),
            ),
            Positioned(
              top: 12,
              left: 18,
              child: Transform.rotate(
                angle: -0.08,
                child: _TapeStrip(color: palette.warning.withOpacity(0.16)),
              ),
            ),
            Positioned(
              top: 10,
              right: 24,
              child: Transform.rotate(
                angle: 0.12,
                child: _TapeStrip(color: palette.accent.withOpacity(0.14)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, compact ? 20 : 24, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: palette.paperAlt.withOpacity(0.52),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: palette.border.withOpacity(0.55)),
                    ),
                    child: Text(
                      'Sample No. $sampleNumber',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: palette.ink,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TapeStrip extends StatelessWidget {
  const _TapeStrip({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  const _PaperTexturePainter(this.palette);

  final LabPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = palette.border.withOpacity(0.08)
      ..strokeWidth = 1;

    for (double dy = 22; dy < size.height; dy += 26) {
      canvas.drawLine(Offset(18, dy), Offset(size.width - 18, dy), linePaint);
    }

    final cornerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          palette.warning.withOpacity(0.08),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, cornerPaint);
  }

  @override
  bool shouldRepaint(_PaperTexturePainter oldDelegate) {
    return oldDelegate.palette != palette;
  }
}

class MetricNote extends StatelessWidget {
  const MetricNote({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.palette.paperAlt.withOpacity(0.34),
            context.palette.paper.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 3,
            decoration: BoxDecoration(
              color: context.palette.coffee,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.inkMuted,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class ExplorePanel extends StatelessWidget {
  const ExplorePanel({
    super.key,
    required this.emoji,
    required this.title,
    required this.body,
  });

  final String emoji;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.palette.paperAlt.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(color: context.palette.border.withOpacity(0.75)),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 28)),
        ),
        const SizedBox(height: 14),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.palette.inkMuted,
              ),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.palette.paperAlt.withOpacity(0.34),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.science_outlined,
            color: context.palette.coffee,
          ),
        ),
        const SizedBox(height: 14),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.palette.inkMuted,
              ),
        ),
      ],
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  const _ReferenceRow({
    required this.label,
    required this.count,
    required this.examples,
    this.isLast = false,
  });

  final String label;
  final String count;
  final String examples;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: context.palette.border),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.titleSmall),
          ),
          SizedBox(
            width: 36,
            child: Text(
              count,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.palette.coffee,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              examples,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.inkMuted,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabWorkbenchBackground extends StatelessWidget {
  const LabWorkbenchBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _WorkbenchTexturePainter(palette),
            ),
          ),
          Positioned(
            top: -60,
            right: -20,
            child: _StainBlob(
              color: palette.warning.withOpacity(0.12),
              size: 180,
            ),
          ),
          Positioned(
            left: -30,
            top: 180,
            child: _StainBlob(
              color: palette.accent.withOpacity(0.10),
              size: 140,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 120,
            child: _StainBlob(
              color: palette.coffee.withOpacity(0.08),
              size: 220,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkbenchTexturePainter extends CustomPainter {
  const _WorkbenchTexturePainter(this.palette);

  final LabPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final grainPaint = Paint()
      ..color = palette.border.withOpacity(0.08)
      ..strokeWidth = 1;
    for (double dy = 0; dy < size.height; dy += 18) {
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), grainPaint);
    }

    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.7),
        radius: 1.2,
        colors: [
          palette.paper.withOpacity(0.12),
          Colors.transparent,
          palette.background.withOpacity(0.22),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);

    final edgePaint = Paint()
      ..color = palette.shadow.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32;
    canvas.drawRect(Offset.zero & size, edgePaint);
  }

  @override
  bool shouldRepaint(_WorkbenchTexturePainter oldDelegate) {
    return oldDelegate.palette != palette;
  }
}

class _StainBlob extends StatelessWidget {
  const _StainBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

class TimelineChartPainter extends CustomPainter {
  TimelineChartPainter({
    required this.points,
    required this.now,
    required this.palette,
  });

  final List<TimelinePoint> points;
  final DateTime now;
  final LabPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) {
      return;
    }

    const padding = EdgeInsets.fromLTRB(8, 12, 8, 18);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );
    final maxY = math.max(
        100.0,
        points.fold<double>(0, (maxValue, point) {
          return math.max(maxValue, point.amountMg);
        }));

    final gridPaint = Paint()
      ..color = palette.border.withOpacity(0.6)
      ..strokeWidth = 1;
    for (var step = 0; step <= 4; step++) {
      final dy = chartRect.top + chartRect.height * (step / 4);
      canvas.drawLine(
        Offset(chartRect.left, dy),
        Offset(chartRect.right, dy),
        gridPaint,
      );
    }

    final lowRiskY = chartRect.bottom - (20 / maxY) * chartRect.height;
    final lowRiskPaint = Paint()
      ..color = palette.success.withOpacity(0.16)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(
          chartRect.left, lowRiskY, chartRect.right, chartRect.bottom),
      lowRiskPaint,
    );

    final linePath = Path();
    final fillPath = Path();
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final dx =
          chartRect.left + (index / (points.length - 1)) * chartRect.width;
      final dy = chartRect.bottom - (point.amountMg / maxY) * chartRect.height;
      if (index == 0) {
        linePath.moveTo(dx, dy);
        fillPath.moveTo(dx, chartRect.bottom);
        fillPath.lineTo(dx, dy);
      } else {
        linePath.lineTo(dx, dy);
        fillPath.lineTo(dx, dy);
      }
    }
    fillPath
      ..lineTo(chartRect.right, chartRect.bottom)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = palette.coffee.withOpacity(0.14)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = palette.coffee
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final nowIndex = _nearestIndexToNow();
    final nowDx =
        chartRect.left + (nowIndex / (points.length - 1)) * chartRect.width;
    canvas.drawLine(
      Offset(nowDx, chartRect.top),
      Offset(nowDx, chartRect.bottom),
      Paint()
        ..color = palette.warning
        ..strokeWidth = 2,
    );
  }

  int _nearestIndexToNow() {
    var bestIndex = 0;
    var smallest = const Duration(days: 99);
    for (var index = 0; index < points.length; index++) {
      final difference = points[index].time.difference(now).abs();
      if (difference < smallest) {
        smallest = difference;
        bestIndex = index;
      }
    }
    return bestIndex;
  }

  @override
  bool shouldRepaint(TimelineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.now != now ||
        oldDelegate.palette != palette;
  }
}

String displayNameForRecord(AppLocalizations l10n, IntakeRecord record) {
  return record.customName ??
      localizedDrinkName(l10n, record.sourceDrinkId ?? 'americano');
}

String localizedDrinkName(AppLocalizations l10n, String id) {
  switch (id) {
    case 'americano':
      return l10n.drinkAmericano;
    case 'latte':
      return l10n.drinkLatte;
    case 'espresso':
      return l10n.drinkEspresso;
    case 'cold_brew':
      return l10n.drinkColdBrew;
    case 'black_tea':
      return l10n.drinkBlackTea;
    case 'green_tea':
      return l10n.drinkGreenTea;
    case 'cola':
      return l10n.drinkCola;
    case 'energy_drink':
      return l10n.drinkEnergyDrink;
    default:
      return id;
  }
}

String localizedLiverStatus(AppLocalizations l10n, LiverStatus status) {
  switch (status) {
    case LiverStatus.none:
      return l10n.liverNone;
    case LiverStatus.mild:
      return l10n.liverMild;
    case LiverStatus.moderate:
      return l10n.liverModerate;
    case LiverStatus.severe:
      return l10n.liverSevere;
  }
}

String localizedGenotype(AppLocalizations l10n, Cyp1a2Genotype genotype) {
  switch (genotype) {
    case Cyp1a2Genotype.aa:
      return l10n.genotypeAa;
    case Cyp1a2Genotype.ac:
      return l10n.genotypeAc;
    case Cyp1a2Genotype.cc:
      return l10n.genotypeCc;
    case Cyp1a2Genotype.unknown:
      return l10n.genotypeUnknown;
  }
}

String formatRelativeRecordTime(BuildContext context, DateTime time) {
  final l10n = AppLocalizations.of(context)!;
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 60) {
    return l10n.minutesAgo(math.max(diff.inMinutes, 1));
  }
  if (diff.inHours < 24) {
    return l10n.hoursAgo(math.max(diff.inHours, 1));
  }
  return formatDateTime(context, time);
}

String formatDateTime(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  final date = localizations.formatShortDate(dateTime);
  final time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime));
  return '$date · $time';
}

String formatClockTime(BuildContext context, DateTime dateTime) {
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(dateTime),
  );
}

String formatMinutesAsTime(BuildContext context, int minutes) {
  final hour = minutes ~/ 60;
  final minute = minutes % 60;
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay(hour: hour, minute: minute),
  );
}
