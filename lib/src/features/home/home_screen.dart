import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/app_controller.dart';
import '../../state/caffeine_journal_controller.dart';
import 'dashboard_page.dart';
import 'explore_page.dart';
import 'profile_page.dart';
import 'record_action_sheet.dart';
import 'timeline_page.dart';

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
        final pages = [
          DashboardPage(controller: journalController),
          TimelinePage(controller: journalController),
          ExplorePage(controller: journalController),
          ProfilePage(controller: journalController),
        ];

        return Scaffold(
          backgroundColor: context.palette.canvas,
          appBar: AppBar(
            toolbarHeight: 64,
            title: _AppBarTitle(
                l10n: l10n, selectedIndex: journalController.selectedTab),
            actions: [
              _SettingsButton(
                onPressed: () => _openSettingsSheet(context, l10n),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: IndexedStack(
              index: journalController.selectedTab,
              children: pages,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showRecordActionSheet(context, journalController),
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: journalController.selectedTab,
            onDestinationSelected: journalController.selectTab,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: l10n.dashboardTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.show_chart_outlined),
                selectedIcon: const Icon(Icons.show_chart),
                label: l10n.timelineTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.auto_stories_outlined),
                selectedIcon: const Icon(Icons.auto_stories),
                label: l10n.exploreTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: l10n.profileTab,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openSettingsSheet(BuildContext context, AppLocalizations l10n) {
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
                Text(l10n.settingsTitle,
                    style: Theme.of(sheetContext).textTheme.titleLarge),
                const SizedBox(height: 20),
                Text(l10n.themeModeLabel,
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                        value: ThemeMode.system, label: Text(l10n.themeSystem)),
                    ButtonSegment(
                        value: ThemeMode.light, label: Text(l10n.themeLight)),
                    ButtonSegment(
                        value: ThemeMode.dark, label: Text(l10n.themeDark)),
                  ],
                  selected: {appController.themeMode},
                  onSelectionChanged: (selection) {
                    appController.setThemeMode(selection.first);
                  },
                ),
                const SizedBox(height: 24),
                Text(l10n.languageLabel,
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: appController.localeTag,
                  items: [
                    DropdownMenuItem(
                        value: 'system', child: Text(l10n.languageSystem)),
                    DropdownMenuItem(
                        value: 'en', child: Text(l10n.languageEnglish)),
                    DropdownMenuItem(
                        value: 'zh',
                        child: Text(l10n.languageSimplifiedChinese)),
                    DropdownMenuItem(
                        value: 'zh-Hant',
                        child: Text(l10n.languageTraditionalChinese)),
                  ],
                  onChanged: (value) {
                    if (value != null) appController.setLocaleTag(value);
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

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.l10n, required this.selectedIndex});

  final AppLocalizations l10n;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '☕',
          style: TextStyle(
            fontSize: 22,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'HalfCaff',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.palette.ink,
                letterSpacing: -0.3,
              ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 1,
          height: 20,
          color: context.palette.hairline,
        ),
        const SizedBox(width: 16),
        Text(
          _pageLabel(l10n, selectedIndex),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.palette.muted,
              ),
        ),
      ],
    );
  }

  String _pageLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.dashboardTab;
      case 1:
        return l10n.timelineTab;
      case 2:
        return l10n.exploreTab;
      case 3:
        return l10n.profileTab;
      default:
        return '';
    }
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.tune_outlined),
      tooltip: 'Settings',
    );
  }
}
