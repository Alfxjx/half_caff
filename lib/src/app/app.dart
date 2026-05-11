import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../features/home/home_screen.dart';
import '../state/caffeine_journal_controller.dart';
import '../theme/app_theme.dart';
import 'app_controller.dart';

class HalfCaffApp extends StatelessWidget {
  const HalfCaffApp({
    super.key,
    required this.appController,
    required this.journalController,
  });

  final AppController appController;
  final CaffeineJournalController journalController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        return MaterialApp(
          title: 'HalfCaff',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: appController.themeMode,
          locale: appController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomeScreen(
            appController: appController,
            journalController: journalController,
          ),
        );
      },
    );
  }
}
