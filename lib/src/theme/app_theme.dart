import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class ClaudePalette extends ThemeExtension<ClaudePalette> {
  const ClaudePalette({
    required this.canvas,
    required this.paperAlt,
    required this.ink,
    required this.body,
    required this.bodyStrong,
    required this.muted,
    required this.mutedSoft,
    required this.hairline,
    required this.hairlineSoft,
    required this.surfaceCard,
    required this.surfaceCreamStrong,
    required this.surfaceDark,
    required this.surfaceDarkElevated,
    required this.surfaceDarkSoft,
    required this.primary,
    required this.primaryActive,
    required this.primaryDisabled,
    required this.onPrimary,
    required this.onDark,
    required this.onDarkSoft,
    required this.accentTeal,
    required this.accentAmber,
    required this.success,
    required this.warning,
    required this.error,
    required this.shadow,
  });

  // Canvas & Surface
  final Color canvas;
  final Color paperAlt;
  final Color surfaceCard;
  final Color surfaceCreamStrong;

  // Ink / Text
  final Color ink;
  final Color body;
  final Color bodyStrong;
  final Color muted;
  final Color mutedSoft;

  // Borders
  final Color hairline;
  final Color hairlineSoft;

  // Dark Surface
  final Color surfaceDark;
  final Color surfaceDarkElevated;
  final Color surfaceDarkSoft;

  // Primary / Coral
  final Color primary;
  final Color primaryActive;
  final Color primaryDisabled;
  final Color onPrimary;

  // On Dark
  final Color onDark;
  final Color onDarkSoft;

  // Accents
  final Color accentTeal;
  final Color accentAmber;

  // Semantic
  final Color success;
  final Color warning;
  final Color error;

  // Shadow
  final Color shadow;

  @override
  ClaudePalette copyWith({
    Color? canvas,
    Color? paperAlt,
    Color? ink,
    Color? body,
    Color? bodyStrong,
    Color? muted,
    Color? mutedSoft,
    Color? hairline,
    Color? hairlineSoft,
    Color? surfaceCard,
    Color? surfaceCreamStrong,
    Color? surfaceDark,
    Color? surfaceDarkElevated,
    Color? surfaceDarkSoft,
    Color? primary,
    Color? primaryActive,
    Color? primaryDisabled,
    Color? onPrimary,
    Color? onDark,
    Color? onDarkSoft,
    Color? accentTeal,
    Color? accentAmber,
    Color? success,
    Color? warning,
    Color? error,
    Color? shadow,
  }) {
    return ClaudePalette(
      canvas: canvas ?? this.canvas,
      paperAlt: paperAlt ?? this.paperAlt,
      ink: ink ?? this.ink,
      body: body ?? this.body,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      muted: muted ?? this.muted,
      mutedSoft: mutedSoft ?? this.mutedSoft,
      hairline: hairline ?? this.hairline,
      hairlineSoft: hairlineSoft ?? this.hairlineSoft,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceCreamStrong: surfaceCreamStrong ?? this.surfaceCreamStrong,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceDarkElevated: surfaceDarkElevated ?? this.surfaceDarkElevated,
      surfaceDarkSoft: surfaceDarkSoft ?? this.surfaceDarkSoft,
      primary: primary ?? this.primary,
      primaryActive: primaryActive ?? this.primaryActive,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      onPrimary: onPrimary ?? this.onPrimary,
      onDark: onDark ?? this.onDark,
      onDarkSoft: onDarkSoft ?? this.onDarkSoft,
      accentTeal: accentTeal ?? this.accentTeal,
      accentAmber: accentAmber ?? this.accentAmber,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ClaudePalette lerp(ThemeExtension<ClaudePalette>? other, double t) {
    if (other is! ClaudePalette) return this;
    return ClaudePalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      paperAlt: Color.lerp(paperAlt, other.paperAlt, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      body: Color.lerp(body, other.body, t)!,
      bodyStrong: Color.lerp(bodyStrong, other.bodyStrong, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedSoft: Color.lerp(mutedSoft, other.mutedSoft, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairlineSoft: Color.lerp(hairlineSoft, other.hairlineSoft, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceCreamStrong:
          Color.lerp(surfaceCreamStrong, other.surfaceCreamStrong, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceDarkElevated:
          Color.lerp(surfaceDarkElevated, other.surfaceDarkElevated, t)!,
      surfaceDarkSoft:
          Color.lerp(surfaceDarkSoft, other.surfaceDarkSoft, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryActive: Color.lerp(primaryActive, other.primaryActive, t)!,
      primaryDisabled:
          Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onDark: Color.lerp(onDark, other.onDark, t)!,
      onDarkSoft: Color.lerp(onDarkSoft, other.onDarkSoft, t)!,
      accentTeal: Color.lerp(accentTeal, other.accentTeal, t)!,
      accentAmber: Color.lerp(accentAmber, other.accentAmber, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

class AppTheme {
  // Light palette — warm cream canvas + coral + dark navy surfaces
  static const _light = ClaudePalette(
    canvas: Color(0xFFFAF9F5),
    paperAlt: Color(0xFFF5F0E8),
    ink: Color(0xFF141413),
    body: Color(0xFF3D3D3A),
    bodyStrong: Color(0xFF252523),
    muted: Color(0xFF6C6A64),
    mutedSoft: Color(0xFF8E8B82),
    hairline: Color(0xFFE6DFD8),
    hairlineSoft: Color(0xFFEBE6DF),
    surfaceCard: Color(0xFFEFE9DE),
    surfaceCreamStrong: Color(0xFFE8E0D2),
    surfaceDark: Color(0xFF181715),
    surfaceDarkElevated: Color(0xFF252320),
    surfaceDarkSoft: Color(0xFF1F1E1B),
    primary: Color(0xFFCC785C),
    primaryActive: Color(0xFFA9583E),
    primaryDisabled: Color(0xFFE6DFD8),
    onPrimary: Color(0xFFFFFFFF),
    onDark: Color(0xFFFAF9F5),
    onDarkSoft: Color(0xFFA09D96),
    accentTeal: Color(0xFF5DB8A6),
    accentAmber: Color(0xFFE8A55A),
    success: Color(0xFF5DB872),
    warning: Color(0xFFD4A017),
    error: Color(0xFFC64545),
    shadow: Color(0x14000000),
  );

  // Dark palette — dark navy base with warm cream text
  static const _dark = ClaudePalette(
    canvas: Color(0xFF1C1A18),
    paperAlt: Color(0xFF252320),
    ink: Color(0xFFF0EBE3),
    body: Color(0xFFB8B2A8),
    bodyStrong: Color(0xFFD4CEC4),
    muted: Color(0xFF8A847A),
    mutedSoft: Color(0xFF6A645C),
    hairline: Color(0xFF3A3630),
    hairlineSoft: Color(0xFF2E2A26),
    surfaceCard: Color(0xFF2A2620),
    surfaceCreamStrong: Color(0xFF32302A),
    surfaceDark: Color(0xFF141210),
    surfaceDarkElevated: Color(0xFF1E1C18),
    surfaceDarkSoft: Color(0xFF181614),
    primary: Color(0xFFCC785C),
    primaryActive: Color(0xFFB86848),
    primaryDisabled: Color(0xFF3A3630),
    onPrimary: Color(0xFFFFFFFF),
    onDark: Color(0xFFFAF9F5),
    onDarkSoft: Color(0xFF8A847A),
    accentTeal: Color(0xFF5DB8A6),
    accentAmber: Color(0xFFE8A55A),
    success: Color(0xFF5DB872),
    warning: Color(0xFFD4A017),
    error: Color(0xFFC64545),
    shadow: Color(0x40000000),
  );

  static ThemeData light() => _build(_light, Brightness.light);
  static ThemeData dark() => _build(_dark, Brightness.dark);

  static ThemeData _build(ClaudePalette p, Brightness brightness) {
    final base = ThemeData(brightness: brightness);
    final textTheme = _buildTextTheme(p, brightness);

    return base.copyWith(
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: p.primary,
        onPrimary: p.onPrimary,
        primaryContainer: p.surfaceCard,
        onPrimaryContainer: p.ink,
        secondary: p.accentTeal,
        onSecondary: p.onDark,
        secondaryContainer: p.surfaceDarkElevated,
        onSecondaryContainer: p.onDark,
        tertiary: p.accentAmber,
        onTertiary: p.ink,
        tertiaryContainer: p.surfaceCreamStrong,
        onTertiaryContainer: p.ink,
        surface: p.canvas,
        onSurface: p.ink,
        surfaceContainerHighest: p.paperAlt,
        onSurfaceVariant: p.muted,
        error: p.error,
        onError: p.onPrimary,
        outline: p.hairline,
        outlineVariant: p.hairlineSoft,
      ),
      scaffoldBackgroundColor: p.canvas,
      cardColor: p.surfaceCard,
      dividerColor: p.hairline,
      extensions: [p],
      textTheme: textTheme,
      // -------------------------------------------------------------------
      // AppBar — cream nav bar, no elevation
      // -------------------------------------------------------------------
      appBarTheme: AppBarTheme(
        backgroundColor: p.canvas,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: p.ink,
          fontWeight: FontWeight.w600,
        )),
      // -------------------------------------------------------------------
      // NavigationBar — bottom tab bar, cream surface
      // -------------------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        indicatorColor: p.surfaceCard,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: selected ? p.ink : p.muted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontFeatures: const [FontFeature.tabularFigures()],
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? p.primary : p.muted,
            size: 24,
          );
        }),
      ),
      // -------------------------------------------------------------------
      // Cards — feature-card style, no shadow, hairline border
      // -------------------------------------------------------------------
      cardTheme: CardTheme(
        color: p.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.hairline.withOpacity(0.6)),
        ),
      ),
      // -------------------------------------------------------------------
      // Buttons — primary (coral), secondary (cream), text-link
      // -------------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return p.primaryDisabled;
            if (states.contains(WidgetState.pressed)) return p.primaryActive;
            return p.primary;
          }),
          foregroundColor: WidgetStateProperty.all(p.onPrimary),
          textStyle: WidgetStateProperty.all(textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          )),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          minimumSize: WidgetStateProperty.all(const Size(0, 40)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(p.canvas),
          foregroundColor: WidgetStateProperty.all(p.ink),
          textStyle: WidgetStateProperty.all(textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          )),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          minimumSize: WidgetStateProperty.all(const Size(0, 40)),
          side: WidgetStateProperty.all(
            BorderSide(color: p.hairline),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: p.surfaceCard,
          foregroundColor: p.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(36, 36),
        ),
      ),
      // -------------------------------------------------------------------
      // Inputs — text-input style per design system
      // -------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? p.paperAlt.withOpacity(0.5)
            : p.canvas,
        labelStyle: textTheme.bodyMedium?.copyWith(color: p.muted),
        hintStyle: textTheme.bodyMedium?.copyWith(color: p.mutedSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.hairline.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      // -------------------------------------------------------------------
      // Slider
      // -------------------------------------------------------------------
      sliderTheme: SliderThemeData(
        activeTrackColor: p.primary,
        inactiveTrackColor: p.hairline,
        thumbColor: p.primary,
        overlayColor: p.primary.withOpacity(0.12),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      // -------------------------------------------------------------------
      // SegmentedButton — category-tab style
      // -------------------------------------------------------------------
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return p.surfaceCard;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return p.ink;
            return p.muted;
          }),
          textStyle: WidgetStateProperty.all(textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          )),
          side: WidgetStateProperty.all(
            BorderSide(color: p.hairline.withOpacity(0.7)),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
      // -------------------------------------------------------------------
      // Chip — badge-pill style
      // -------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceCard,
        selectedColor: p.surfaceCreamStrong,
        labelStyle: textTheme.labelMedium?.copyWith(color: p.ink),
        side: BorderSide(color: p.hairline.withOpacity(0.6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      // -------------------------------------------------------------------
      // Dialog / BottomSheet — cream surface
      // -------------------------------------------------------------------
      dialogTheme: DialogTheme(
        backgroundColor: p.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: p.ink),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.body),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      // -------------------------------------------------------------------
      // ListTile
      // -------------------------------------------------------------------
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      // -------------------------------------------------------------------
      // Switch
      // -------------------------------------------------------------------
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.primary;
          return p.mutedSoft;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return p.primary.withOpacity(0.3);
          }
          return p.hairline;
        }),
      ),
    );
  }

  static TextTheme _buildTextTheme(ClaudePalette p, Brightness brightness) {
    // Use Inter for body / UI labels (StyreneB substitute)
    final inter = GoogleFonts.interTextTheme().apply(
      bodyColor: p.body,
      displayColor: p.ink,
    );

    // Use Cormorant Garamond for display headlines
    // (Copernicus/Tiempos aren't available as web fonts)
    final serif = GoogleFonts.cormorantTextTheme().apply(
      bodyColor: p.ink,
      displayColor: p.ink,
    );

    TextStyle display(
      TextStyle? base, {
      required double size,
      double letterSpacing = 0,
      FontWeight weight = FontWeight.w400,
      double height = 1.1,
    }) {
      return base!.copyWith(
        fontFamily: 'Cormorant Garamond, serif',
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        color: p.ink,
      );
    }

    TextStyle sans(
      TextStyle? base, {
      double? size,
      FontWeight? weight,
      double letterSpacing = 0,
      double? height,
      Color? color,
    }) {
      return GoogleFonts.inter(
        textStyle: (base ?? inter.bodyMedium)?.copyWith(
          fontSize: size,
          fontWeight: weight,
          letterSpacing: letterSpacing,
          height: height,
          color: color ?? p.body,
        ),
      );
    }

    return TextTheme(
      // Display — serif, weight 400, negative tracking
      displayLarge: display(serif.displayLarge, size: 64, letterSpacing: -1.5, height: 1.05),
      displayMedium: display(serif.displayMedium, size: 48, letterSpacing: -1.0, height: 1.1),
      displaySmall: display(serif.displaySmall, size: 36, letterSpacing: -0.5, height: 1.15),
      headlineLarge: display(serif.headlineLarge, size: 32, letterSpacing: -0.4, height: 1.15),
      headlineMedium: display(serif.headlineMedium, size: 28, letterSpacing: -0.3, height: 1.2),
      headlineSmall: display(serif.headlineSmall, size: 24, letterSpacing: -0.2, height: 1.25),
      // Title — Inter, weight 500
      titleLarge: sans(inter.titleLarge, size: 22, weight: FontWeight.w600, height: 1.3),
      titleMedium: sans(inter.titleMedium, size: 18, weight: FontWeight.w600, height: 1.4),
      titleSmall: sans(inter.titleSmall, size: 16, weight: FontWeight.w600, height: 1.4, letterSpacing: 0.05),
      // Body — Inter, weight 400
      bodyLarge: sans(inter.bodyLarge, size: 16, height: 1.55),
      bodyMedium: sans(inter.bodyMedium, size: 14, height: 1.55),
      bodySmall: sans(inter.bodySmall, size: 13, height: 1.5),
      // Label — Inter, weight 500/600
      labelLarge: sans(inter.labelLarge, size: 14, weight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: sans(inter.labelMedium, size: 13, weight: FontWeight.w600, letterSpacing: 0.5),
      labelSmall: sans(inter.labelSmall, size: 12, weight: FontWeight.w600, letterSpacing: 0.5),
    );
  }
}

extension ClaudePaletteBuildContext on BuildContext {
  ClaudePalette get palette => Theme.of(this).extension<ClaudePalette>()!;
}