import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';

class ThemeTypography {
  
  static final TextStyle heading1Text = GoogleFonts.montserrat(
    textStyle:  TextStyle(
        color:ThemeColor.colorVarianteBlack, letterSpacing: .5, fontSize: 48),
  );

  static final TextStyle heading2Text = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        color:ThemeColor.colorVarianteBlack , letterSpacing: .5, fontSize: 40),
  );

  static final TextStyle heading3Text = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        color: ThemeColor.colorVarianteBlack, letterSpacing: .5, fontSize: 33),
  );

  static final TextStyle heading4Text = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        color: ThemeColor.colorVarianteBlack, letterSpacing: .5, fontSize: 28),
  );

  static final TextStyle paragraphText = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        color: ThemeColor.colorVariantWhite, letterSpacing: .5, fontSize: 15),
  );

  static final TextStyle smallText = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        color: ThemeColor.colorVariantWhite, letterSpacing: .5, fontSize: 12),
  );

}