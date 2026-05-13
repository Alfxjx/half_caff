import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/caffeine_profile.dart';
import '../../../models/intake_record.dart';

String displayNameForRecord(AppLocalizations l10n, IntakeRecord record) {
  return record.customName ?? localizedDrinkName(l10n, record.sourceDrinkId ?? 'americano');
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
    case 'double_espresso':
      return l10n.drinkDoubleEspresso;
    case 'large_drip':
      return l10n.drinkLargeDrip;
    case 'large_cold_brew':
      return l10n.drinkLargeColdBrew;
    case 'instant_coffee':
      return l10n.drinkInstantCoffee;
    case 'cappuccino':
      return l10n.drinkCappuccino;
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
  if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes < 1 ? 1 : diff.inMinutes);
  if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
  return formatDateTime(context, time);
}

String formatDateTime(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  return '${localizations.formatShortDate(dateTime)} · ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime))}';
}

String formatMinutesAsTime(BuildContext context, int minutes) {
  final hour = minutes ~/ 60;
  final minute = minutes % 60;
  return MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: hour, minute: minute));
}
