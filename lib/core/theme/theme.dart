import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Colors.black;
final mainTheme = ThemeData(
  // colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, ),
  primaryColor: primaryColor,
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: primaryColor,
  ),

  // useMaterial3: true,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.geologica(fontSize: 24, fontWeight: FontWeight.w300),
    bodyMedium:
        GoogleFonts.geologica(fontSize: 16, fontWeight: FontWeight.w400),
    headlineLarge:
        GoogleFonts.geologica(fontSize: 30, fontWeight: FontWeight.w500),
  ),
);
