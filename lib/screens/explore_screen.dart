// 🌸 Explore — fidèle à la maquette (cartes dégradé pastel + #hashtags)
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/avatar_gradient.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  // Tes vraies catégories Sister Space
  static const _categories = [
    {'titre': 'Restos', 'sous': 'Bons plans culinaires'},
    {'titre': 'Cinéma', 'sous': 'Films à découvrir'},
    {'titre': 'Shopping', 'sous': 'Pépites mode & déco'},
    {'titre': 'Culture', 'sous': 'Expos, musées, sorties'},
    {'titre': 'Sport', 'sous': 'Cours, courses, motivation'},
    {'titre': 'Bien-être', 'sous': 'Self-care & mindfulness'},
    {'titre': 'Musique', 'sous': 'Concerts, festivals'},
    {'titre': 'Voyages', 'sous': 'Destinations & road trips'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDEEF4), AppColors.roseBg, Color(0xFFFFFBFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explore', style: AppText.titre(30)),
              const SizedBox(height: 14),
              // Recherche
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rose.withValues(alpha: 0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.texteDoux),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search topics, people, posts',
                          hintStyle: AppText.corps(14,
                              color: AppColors.texteDoux),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text('CATEGORIES',
                  style: AppText.corps(11,
                          color: AppColors.texteDoux, w: FontWeight.w700)
                      .copyWith(letterSpacing: 1.3)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final c = _categories[i];
                  final grad =
                      AppColors.catGrads[i % AppColors.catGrads.length];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: grad,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#${c['titre']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.corps(17, w: FontWeight.w700)),
                        Text(c['sous'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.corps(11,
                                color: AppColors.texteDoux)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SUGGESTED FOR YOU',
                      style: AppText.corps(11,
                              color: AppColors.texteDoux,
                              w: FontWeight.w700)
                          .copyWith(letterSpacing: 1.3)),
                  Text('See all',
                      style: AppText.corps(12, color: AppColors.rose)),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(4, (i) {
                    final lettres = ['L', 'A', 'M', 'S'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Column(
                        children: [
                          AvatarGradient(
                              texte: lettres[i], taille: 56, seed: i),
                          const SizedBox(height: 6),
                          Text('+ Follow',
                              style:
                                  AppText.corps(11, color: AppColors.rose)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
