import 'dart:convert';

import '../models/caffeine_profile.dart';
import '../models/intake_record.dart';

class DataExchangeService {
  static const _currentVersion = 1;

  Map<String, Object?> exportAll({
    required CaffeineProfile profile,
    required List<IntakeRecord> records,
  }) {
    return {
      'version': _currentVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': profile.toJson(),
      'records': records.map((r) => r.toJson()).toList(),
    };
  }

  String exportToJsonString({
    required CaffeineProfile profile,
    required List<IntakeRecord> records,
  }) {
    final data = exportAll(profile: profile, records: records);
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  ({CaffeineProfile profile, List<IntakeRecord> records})? parseImportJsonString(
    String source,
  ) {
    final dynamic parsed = jsonDecode(source);
    if (parsed is! Map<String, dynamic>) {
      return null;
    }

    final version = parsed['version'];
    if (version is! int || version != _currentVersion) {
      return null;
    }

    final profileRaw = parsed['profile'];
    if (profileRaw is! Map<String, dynamic>) {
      return null;
    }

    final recordsRaw = parsed['records'];
    if (recordsRaw is! List<dynamic>) {
      return null;
    }

    try {
      final profile = CaffeineProfile.fromJson(profileRaw);
      final records = recordsRaw
          .cast<Map<String, dynamic>>()
          .map(IntakeRecord.fromJson)
          .toList(growable: false);
      return (profile: profile, records: records);
    } on Exception {
      return null;
    }
  }
}
