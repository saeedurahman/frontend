import 'package:flutter/material.dart';

/// Pakistani-themed palette for Frantend POS.
abstract final class AppColors {
  // Primary — Pakistan green
  static const Color primary = Color(0xFF0F6B36);
  static const Color branchColor = Color(0xFF91F9A6);
  static const Color primaryDark = Color(0xFF0A4F28);
  static const Color primaryLight = Color(0xFF1A8A4A);

  // Accent — gold
  static const Color accent = Color(0xFFE8C547);
  static const Color accentDark = Color(0xFFC9A832);
  static const Color accentLight = Color.fromARGB(255, 240, 234, 123);

  // Login screen
  static const Color loginBackground = Color(0xFFF8F9FF);
  static const Color inputFill = Color(0xFFEFF3FF);
  static const Color brandingPanel = Color(0xFF004D26);

  // Neutrals
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E2832);
  static const Color border = Color(0xFFE2E8F0);

  // Text
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFDD6B20);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);

  // Offline indicator
  static const Color offline = Color(0xFFE53E3E);
  static const Color online = Color(0xFF38A169);
}
