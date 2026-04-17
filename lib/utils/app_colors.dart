import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color primaryGreenLight = Color(0xFF2E7D32);
  static const Color primaryGreenMid = Color(0xFF388E3C);
  static const Color primaryGreenAccent = Color(0xFF4CAF50);
  static const Color surfaceGreen = Color(0xFFE8F5E9);

  // Gold Palette
  static const Color gold = Color(0xFFC8960C);
  static const Color goldLight = Color(0xFFFFD54F);
  static const Color goldAccent = Color(0xFFF9A825);
  static const Color goldSurface = Color(0xFFFFF8E1);

  // Neutral
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);

  // Dark Mode
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkElevated = Color(0xFF21262D);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnDark = Color(0xFFF5F5F5);
  static const Color textOnGreen = Color(0xFFFFFFFF);

  // Status
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57F17);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFC8960C), Color(0xFFF9A825), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1A3A1A), Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkHeaderGradient = LinearGradient(
    colors: [Color(0xFF0D1F0D), Color(0xFF1A3A1A), Color(0xFF1B5E20)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
