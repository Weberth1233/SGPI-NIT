import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_typography.dart';

class MyTheme {

   static final TextTheme _textTheme = TextTheme(
    headlineLarge: ThemeTypography.heading1Text,
    headlineMedium: ThemeTypography.heading2Text,
    headlineSmall: ThemeTypography.heading3Text,
    bodyLarge: ThemeTypography.heading4Text,
    bodyMedium: ThemeTypography.paragraphText ,
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
      );
}