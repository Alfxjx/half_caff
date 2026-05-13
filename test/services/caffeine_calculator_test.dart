import 'package:flutter_test/flutter_test.dart';
import 'package:half_caff/src/models/caffeine_profile.dart';
import 'package:half_caff/src/models/intake_record.dart';
import 'package:half_caff/src/services/caffeine_calculator.dart';

void main() {
  group('calculateHalfLife', () {
    test('defaults to 5h for normal preset', () {
      final profile = CaffeineProfile.defaults();
      expect(CaffeineCalculator.calculateHalfLife(profile), 5.0);
    });

    test('fast preset returns 3h', () {
      final profile = CaffeineProfile.defaults().copyWith(
        metabolismPreset: MetabolismPreset.fast,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 3.0);
    });

    test('slow preset returns 7h', () {
      final profile = CaffeineProfile.defaults().copyWith(
        metabolismPreset: MetabolismPreset.slow,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 7.0);
    });

    test('AA genotype overrides preset to 3h', () {
      final profile = CaffeineProfile.defaults().copyWith(
        metabolismPreset: MetabolismPreset.slow,
        genotype: Cyp1a2Genotype.aa,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 3.0);
    });

    test('CC genotype overrides preset to 10h', () {
      final profile = CaffeineProfile.defaults().copyWith(
        metabolismPreset: MetabolismPreset.fast,
        genotype: Cyp1a2Genotype.cc,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 10.0);
    });

    test('smoker reduces half-life by 40%', () {
      final profile = CaffeineProfile.defaults().copyWith(isSmoker: true);
      expect(CaffeineCalculator.calculateHalfLife(profile), closeTo(3.0, 0.1));
    });

    test('oral contraceptives doubles half-life', () {
      final profile = CaffeineProfile.defaults().copyWith(
        usesOralContraceptives: true,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 10.0);
    });

    test('pregnancy triples half-life', () {
      final profile = CaffeineProfile.defaults().copyWith(isPregnant: true);
      expect(CaffeineCalculator.calculateHalfLife(profile), 15.0);
    });

    test('alcohol increases half-life by 40%', () {
      final profile = CaffeineProfile.defaults().copyWith(drinksAlcohol: true);
      expect(CaffeineCalculator.calculateHalfLife(profile), closeTo(7.0, 0.1));
    });

    test('elderly increases half-life by 30%', () {
      final profile = CaffeineProfile.defaults().copyWith(age: 70);
      expect(CaffeineCalculator.calculateHalfLife(profile), closeTo(6.5, 0.1));
    });

    test('liver disease multiplies half-life', () {
      final profile = CaffeineProfile.defaults().copyWith(
        liverStatus: LiverStatus.severe,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 20.0);
    });

    test('custom half-life is respected', () {
      final profile = CaffeineProfile.defaults().copyWith(
        customHalfLifeHours: 4.5,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 4.5);
    });

    test(' clamps to 24h maximum', () {
      final profile = CaffeineProfile.defaults().copyWith(
        isPregnant: true,
        liverStatus: LiverStatus.severe,
      );
      expect(CaffeineCalculator.calculateHalfLife(profile), 24.0);
    });
  });

  group('remainingAmount', () {
    final record = IntakeRecord(
      id: '1',
      consumedAt: DateTime(2024, 1, 1, 8),
      loggedAt: DateTime(2024, 1, 1, 8),
      caffeineAmountMg: 200,
      emoji: '☕',
    );

    test('full amount at time zero', () {
      final at = DateTime(2024, 1, 1, 8);
      expect(
        CaffeineCalculator.remainingAmount(record, at, 5.0),
        200.0,
      );
    });

    test('half remaining after one half-life', () {
      final at = DateTime(2024, 1, 1, 13);
      expect(
        CaffeineCalculator.remainingAmount(record, at, 5.0),
        closeTo(100.0, 0.1),
      );
    });

    test('zero before consumption', () {
      final at = DateTime(2024, 1, 1, 7);
      expect(
        CaffeineCalculator.remainingAmount(record, at, 5.0),
        0.0,
      );
    });
  });

  group('totalAmount', () {
    final records = [
      IntakeRecord(
        id: '1',
        consumedAt: DateTime(2024, 1, 1, 8),
        loggedAt: DateTime(2024, 1, 1, 8),
        caffeineAmountMg: 200,
        emoji: '☕',
      ),
      IntakeRecord(
        id: '2',
        consumedAt: DateTime(2024, 1, 1, 10),
        loggedAt: DateTime(2024, 1, 1, 10),
        caffeineAmountMg: 100,
        emoji: '☕',
      ),
    ];
    final profile = CaffeineProfile.defaults();

    test('sums multiple records', () {
      final at = DateTime(2024, 1, 1, 12);
      final total = CaffeineCalculator.totalAmount(records, profile, at);
      expect(total, greaterThan(0.0));
    });

    test('preview dose is included', () {
      final at = DateTime(2024, 1, 1, 12);
      final total = CaffeineCalculator.totalAmount(
        records,
        profile,
        at,
        previewDoseMg: 50,
      );
      expect(total, greaterThan(CaffeineCalculator.totalAmount(records, profile, at)));
    });
  });

  group('totalDailyIntake', () {
    final records = [
      IntakeRecord(
        id: '1',
        consumedAt: DateTime(2024, 1, 1, 8),
        loggedAt: DateTime(2024, 1, 1, 8),
        caffeineAmountMg: 200,
        emoji: '☕',
      ),
      IntakeRecord(
        id: '2',
        consumedAt: DateTime(2024, 1, 1, 14),
        loggedAt: DateTime(2024, 1, 1, 14),
        caffeineAmountMg: 100,
        emoji: '☕',
      ),
      IntakeRecord(
        id: '3',
        consumedAt: DateTime(2024, 1, 2, 8),
        loggedAt: DateTime(2024, 1, 2, 8),
        caffeineAmountMg: 150,
        emoji: '☕',
      ),
    ];

    test('counts only same-day records', () {
      final day = DateTime(2024, 1, 1);
      expect(CaffeineCalculator.totalDailyIntake(records, day), 300);
    });

    test('returns 0 for day with no records', () {
      final day = DateTime(2024, 1, 3);
      expect(CaffeineCalculator.totalDailyIntake(records, day), 0);
    });
  });

  group('riskAtSleep', () {
    final profile = CaffeineProfile.defaults().copyWith(
      targetSleepMinutes: 23 * 60,
    );

    test('low risk when projected amount is low', () {
      final records = <IntakeRecord>[];
      final now = DateTime(2024, 1, 1, 20);
      expect(
        CaffeineCalculator.riskAtSleep(records, profile, now),
        CaffeineRisk.low,
      );
    });
  });

  group('buildInsights', () {
    final profile = CaffeineProfile.defaults();
    final now = DateTime(2024, 1, 1, 14);

    test('returns correct budget remaining', () {
      final records = [
        IntakeRecord(
          id: '1',
          consumedAt: now.subtract(const Duration(hours: 2)),
          loggedAt: now.subtract(const Duration(hours: 2)),
          caffeineAmountMg: 200,
          emoji: '☕',
        ),
      ];
      final insights = CaffeineCalculator.buildInsights(records, profile, now);
      expect(insights.dailyTotalMg, 200);
      expect(insights.budgetRemainingMg, 200);
    });

    test('identifies low risk time', () {
      final records = <IntakeRecord>[];
      final insights = CaffeineCalculator.buildInsights(records, profile, now);
      expect(insights.lowRiskTime, isNotNull);
    });
  });
}
