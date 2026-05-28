// 🌸 Home Feed — fidèle à la maquette (avatars stories, badges catégories)
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../widgets/avatar_gradient.dart';
import 'post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String prenom;
  const HomeScreen({super.key, required this.prenom});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _posts = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final posts = await ApiService.getPosts();
      setState(() {
        _posts = posts;
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreur = e.toString().replaceAll('Exception: ', '');
        _chargement = false;
      });
    }
  }

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
        child: Column(
          children: [
            // En-tête
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sister Space', style: AppText.titreItalic(24)),
                  Row(
                    children: [
                      _iconeRonde(Icons.search),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _ouvrirNotifications(context),
                        child: _iconeRonde(Icons.notifications_none),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Rangée d'avatars (stories style)
            SizedBox(
              height: 84,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6,
                itemBuilder: (_, i) {
                  final lettres = ['S', 'M', 'P', 'J', 'L', 'A'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.rose, Color(0xFFFFB088)],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: AvatarGradient(
                          texte: lettres[i],
                          taille: 56,
                          seed: i,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Posts
            Expanded(
              child: _chargement
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.rose))
                  : _erreur != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(_erreur!,
                                style: AppText.corps(14,
                                    color: AppColors.erreur),
                                textAlign: TextAlign.center),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.rose,
                          onRefresh: _charger,
                          child: _posts.isEmpty
                              ? ListView(children: [
                                  const SizedBox(height: 80),
                                  Center(
                                      child: Text('Aucun post 🌸',
                                          style: AppText.corps(14,
                                              color: AppColors.texteDoux))),
                                ])
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 8, 16, 16),
                                  itemCount: _posts.length,
                                  itemBuilder: (_, i) =>
                                      _carte(_posts[i], i),
                                ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconeRonde(IconData icone) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.rose.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icone, color: AppColors.roseFonce, size: 20),
      );

  void _ouvrirNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bordure,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.notifications_none,
                color: AppColors.rose, size: 48),
            const SizedBox(height: 14),
            Text('Notifications', style: AppText.titre(20)),
            const SizedBox(height: 8),
            Text(
              'Pas de nouvelle notification pour le moment 🌸\nReviens plus tard !',
              textAlign: TextAlign.center,
              style: AppText.corps(14, color: AppColors.texteDoux),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _carte(dynamic p, int index) {
    final auteur = (p['auteure_prenom'] ?? p['prenom'] ?? 'Anonyme').toString();
    final cat = p['categorie_label']?.toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.rose.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarGradient(texte: auteur, taille: 42, seed: index),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(auteur,
                        style: AppText.corps(15, w: FontWeight.w600)),
                    Text(p['date_creation']?.toString() ?? '',
                        style: AppText.corps(12,
                            color: AppColors.texteDoux)),
                  ],
                ),
              ),
              if (cat != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE0CC), Color(0xFFFFD6E5)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(cat.toUpperCase(),
                      style: AppText.corps(10,
                          color: AppColors.roseFonce, w: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(p['contenu']?.toString() ?? '',
              style: AppText.corps(14, color: AppColors.texte)
                  .copyWith(height: 1.5)),
          const SizedBox(height: 14),
          Row(
            children: [
              _BoutonLike(
                idPost: int.tryParse(p['id'].toString()) ?? 0,
                nbLikes: int.tryParse(p['nb_likes']?.toString() ?? '0') ?? 0,
                dejaLike: p['deja_like'] == true,
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  final id = int.tryParse(p['id'].toString());
                  if (id != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PostDetailScreen(idPost: id)),
                    ).then((_) => _charger());
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        color: AppColors.texteDoux, size: 17),
                    const SizedBox(width: 5),
                    Text('${p['nb_commentaires'] ?? 0}',
                        style: AppText.corps(13,
                            color: AppColors.texteDoux)),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.bookmark_border,
                  color: AppColors.texteDoux, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

// ❤️ Bouton J'aime fonctionnel (avec état local optimiste)
class _BoutonLike extends StatefulWidget {
  final int idPost;
  final int nbLikes;
  final bool dejaLike;
  const _BoutonLike({
    required this.idPost,
    required this.nbLikes,
    required this.dejaLike,
  });

  @override
  State<_BoutonLike> createState() => _BoutonLikeState();
}

class _BoutonLikeState extends State<_BoutonLike> {
  late bool _like;
  late int _nb;
  bool _enCours = false;

  @override
  void initState() {
    super.initState();
    _like = widget.dejaLike;
    _nb = widget.nbLikes;
  }

  Future<void> _toggle() async {
    if (_enCours) return;
    setState(() {
      _enCours = true;
      // Mise à jour optimiste (instantanée à l'écran)
      _like = !_like;
      _nb += _like ? 1 : -1;
    });
    try {
      if (_like) {
        await ApiService.likerPost(widget.idPost);
      } else {
        await ApiService.unlikePost(widget.idPost);
      }
    } catch (e) {
      // En cas d'échec, on annule
      setState(() {
        _like = !_like;
        _nb += _like ? 1 : -1;
      });
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Row(
        children: [
          AnimatedScale(
            scale: _like ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Icon(
              _like ? Icons.favorite : Icons.favorite_border,
              color: _like ? AppColors.rose : AppColors.texteDoux,
              size: 18,
            ),
          ),
          const SizedBox(width: 5),
          Text('$_nb',
              style: AppText.corps(13, color: AppColors.texteDoux)),
        ],
      ),
    );
  }
}
