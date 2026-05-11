import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class LabPalette extends ThemeExtension<LabPalette> {
  const LabPalette({
    required this.paper,
    required this.paperAlt,
    required this.ink,
    required this.inkMuted,
    required this.coffee,
    required this.accent,
    required this.warning,
    required this.success,
    required this.border,
    required this.shadow,
    required this.background,
    required this.backgroundAccent,
  });

  final Color paper;
  final Color paperAlt;
  final Color ink;
  final Color inkMuted;
  final Color coffee;
  final Color accent;
  final Color warning;
  final Color success;
  final Color border;
  final Color shadow;
  final Color background;
  final Color backgroundAccent;

  @override
  LabPalette copyWith({
    Color? paper,
    Color? paperAlt,
    Color? ink,
    Color? inkMuted,
    Color? coffee,
    Color? accent,
    Color? warning,
    Color? success,
    Color? border,
    Color? shadow,
    Color? background,
    Color? backgroundAccent,
  }) {
    return LabPalette(
      paper: paper ?? this.paper,
      paperAlt: paperAlt ?? this.paperAlt,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      coffee: coffee ?? this.coffee,
      accent: accent ?? this.accent,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      background: background ?? this.background,
      backgroundAccent: backgroundAccent ?? this.backgroundAccent,
    );
  }

  @override
  LabPalette lerp(ThemeExtension<LabPalette>? other, double t) {
    if (other is! LabPalette) {
      return this;
    }

    return LabPalette(
      paper: Color.lerp(paper, other.paper, t)!,
      paperAlt: Color.lerp(paperAlt, other.paperAlt, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      coffee: Color.lerp(coffee, other.coffee, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundAccent:
          Color.lerp(backgroundAccent, other.backgroundAccent, t)!,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    const palette = LabPalette(
      paper: Color(0xFFF5E9CB),
      paperAlt: Color(0xFFE6D2A7),
      ink: Color(0xFF2B3950),
      inkMuted: Color(0xFF6D6A63),
      coffee: Color(0xFF6D4A35),
      accent: Color(0xFF52796F),
      warning: Color(0xFFAD6C3D),
      success: Color(0xFF4D7C65),
      border: Color(0xFFB79E77),
      shadow: Color(0x332B1D14),
      background: Color(0xFFEEE0BD),
      backgroundAccent: Color(0xFFF8F1DE),
    );

    return _buildTheme(
      palette: palette,
      brightness: Brightness.light,
      baseTheme: ThemeData.light(),
    );
  }

  static ThemeData dark() {
    const palette = LabPalette(
      paper: Color(0xFF332821),
      paperAlt: Color(0xFF43352C),
      ink: Color(0xFFF3E6C8),
      inkMuted: Color(0xFFC9B79E),
      coffee: Color(0xFFC28E62),
      accent: Color(0xFF7BA58F),
      warning: Color(0xFFE1A86C),
      success: Color(0xFF7DBA8F),
      border: Color(0xFF6D5945),
      shadow: Color(0x66000000),
      background: Color(0xFF211915),
      backgroundAccent: Color(0xFF2B211C),
    );

    return _buildTheme(
      palette: palette,
      brightness: Brightness.dark,
      baseTheme: ThemeData.dark(),
    );
  }

  static ThemeData _buildTheme({
    required LabPalette palette,
    required Brightness brightness,
    required ThemeData baseTheme,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.coffee,
      brightness: brightness,
      primary: palette.coffee,
      secondary: palette.accent,
      surface: palette.paper,
      onSurface: palette.ink,
    );
    final textTheme = _labTextTheme(baseTheme.textTheme, palette);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      cardColor: palette.paper,
      dividerColor: palette.border,
      extensions: [palette],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: palette.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: palette.ink,
          letterSpacing: 0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.paperAlt
            .withOpacity(brightness == Brightness.dark ? 0.9 : 0.72),
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? palette.ink
                : palette.inkMuted,
            letterSpacing: 0.8,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? palette.coffee
                : palette.inkMuted,
            size: 24,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: palette.border.withOpacity(0.5)),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: palette.paperAlt.withOpacity(0.35),
        selectedColor: palette.paperAlt.withOpacity(0.7),
        secondarySelectedColor: palette.paperAlt.withOpacity(0.7),
        side: BorderSide(color: palette.border.withOpacity(0.65)),
        labelStyle: textTheme.labelMedium?.copyWith(color: palette.ink),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: palette.paper,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.paper,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: palette.paper,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: palette.coffee,
          foregroundColor:
              brightness == Brightness.dark ? palette.background : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: textTheme.labelLarge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.ink,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? palette.paperAlt.withOpacity(0.82)
            : palette.paper.withOpacity(0.72),
        labelStyle: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.border.withOpacity(0.7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.border.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.coffee, width: 1.6),
        ),
      ),
      sliderTheme: baseTheme.sliderTheme.copyWith(
        activeTrackColor: palette.coffee,
        inactiveTrackColor: palette.paperAlt.withOpacity(0.5),
        thumbColor: palette.coffee,
        overlayColor: palette.coffee.withOpacity(0.16),
        trackHeight: 5,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? palette.paperAlt.withOpacity(0.74)
                : palette.paper.withOpacity(0.18),
          ),
          foregroundColor: WidgetStateProperty.all(palette.ink),
          textStyle: WidgetStateProperty.all(textTheme.labelMedium),
          side: WidgetStateProperty.all(
              BorderSide(color: palette.border.withOpacity(0.7))),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: palette.paper
              .withOpacity(brightness == Brightness.dark ? 0.3 : 0.6),
          foregroundColor: palette.ink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  static TextTheme _labTextTheme(TextTheme base, LabPalette palette) {
    final sansTextTheme = GoogleFonts.notoSansTextTheme(base).apply(
      bodyColor: palette.ink,
      displayColor: palette.ink,
    );

    TextStyle serif(TextStyle? style,
        {double? size, FontWeight? weight, double? spacing}) {
      return GoogleFonts.notoSerif(
        textStyle: style?.copyWith(
          color: palette.ink,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
        ),
      );
    }

    TextStyle mono(TextStyle? style,
        {double? size, FontWeight? weight, double? spacing}) {
      return GoogleFonts.ibmPlexMono(
        textStyle: style?.copyWith(
          color: palette.ink,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
        ),
      );
    }

    return sansTextTheme.copyWith(
      displayLarge: serif(sansTextTheme.displayLarge,
          size: 52, weight: FontWeight.w700, spacing: 0.2),
      displayMedium: serif(sansTextTheme.displayMedium,
          size: 44, weight: FontWeight.w700, spacing: 0.2),
      displaySmall: serif(sansTextTheme.displaySmall,
          size: 36, weight: FontWeight.w700, spacing: 0.2),
      headlineLarge: serif(sansTextTheme.headlineLarge,
          weight: FontWeight.w700, spacing: 0.2),
      headlineMedium: serif(sansTextTheme.headlineMedium,
          weight: FontWeight.w700, spacing: 0.2),
      headlineSmall: serif(sansTextTheme.headlineSmall,
          weight: FontWeight.w700, spacing: 0.2),
      titleLarge: serif(sansTextTheme.titleLarge,
          weight: FontWeight.w700, spacing: 0.3),
      titleMedium: serif(sansTextTheme.titleMedium,
          weight: FontWeight.w700, spacing: 0.25),
      titleSmall: GoogleFonts.notoSans(
        textStyle: sansTextTheme.titleSmall?.copyWith(
          color: palette.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
      labelLarge:
          mono(sansTextTheme.labelLarge, weight: FontWeight.w600, spacing: 0.8),
      labelMedium: mono(sansTextTheme.labelMedium,
          weight: FontWeight.w600, spacing: 1.0),
      labelSmall:
          mono(sansTextTheme.labelSmall, weight: FontWeight.w600, spacing: 0.8),
      bodyLarge: GoogleFonts.notoSans(
          textStyle: sansTextTheme.bodyLarge?.copyWith(height: 1.45)),
      bodyMedium: GoogleFonts.notoSans(
          textStyle: sansTextTheme.bodyMedium?.copyWith(height: 1.45)),
      bodySmall: GoogleFonts.notoSans(
          textStyle: sansTextTheme.bodySmall?.copyWith(height: 1.4)),
    );
  }
}

extension LabPaletteBuildContext on BuildContext {
  LabPalette get palette => Theme.of(this).extension<LabPalette>()!;
}
