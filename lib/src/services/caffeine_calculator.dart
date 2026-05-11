import 'dart:math';

import '../models/caffeine_profile.dart';
import '../models/intake_record.dart';

enum CaffeineRisk { low, medium, high }

class TimelinePoint {
  const TimelinePoint({
    required this.time,
    required this.amountMg,
  });

  final DateTime time;
  final double amountMg;
}

class CaffeineInsights {
  const CaffeineInsights({
    required this.currentAmountMg,
    required this.dailyTotalMg,
    required this.halfLifeHours,
    required this.budgetRemainingMg,
    required this.projectedAtSleepMg,
    required this.risk,
    required this.lowRiskTime,
    required this.fullyClearedTime,
  });

  final double currentAmountMg;
  final int dailyTotalMg;
  final double halfLifeHours;
  final int budgetRemainingMg;
  final double projectedAtSleepMg;
  final CaffeineRisk risk;
  final DateTime? lowRiskTime;
  final DateTime? fullyClearedTime;
}

class CaffeineCalculator {
  static double calculateHalfLife(CaffeineProfile profile) {
    if (profile.customHalfLifeHours != null) {
      return profile.customHalfLifeHours!.clamp(1.0, 24.0);
    }

    var base = switch (profile.metabolismPreset) {
      MetabolismPreset.fast => 3.0,
      MetabolismPreset.normal => 5.0,
      MetabolismPreset.slow => 7.0,
      MetabolismPreset.unknown => 5.0,
    };

    base = switch (profile.genotype) {
      Cyp1a2Genotype.aa => 3.0,
      Cyp1a2Genotype.ac => 7.0,
      Cyp1a2Genotype.cc => 10.0,
      Cyp1a2Genotype.unknown => base,
    };

    if (profile.isSmoker) {
      base *= 0.6;
    }
    if (profile.usesOralContraceptives) {
      base *= 2.0;
    }
    if (profile.isPregnant) {
      base *= 3.0;
    }
    if (profile.drinksAlcohol) {
      base *= 1.4;
    }
    if (profile.age > 65) {
      base *= 1.3;
    }

    base *= switch (profile.liverStatus) {
      LiverStatus.none => 1.0,
      LiverStatus.mild => 2.0,
      LiverStatus.moderate => 3.0,
      LiverStatus.severe => 4.0,
    };

    return double.parse(base.clamp(1.0, 24.0).toStringAsFixed(1));
  }

  static double remainingAmount(
    IntakeRecord record,
    DateTime at,
    double halfLifeHours,
  ) {
    final elapsedMinutes = at.difference(record.consumedAt).inMinutes;
    if (elapsedMinutes < 0) {
      return 0;
    }

    final elapsedHours = elapsedMinutes / 60.0;
    return (record.caffeineAmountMg * pow(0.5, elapsedHours / halfLifeHours))
        .toDouble();
  }

  static double totalAmount(
    List<IntakeRecord> records,
    CaffeineProfile profile,
    DateTime at, {
    int previewDoseMg = 0,
    DateTime? previewTime,
  }) {
    final halfLife = calculateHalfLife(profile);
    var total = 0.0;
    for (final record in records) {
      total += remainingAmount(record, at, halfLife);
    }

    if (previewDoseMg > 0) {
      final previewAt = previewTime ?? at;
      if (!at.isBefore(previewAt)) {
        final previewRecord = IntakeRecord(
          id: 'preview',
          consumedAt: previewAt,
          loggedAt: previewAt,
          caffeineAmountMg: previewDoseMg,
          emoji: '🧪',
        );
        total += remainingAmount(previewRecord, at, halfLife);
      }
    }

    return total;
  }

  static int totalDailyIntake(List<IntakeRecord> records, DateTime day) {
    return records
        .where(
          (record) =>
              record.consumedAt.year == day.year &&
              record.consumedAt.month == day.month &&
              record.consumedAt.day == day.day,
        )
        .fold<int>(0, (sum, record) => sum + record.caffeineAmountMg);
  }

  static DateTime targetSleepDateTime(CaffeineProfile profile, DateTime now) {
    final candidate = DateTime(
      now.year,
      now.month,
      now.day,
      profile.targetSleepMinutes ~/ 60,
      profile.targetSleepMinutes % 60,
    );

    if (candidate.isAfter(now)) {
      return candidate;
    }

    return candidate.add(const Duration(days: 1));
  }

  static CaffeineRisk riskAtSleep(
    List<IntakeRecord> records,
    CaffeineProfile profile,
    DateTime now,
  ) {
    final projected = totalAmount(
      records,
      profile,
      targetSleepDateTime(profile, now),
    );

    if (projected <= 20) {
      return CaffeineRisk.low;
    }
    if (projected <= 60) {
      return CaffeineRisk.medium;
    }
    return CaffeineRisk.high;
  }

  static DateTime? firstTimeBelow(
    List<IntakeRecord> records,
    CaffeineProfile profile,
    DateTime start,
    double thresholdMg,
  ) {
    for (var minutes = 0; minutes <= 36 * 60; minutes += 15) {
      final time = start.add(Duration(minutes: minutes));
      if (totalAmount(records, profile, time) <= thresholdMg) {
        return time;
      }
    }
    return null;
  }

  static CaffeineInsights buildInsights(
    List<IntakeRecord> records,
    CaffeineProfile profile,
    DateTime now,
  ) {
    final halfLife = calculateHalfLife(profile);
    final current = totalAmount(records, profile, now);
    final dailyTotal = totalDailyIntake(records, now);
    final projectedAtSleep = totalAmount(
      records,
      profile,
      targetSleepDateTime(profile, now),
    );

    return CaffeineInsights(
      currentAmountMg: current,
      dailyTotalMg: dailyTotal,
      halfLifeHours: halfLife,
      budgetRemainingMg: max(0, profile.dailyBudgetMg - dailyTotal),
      projectedAtSleepMg: projectedAtSleep,
      risk: riskAtSleep(records, profile, now),
      lowRiskTime: firstTimeBelow(records, profile, now, 20),
      fullyClearedTime: firstTimeBelow(records, profile, now, 5),
    );
  }

  static List<TimelinePoint> buildTimeline({
    required List<IntakeRecord> records,
    required CaffeineProfile profile,
    required DateTime now,
    required Duration pastWindow,
    required Duration futureWindow,
    int previewDoseMg = 0,
  }) {
    final points = <TimelinePoint>[];
    final start = now.subtract(pastWindow);
    final end = now.add(futureWindow);

    for (var time = start;
        !time.isAfter(end);
        time = time.add(const Duration(minutes: 15))) {
      points.add(
        TimelinePoint(
          time: time,
          amountMg: totalAmount(
            records,
            profile,
            time,
            previewDoseMg: previewDoseMg,
            previewTime: now,
          ),
        ),
      );
    }

    return points;
  }
}
