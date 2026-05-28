// 🌸 Avatar rond avec dégradé (comme la maquette)
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AvatarGradient extends StatelessWidget {
  final String texte; // initiale ou lettre
  final double taille;
  final int seed; // pour varier les couleurs
  final String? imageUrl;
  const AvatarGradient({
    super.key,
    required this.texte,
    this.taille = 44,
    this.seed = 0,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final grad = AppColors.avatarGrads[seed % AppColors.avatarGrads.length];
    return Container(
      width: taille,
      height: taille,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? null
          : Center(
              child: Text(
                texte.isNotEmpty ? texte[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: taille * 0.4,
                ),
              ),
            ),
    );
  }
}
