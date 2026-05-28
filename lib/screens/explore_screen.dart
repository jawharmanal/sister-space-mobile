// 🌸 Explore — identique au site web (cartes pastel + emoji + nom + description)
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _recherche = '';

  // Les 8 vraies catégories (comme le site web)
  static const _categories = [
    {'emoji': '🍴', 'nom': 'Restos', 'desc': 'Bons plans culinaires'},
    {'emoji': '🎬', 'nom': 'Cinéma', 'desc': 'Films à découvrir'},
    {'emoji': '🛍️', 'nom': 'Shopping', 'desc': 'Pépites mode et déco'},
    {'emoji': '🎨', 'nom': 'Culture', 'desc': 'Expos, musées, sorties'},
    {'emoji': '💪', 'nom': 'Sport', 'desc': 'Cours, courses, motivation'},
    {'emoji': '🌿', 'nom': 'Bien-être', 'desc': 'Self-care & mindfulness'},
    {'emoji': '🎵', 'nom': 'Musique', 'desc': 'Concerts, festivals'},
    {'emoji': '✈️', 'nom': 'Voyages', 'desc': 'Destinations & road trips'},
  ];

  // Dégradés pastel doux (comme le web)
  static const _grads = [
    [Color(0xFFFAD0DD), Color(0xFFF8DCC8)], // rose → pêche
    [Color(0xFFF3D5EC), Color(0xFFE8D5F0)], // rose → lilas
    [Color(0xFFFAD0DD), Color(0xFFEFD5E8)], // rose doux
    [Color(0xFFFFE0B5), Color(0xFFFFD0C0)], // jaune → pêche
    [Color(0xFFC8F0D8), Color(0xFFCDEFE8)], // vert d'eau
    [Color(0xFFC8E8F0), Color(0xFFD5E5F5)], // bleu ciel
    [Color(0xFFD5D5F5), Color(0xFFE5D5F0)], // lavande
    [Color(0xFFC8E5F5), Color(0xFFD0E8E5)], // bleu clair
  ];

  @override
  Widget build(BuildContext context) {
    final cats = _categories
        .where((c) => (c['nom'] as String)
            .toLowerCase()
            .contains(_recherche.toLowerCase()))
        .toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDEEF4), Color(0xFFFFFBFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // En-tête
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Explorer', style: AppText.titreItalic(30)),
                  const Text('🧭', style: TextStyle(fontSize: 26)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.bordure),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.rose),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _recherche = v),
                        decoration: InputDecoration(
                          hintText: 'Rechercher une catégorie...',
                          hintStyle: AppText.corps(15,
                              color: AppColors.texteDoux),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("DÉCOUVRE PAR CENTRE D'INTÉRÊT",
                    style: AppText.corps(12,
                            color: AppColors.texteDoux,
                            w: FontWeight.w700)
                        .copyWith(letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 14),
            // Grille de cartes
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.92,
                ),
                itemCount: cats.length,
                itemBuilder: (_, i) {
                  final c = cats[i];
                  final idx = _categories.indexOf(c);
                  final grad = _grads[idx % _grads.length];
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: grad,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: grad[0].withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c['emoji'] as String,
                            style: const TextStyle(fontSize: 38)),
                        const Spacer(),
                        Text(c['nom'] as String,
                            style: AppText.titre(22)),
                        const SizedBox(height: 4),
                        Text(c['desc'] as String,
                            style: AppText.corps(13,
                                color: AppColors.texte.withValues(
                                    alpha: 0.7))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
