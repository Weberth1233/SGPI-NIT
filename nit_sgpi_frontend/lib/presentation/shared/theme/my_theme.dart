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
      primary: ThemeColor.primaryColor ,
      secondary: ThemeColor.secondaryColor,
      onSecondary: ThemeColor.colorVariantWhite,
      tertiary: ThemeColor.colorVarianteBlack,
      onSurface: ThemeColor.greyColor
    ),
    iconTheme: IconThemeData(color: ThemeColor.iconColor, size: 40),
    textTheme: _textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColor.primaryColor,
        shape: const RoundedRectangleBorder( 
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(5),
                          right: Radius.circular(5),
                        ), // 👈 sem arredondamento
                      ),
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(ThemeColor.primaryColor), // cor da "alça" do scroll
      trackColor: WidgetStateProperty.all(ThemeColor.greyColor), // fundo da barra
      trackBorderColor: WidgetStateProperty.all(ThemeColor.greyColor),
      thickness: WidgetStateProperty.all(8), // espessura
      radius: const Radius.circular(10), // bordas arredondadas
      thumbVisibility: WidgetStateProperty.all(true), // sempre visível (opcional)
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: const TextStyle(color: ThemeColor.secondaryColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.transparent, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: ThemeColor.primaryColor, // ou ThemeColor.secondaryColor
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
