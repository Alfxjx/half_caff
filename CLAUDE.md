# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called **half_caff**, currently in early development. The project contains an HTML prototype at [`sample_app/index_prototype.html`](sample_app/index_prototype.html) that defines the intended functionality: a caffeine metabolism research report with interactive calculators based on pharmacokinetic models. The Flutter app should eventually replicate this prototype's features, including single-dose and multi-dose caffeine calculators, half-life tables, and metabolic factor reference data.

## Commands

- **Install dependencies**: `flutter pub get`
- **Run the app** (debug): `flutter run`
- **Run tests**: `flutter test`
- **Run a single test file**: `flutter test test/widget_test.dart`
- **Analyze / lint**: `flutter analyze`
- **Build APK**: `flutter build apk`
- **Build web**: `flutter build web`

## Architecture

The project is a standard multi-platform Flutter app targeting Android, iOS, web, Windows, Linux, and macOS. The codebase is currently minimal (default Flutter counter app) and will need to be built out to match the prototype.

Key locations:
- [`lib/main.dart`](lib/main.dart): Entry point and current root widget.
- [`sample_app/index_prototype.html`](sample_app/index_prototype.html): Functional reference for UI, copy, and calculation logic. Contains pharmacokinetic formulas, half-life data, drink caffeine content tables, and Chart.js-based interactive graphs.
- [`test/widget_test.dart`](test/widget_test.dart): Default widget test.

## Linting

The project uses `package:flutter_lints/flutter.yaml` via [`analysis_options.yaml`](analysis_options.yaml). No custom rules are currently enabled.
