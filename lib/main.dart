import 'package:flutter/widgets.dart';

import 'src/app/app.dart';
import 'src/app/app_controller.dart';
import 'src/services/local_storage_service.dart';
import 'src/state/caffeine_journal_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();
  final appController = AppController(storage);
  final journalController = CaffeineJournalController(storage);

  await Future.wait<void>([
    appController.load(),
    journalController.load(),
  ]);

  runApp(
    HalfCaffApp(
      appController: appController,
      journalController: journalController,
    ),
  );
}
