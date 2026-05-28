// 🌸 Palette + styles Sister Space — fidèle à la maquette
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const rose = Color(0xFFE879A9);
  static const roseFonce = Color(0xFFC84A82);
  static const roseClair = Color(0xFFFCE7F0);
  static const roseBg = Color(0xFFFDF2F8);
  static const blanc = Color(0xFFFFFFFF);
  static const texte = Color(0xFF2E2A2C);
  static const texteDoux = Color(0xFF9C8A92);
  static const bordure = Color(0xFFF3D6E4);
  static const erreur = Color(0xFFE25563);
  static const succes = Color(0xFF34C77B);

  // Dégradés d'avatars (comme la maquette : orange→rose, rose→fuchsia)
  static const avatarGrads = [
    [Color(0xFFFFB088), Color(0xFFE879A9)], // pêche → rose
    [Color(0xFFF891B5), Color(0xFFC84A82)], // rose → fuchsia
    [Color(0xFFFFA8C5), Color(0xFFE25590)], // rose clair → rose
    [Color(0xFFFFC8A8), Color(0xFFE879A9)], // abricot → rose
  ];

  // Dégradés pastel pour cartes Explore
  static const catGrads = [
    [Color(0xFFFFD6E0), Color(0xFFFFE8C9)], // rose → pêche
    [Color(0xFFF5D5F0), Color(0xFFFCE0EC)], // lilas → rose
    [Color(0xFFFFE0CC), Color(0xFFFFD6E5)], // pêche → rose
    [Color(0xFFFFD9E2), Color(0xFFFFE5D0)], // rose → crème
    [Color(0xFFFFE8CC), Color(0xFFFFD0DC)], // crème → rose
    [Color(0xFFFADCF0), Color(0xFFFFE0D5)], // mauve → pêche
  ];

  // Couleurs pastel unies (chips, avatars de fallback)
  static const catRose = Color(0xFFFFC8DD);
  static const catBleu = Color(0xFFBDE0FE);
  static const catVert = Color(0xFFC8F2E0);
  static const catJaune = Color(0xFFFFE6B5);
  static const catViolet = Color(0xFFE0C8F0);
  static const catOrange = Color(0xFFFFD5B5);
}

// 🎀 Styles de texte avec Playfair (titres) + Inter (corps)
class AppText {
  static TextStyle titre(double size, {Color? color, FontWeight? w}) =>
      GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: w ?? FontWeight.w700,
        color: color ?? AppColors.texte,
      );

  static TextStyle titreItalic(double size, {Color? color}) =>
      GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        color: color ?? AppColors.rose,
      );

  static TextStyle corps(double size, {Color? color, FontWeight? w}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: w ?? FontWeight.w400,
        color: color ?? AppColors.texte,
      );
}
