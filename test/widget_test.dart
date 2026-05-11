import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:half_caff/src/app/app.dart';
import 'package:half_caff/src/app/app_controller.dart';
import 'package:half_caff/src/services/local_storage_service.dart';
import 'package:half_caff/src/state/caffeine_journal_controller.dart';

void main() {
  testWidgets('renders HalfCaff dashboard shell', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'app.locale': 'en',
      'app.themeMode': 'light',
    });

    final storage = LocalStorageService();
    final appController = AppController(storage);
    final journalController = CaffeineJournalController(storage);

    await Future.wait<void>([
      appController.load(),
      journalController.load(),
    ]);

    await tester.pumpWidget(
      HalfCaffApp(
        appController: appController,
        journalController: journalController,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HalfCaff'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text("Today's Intake"), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    journalController.dispose();
    appController.dispose();
    await tester.pump();
  });
}
