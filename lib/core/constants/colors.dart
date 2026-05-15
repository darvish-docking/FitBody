import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const light = LightColors();
  static const dark = DarkColors();
}

abstract class AppColorScheme {
  Color get primary;
  Color get secondary;
  Color get tertiary;
  Color get button;
  Color get background;
  Color get surface;
  Color get error;
  Color get onPrimary;
  Color get onSecondary;
  Color get onBackground;
  Color get onSurface;
  Color get onError;
  Color get textPrimary;
  Color get textSecondary;
  Color get cardBackground;
  Color get divider;
  Color get success;
  Color get warning;
  Color get info;
  Color get scaffoldBackground;
  Color get bottomNavBackground;
  Color get bottomNavSelected;
  Color get bottomNavUnselected;
  Color get inputBorder;
  Color get inputFill;
  Color get chipBackground;
  Color get chipSelectedBackground;
  Color get chipText;
  Color get chipSelectedText;
  Color get splashBackground;
}

class LightColors implements AppColorScheme {
  const LightColors();

  @override
  Color get primary => const Color(0xFFB3A0FF); // figma color
  @override
  Color get secondary => const Color(0xFFE2F163); // figma color
  @override
  Color get tertiary => const Color(0xFF896CFE); // figma color
  @override
  Color get button => const Color(0xFF000000);   // figma color
@override
  Color get background => const Color(0xFFF5F5F5);
  
  @override
  Color get surface => Colors.white;
  @override
  Color get error => const Color(0xFFB00020);
  @override
  Color get onPrimary => Colors.white;
  @override
  Color get onSecondary => Colors.black;
  @override
  Color get onBackground => const Color(0xFF1D1D1D);
  @override
  Color get onSurface => const Color(0xFF1D1D1D);
  @override
  Color get onError => Colors.white;
  @override
  Color get textPrimary => const Color(0xFF1D1D1D);
  @override
  Color get textSecondary => const Color(0xFF757575);
  @override
  Color get cardBackground => Colors.white;
  @override
  Color get divider => const Color(0xFFE0E0E0);
  @override
  Color get success => const Color(0xFF4CAF50);
  @override
  Color get warning => const Color(0xFFFFC107);
  @override
  Color get info => const Color(0xFF2196F3);
  @override
  Color get scaffoldBackground => const Color(0xFFF5F5F5);
  @override
  Color get bottomNavBackground => Colors.white;
  @override
  Color get bottomNavSelected => const Color(0xFF6C63FF);
  @override
  Color get bottomNavUnselected => const Color(0xFF9E9E9E);
  @override
  Color get inputBorder => const Color(0xFFE0E0E0);
  @override
  Color get inputFill => const Color(0xFFF5F5F5);
  @override
  Color get chipBackground => const Color(0xFFEEEEEE);
  @override
  Color get chipSelectedBackground => const Color(0xFF6C63FF);
  @override
  Color get chipText => const Color(0xFF616161);
  @override
  Color get chipSelectedText => Colors.white;
  @override
  Color get splashBackground => Colors.white;
}

class DarkColors implements AppColorScheme {
  const DarkColors();

  @override
  Color get primary => const Color(0xFFB3A0FF); // figma color
  @override
  Color get secondary => const Color(0xFFE2F163); // figma color
  @override
  Color get tertiary => const Color(0xFF896CFE); // figma color
  @override
  Color get background => const Color(0xFF121212);
  @override
  Color get surface => Color(0xFF232323); // figma color
  @override
  Color get button => const Color(0xFF000000);   // figma color
  @override
  Color get error => const Color(0xFFB00020);
  @override
  Color get onPrimary => Colors.white;
  @override
  Color get onSecondary => Colors.black;
  @override
  Color get onBackground => Colors.white;
  @override
  Color get onSurface => Colors.white;
  @override
  Color get onError => Colors.black;
  @override
  Color get textPrimary => Colors.white;
  @override
  Color get textSecondary => const Color(0xFFB0B0B0);
  @override
  Color get cardBackground => const Color(0xFF1E1E1E);
  @override
  Color get divider => const Color(0xFF2C2C2C);
  @override
  Color get success => const Color(0xFF81C784);
  @override
  Color get warning => const Color(0xFFFFD54F);
  @override
  Color get info => const Color(0xFF64B5F6);
  @override
  Color get scaffoldBackground => const Color(0xFF121212);
  @override
  Color get bottomNavBackground => const Color(0xFF1E1E1E);
  @override
  Color get bottomNavSelected => const Color(0xFF6C63FF);
  @override
  Color get bottomNavUnselected => const Color(0xFF757575);
  @override
  Color get inputBorder => const Color(0xFF2C2C2C);
  @override
  Color get inputFill => const Color(0xFF1E1E1E);
  @override
  Color get chipBackground => const Color(0xFF2C2C2C);
  @override
  Color get chipSelectedBackground => const Color(0xFF6C63FF);
  @override
  Color get chipText => const Color(0xFFB0B0B0);
  @override
  Color get chipSelectedText => Colors.white;
  @override
  Color get splashBackground => const Color(0xFF121212);
}
