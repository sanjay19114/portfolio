import 'package:flutter/material.dart';

/// Theme constants for the portfolio based on Shubharambham Event Planners theme
class ThemeConstants {
  // Primary brand colors from Shubharambham Event Planners
  static const primaryPurple = Color(0xFF5A1782); // Main purple
  static const primaryGold = Color(0xFFD4B565); // Gold accent
  static const accentBlue = Color(0xFF3D85C6); // Blue accent
  
  // Section background colors - darker aesthetic
  static const heroSectionGradient = [
    Color(0xFF0F0217), // Near black
    Color(0xFF1A0329), // Very dark purple
  ];
  
  static const aboutSectionGradient = [
    Color(0xFF0A0114), // Deep dark
    Color(0xFF150422), // Very dark purple
  ];
  
  static const skillsSectionGradient = [
    Color(0xFF0C0118), // Dark purple-black
    Color(0xFF130320), // Dark purple
  ];
  
  static const projectsSectionGradient = [
    Color(0xFF0F0217), // Near black
    Color(0xFF1C0530), // Dark purple
  ];
  
  static const experienceSectionGradient = [
    Color(0xFF120219), // Dark purple
    Color(0xFF0A0114), // Deep dark
  ];
  
  static const contactSectionGradient = [
    Color(0xFF0F0217), // Near black
    Color(0xFF0A0114), // Deep dark
  ];
  
  // Accent colors
  static const accentPrimary = Color(0xFFD4B565); // Gold
  static const accentSecondary = Color(0xFF3D85C6); // Blue
  static const accentTertiary = Color(0xFFE8D4A9); // Light gold
  
  // Text colors
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFCCD6F6);
  static const textTertiary = Color(0xFF8892B0);
  
  // Card colors - darker aesthetic
  static const cardBackground = Color(0xFF0E0E15);
  static const cardBorder = Color(0xFF1A0329);
  
  // Button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentPrimary,
    foregroundColor: Color(0xFF0A192F),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: accentPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
      side: BorderSide(color: accentPrimary),
    ),
  );
  
  // Animation durations
  static const fastAnimation = Duration(milliseconds: 300);
  static const mediumAnimation = Duration(milliseconds: 600);
  static const slowAnimation = Duration(milliseconds: 1000);
  
  // Curves
  static const fastCurve = Curves.easeOut;
  static const mediumCurve = Curves.easeInOut;
  static const slowCurve = Curves.elasticOut;
}
