import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  
  // Primary Brand Colors - Purple Theme
  static const primary = Color(0xFF7C3AED); // Purple 600
  static const primaryLight = Color(0xFF9F67FF);
  static const primaryDark = Color(0xFF5B21B6);
  static const primarySurface = Color(0xFFF3E8FF); // Purple 50
  
  // Secondary Brand Colors - Orange/Amber Theme
  static const secondary = Color(0xFFFF6B35); // Vibrant Orange
  static const secondaryLight = Color(0xFFFF8C42);
  static const secondaryDark = Color(0xFFE85D2C);
  static const secondarySurface = Color(0xFFFFF4E6);
  
  // Accent Colors
  static const accent = Color(0xFF14B8A6); // Teal
  static const accentLight = Color(0xFF2DD4BF);
  static const accentDark = Color(0xFF0F766E);
  static const accentSurface = Color(0xFFCCFBF1);
  
  // Semantic Colors - Success
  static const success = Color(0xFF10B981); // Green 500
  static const successLight = Color(0xFF34D399);
  static const successDark = Color(0xFF059669);
  static const successSurface = Color(0xFFD1FAE5);
  
  // Semantic Colors - Error
  static const error = Color(0xFFEF4444); // Red 500
  static const errorLight = Color(0xFFF87171);
  static const errorDark = Color(0xFFDC2626);
  static const errorSurface = Color(0xFFFEE2E2);
  
  // Semantic Colors - Warning
  static const warning = Color(0xFFF59E0B); // Amber 500
  static const warningLight = Color(0xFFFBBF24);
  static const warningDark = Color(0xFFD97706);
  static const warningSurface = Color(0xFFFEF3C7);
  
  // Semantic Colors - Info
  static const info = Color(0xFF3B82F6); // Blue 500
  static const infoLight = Color(0xFF60A5FA);
  static const infoDark = Color(0xFF2563EB);
  static const infoSurface = Color(0xFFDBEAFE);
  
  // Neutral Grays
  static const gray50 = Color(0xFFFAFAFA);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFE5E5E5);
  static const gray300 = Color(0xFFD4D4D4);
  static const gray400 = Color(0xFFA3A3A3);
  static const gray500 = Color(0xFF737373);
  static const gray600 = Color(0xFF525252);
  static const gray700 = Color(0xFF404040);
  static const gray800 = Color(0xFF262626);
  static const gray900 = Color(0xFF171717);
  
  // Background Colors
  static const background = Color(0xFFFAFAFA);
  static const backgroundDark = Color(0xFF1F1F1F);
  static const surface = white;
  static const surfaceDark = Color(0xFF2C2C2C);
  
  // Text Colors
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textDisabled = Color(0xFFD1D5DB);
  
  // Border Colors
  static const border = Color(0xFFE5E7EB);
  static const borderLight = Color(0xFFF3F4F6);
  static const borderDark = Color(0xFFD1D5DB);
  
  // Gradient Definitions
  static const purpleGradient = LinearGradient(
    colors: [Color(0xFF9F67FF), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const orangeGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const tealGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const successGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const oceanGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
