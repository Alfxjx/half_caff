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
    required this.grain,
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
  final Color grain;

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
    Color? grain,
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
      grain: grain ?? this.grain,
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
      grain: Color.lerp(grain, other.grain, t)!,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    const palette = LabPalette(
      paper: Color(0xFFFAF6F0),
      paperAlt: Color(0xFFF0EBE3),
      ink: Color(0xFF3D3229),
      inkMuted: Color(0xFF8A7E72),
      coffee: Color(0xFF7B5E3F),
      accent: Color(0xFFB8A88A),
      warning: Color(0xFFC4956A),
      success: Color(0xFF7A9E7E),
      border: Color(0xFFE0D8CE),
      shadow: Color(0x263D3229),
      background: Color(0xFFF5F0E8),
      backgroundAccent: Color(0xFFEDE8DE),
      grain: Color(0x0D3D3229),
    );

    return _buildTheme(
      palette: palette,
      brightness: Brightness.light,
      baseTheme: ThemeData.light(),
    );
  }

  static ThemeData dark() {
    const palette = LabPalette(
      paper: Color(0xFF2C2520),
      paperAlt: Color(0xFF3A322B),
      ink: Color(0xFFF0E6D6),
      inkMuted: Color(0xFFA89E90),
      coffee: Color(0xFFC4A882),
      accent: Color(0xFFD4C4A8),
      warning: Color(0xFFD4A882),
      success: Color(0xFF8BAE8E),
      border: Color(0xFF4A4038),
      shadow: Color(0x660A0806),
      background: Color(0xFF1C1814),
      backgroundAccent: Color(0xFF242018),
      grain: Color(0x0DF0E6D2),
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
          letterSpacing: -0.2,
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
            letterSpacing: 0.6,
            fontFeatures: const [FontFeature.tabularFigures()],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? palette.coffee.withOpacity(0.85)
                : palette.coffee,
          ),
          foregroundColor: WidgetStateProperty.all(
            brightness == Brightness.dark ? palette.background : Colors.white,
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          textStyle: WidgetStateProperty.all(textTheme.labelLarge),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? Colors.black.withOpacity(0.12)
                : Colors.transparent,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.ink,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? palette.paperAlt.withOpacity(0.82)
            : palette.paper.withOpacity(0.72),
        labelStyle: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.border.withOpacity(0.7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.border.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.coffee, width: 1.6),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      sliderTheme: baseTheme.sliderTheme.copyWith(
        activeTrackColor: palette.coffee,
        inactiveTrackColor: palette.paperAlt.withOpacity(0.5),
        thumbColor: palette.coffee,
        overlayColor: palette.coffee.withOpacity(0.16),
        trackHeight: 5,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 2,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? palette.paperAlt.withOpacity(0.74)
                : palette.paper.withOpacity(0.18),
          ),
          foregroundColor: WidgetStateProperty.all(palette.ink),
          textStyle: WidgetStateProperty.all(textTheme.labelMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          )),
          side: WidgetStateProperty.all(
              BorderSide(color: palette.border.withOpacity(0.7))),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: palette.paper
              .withOpacity(brightness == Brightness.dark ? 0.3 : 0.6),
          foregroundColor: palette.ink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? palette.ink.withOpacity(0.08)
                : Colors.transparent,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(palette.border),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.coffee
              : palette.inkMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.coffee.withOpacity(0.35)
              : palette.paperAlt,
        ),
      ),
    );
  }

  static TextTheme _labTextTheme(TextTheme base, LabPalette palette) {
    final sansTextTheme = GoogleFonts.notoSansTextTheme(base).apply(
      bodyColor: palette.ink,
      displayColor: palette.ink,
    );

    TextStyle sans(TextStyle? style,
        {double? size, FontWeight? weight, double? spacing}) {
      return GoogleFonts.notoSans(
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
          fontFeatures: const [
            FontFeature.tabularFigures(),
          ],
        ),
      );
    }

    return sansTextTheme.copyWith(
      displayLarge: sans(sansTextTheme.displayLarge,
          size: 56, weight: FontWeight.w800, spacing: -1.0),
      displayMedium: sans(sansTextTheme.displayMedium,
          size: 48, weight: FontWeight.w800, spacing: -0.8),
      displaySmall: sans(sansTextTheme.displaySmall,
          size: 40, weight: FontWeight.w700, spacing: -0.5),
      headlineLarge: sans(sansTextTheme.headlineLarge,
          weight: FontWeight.w700, spacing: -0.4),
      headlineMedium: sans(sansTextTheme.headlineMedium,
          weight: FontWeight.w700, spacing: -0.3),
      headlineSmall: sans(sansTextTheme.headlineSmall,
          weight: FontWeight.w700, spacing: -0.2),
      titleLarge: sans(sansTextTheme.titleLarge,
          weight: FontWeight.w700, spacing: 0),
      titleMedium: sans(sansTextTheme.titleMedium,
          weight: FontWeight.w700, spacing: -0.1),
      titleSmall: GoogleFonts.notoSans(
        textStyle: sansTextTheme.titleSmall?.copyWith(
          color: palette.ink,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
        ),
      ),
      labelLarge:
          mono(sansTextTheme.labelLarge, weight: FontWeight.w600, spacing: 0.6),
      labelMedium: mono(sansTextTheme.labelMedium,
          weight: FontWeight.w600, spacing: 0.8),
      labelSmall:
          mono(sansTextTheme.labelSmall, weight: FontWeight.w600, spacing: 0.6),
      bodyLarge: GoogleFonts.notoSans(
        textStyle: sansTextTheme.bodyLarge?.copyWith(
          height: 1.55,
          fontSize: 16,
        ),
      ),
      bodyMedium: GoogleFonts.notoSans(
        textStyle: sansTextTheme.bodyMedium?.copyWith(
          height: 1.55,
          fontSize: 14,
        ),
      ),
      bodySmall: GoogleFonts.notoSans(
        textStyle: sansTextTheme.bodySmall?.copyWith(
          height: 1.45,
          fontSize: 12,
        ),
      ),
    );
  }
}

extension LabPaletteBuildContext on BuildContext {
  LabPalette get palette => Theme.of(this).extension<LabPalette>()!;
}
