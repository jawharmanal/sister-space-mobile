// 🌸 Explore — identique au site web, ajusté pour le cadre téléphone
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'categorie_posts_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _recherche = '';

  static const _categories = [
    {'id': 1, 'emoji': '🍴', 'nom': 'Restos', 'desc': 'Bons plans culinaires'},
    {'id': 2, 'emoji': '🎬', 'nom': 'Cinéma', 'desc': 'Films à découvrir'},
    {'id': 3, 'emoji': '🛍️', 'nom': 'Shopping', 'desc': 'Pépites mode et déco'},
    {'id': 4, 'emoji': '🎨', 'nom': 'Culture', 'desc': 'Expos, musées, sorties'},
    {'id': 5, 'emoji': '💪', 'nom': 'Sport', 'desc': 'Cours, courses, motivation'},
    {'id': 6, 'emoji': '🌿', 'nom': 'Bien-être', 'desc': 'Self-care & mindfulness'},
    {'id': 7, 'emoji': '🎵', 'nom': 'Musique', 'desc': 'Concerts, festivals'},
    {'id': 8, 'emoji': '✈️', 'nom': 'Voyages', 'desc': 'Destinations & road trips'},
  ];

  static const _grads = [
    [Color(0xFFFAD0DD), Color(0xFFF8DCC8)],
    [Color(0xFFF3D5EC), Color(0xFFE8D5F0)],
    [Color(0xFFFAD0DD), Color(0xFFEFD5E8)],
    [Color(0xFFFFE0B5), Color(0xFFFFD0C0)],
    [Color(0xFFC8F0D8), Color(0xFFCDEFE8)],
    [Color(0xFFC8E8F0), Color(0xFFD5E5F5)],
    [Color(0xFFD5D5F5), Color(0xFFE5D5F0)],
    [Color(0xFFC8E5F5), Color(0xFFD0E8E5)],
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
            // Espace pour l'encoche
            const SizedBox(height: 8),
            // En-tête
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Explorer', style: AppText.titreItalic(26)),
                  const Text('🧭', style: TextStyle(fontSize: 22)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.bordure),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: AppColors.rose, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _recherche = v),
                        style: AppText.corps(14),
                        decoration: InputDecoration(
                          hintText: 'Rechercher une catégorie...',
                          hintStyle: AppText.corps(14,
                              color: AppColors.texteDoux),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("DÉCOUVRE PAR CENTRE D'INTÉRÊT",
                    style: AppText.corps(11,
                            color: AppColors.texteDoux,
                            w: FontWeight.w700)
                        .copyWith(letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 12),
            // Grille
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.02,
                ),
                itemCount: cats.length,
                itemBuilder: (_, i) {
                  final c = cats[i];
                  final idx = _categories.indexOf(c);
                  final grad = _grads[idx % _grads.length];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoriePostsScreen(
                            idCategorie: c['id'] as int,
                            nom: c['nom'] as String,
                            emoji: c['emoji'] as String,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: grad,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: grad[0].withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['emoji'] as String,
                              style: const TextStyle(fontSize: 30)),
                          const Spacer(),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(c['nom'] as String,
                                maxLines: 1,
                                style: AppText.titre(18)),
                          ),
                          const SizedBox(height: 2),
                          Text(c['desc'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.corps(11,
                                  color: AppColors.texte
                                      .withValues(alpha: 0.7))),
                        ],
                      ),
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
