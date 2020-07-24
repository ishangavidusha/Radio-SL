import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static final backgroundColor = Color(0xFFF3F7FB);
  static final mainTextColor = Color(0xFF313233);
  static final secoundTextColor = Color(0xFF454647);
  static final linearGradient =
      LinearGradient(colors: [Color(0xFF1D73FF), Color(0xFF438AFE)]);
  static final mainTextstyle = GoogleFonts.robotoSlab(
        fontSize: 26, 
        fontWeight: FontWeight.bold,
        color: mainTextColor
      );
}
