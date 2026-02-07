import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_typography.dart';

class MyTheme {
  static final TextTheme _textTheme = TextTheme(
    headlineLarge: ThemeTypography.heading1Text,
    headlineMedium: ThemeTypography.heading2Text,
    headlineSmall: ThemeTypography.heading3Text,
    bodyLarge: ThemeTypography.heading4Text,
    bodyMedium: ThemeTypography.paragraphText,
    bodySmall: ThemeTypography.smallText,
  );

  static ThemeData get defaultTheme => ThemeData(
    scaffoldBackgroundColor: ThemeColor.primaryColor,
    cardTheme: CardThemeData(color: ThemeColor.primaryColor, elevation: 2),
    colorScheme: const ColorScheme.light(
      primary: ThemeColor.primaryColor,
      secondary: ThemeColor.secondaryColor,
      onSecondary: ThemeColor.colorVariantWhite,
      tertiary: ThemeColor.colorVarianteBlack,
    ),
    textTheme: _textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder( 
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(5),
                          right: Radius.circular(5),
                        ), // 👈 sem arredondamento
                      ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.transparent, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Colors.purple, // ou ThemeColor.secondaryColor
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    ),
  );
}
