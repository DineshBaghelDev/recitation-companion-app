import 'package:flutter/material.dart';

/// Design system constants for consistent UI throughout the app
class AppDesignSystem {
  AppDesignSystem._();

  // ============ COLORS ============
  // Saffron/Orange theme inspired by Indian spiritual aesthetics
  static const Color primaryColor = Color(0xFFFF6B35); // Deep saffron orange
  static const Color accentColor = Color(0xFFF7931E); // Warm gold/orange
  static const Color deepOrange = Color(0xFFD84315); // Deep orange for accents
  static const Color lightSaffron = Color(0xFFFFAB91); // Light saffron for backgrounds

  // ============ SPACING ============
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0;

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(20, 16, 20, 70);
  static const EdgeInsets screenPaddingTop = EdgeInsets.fromLTRB(20, 16, 20, 0);

  // ============ BORDER RADIUS ============
  static const double radiusSmall = 16.0;
  static const double radiusMedium = 20.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 28.0;

  // ============ SHADOWS ============
  static List<BoxShadow> cardShadow(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.08),
          blurRadius: 28,
          offset: const Offset(0, 12),
          spreadRadius: -8,
        ),
      ];

  static List<BoxShadow> lightShadow(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -6,
        ),
      ];

  // ============ TYPOGRAPHY HELPERS ============
  static TextStyle heading(TextTheme textTheme) =>
      textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
      ) ??
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w800);

  static TextStyle subheading(TextTheme textTheme) =>
      textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ) ??
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  static TextStyle body(TextTheme textTheme, Color color) =>
      textTheme.bodyMedium?.copyWith(
        color: color,
      ) ??
      TextStyle(fontSize: 14, color: color);

  static TextStyle bodyBold(TextTheme textTheme) =>
      textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ) ??
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle caption(TextTheme textTheme, Color color) =>
      textTheme.bodySmall?.copyWith(
        color: color,
      ) ??
      TextStyle(fontSize: 12, color: color);

  static TextStyle valueText(TextTheme textTheme) =>
      textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
      ) ??
      const TextStyle(fontSize: 22, fontWeight: FontWeight.w800);

  static TextStyle largeValue(TextTheme textTheme) =>
      textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ) ??
      const TextStyle(fontSize: 28, fontWeight: FontWeight.w800);

  // ============ CARD DECORATIONS ============
  static BoxDecoration cardDecoration(ColorScheme colorScheme) => BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radiusXLarge),
        boxShadow: cardShadow(Colors.black),
      );

  static BoxDecoration lightCardDecoration(ColorScheme colorScheme) =>
      BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radiusLarge),
        boxShadow: lightShadow(Colors.black),
      );

  // ============ BUTTON STYLES ============
  static ButtonStyle primaryButtonStyle() => FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
        backgroundColor: const Color.fromRGBO(96, 122, 251, 1)
      );
}
