// 🌸 Posts d'une catégorie (clic depuis Explore)
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../widgets/avatar_gradient.dart';
import 'post_detail_screen.dart';

class CategoriePostsScreen extends StatefulWidget {
  final int idCategorie;
  final String nom;
  final String emoji;
  const CategoriePostsScreen({
    super.key,
    required this.idCategorie,
    required this.nom,
    required this.emoji,
  });

  @override
  State<CategoriePostsScreen> createState() => _CategoriePostsScreenState();
}

class _CategoriePostsScreenState extends State<CategoriePostsScreen> {
  List<dynamic> _posts = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final posts = await ApiService.getPosts(categorie: widget.idCategorie);
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
    return Scaffold(
      backgroundColor: AppColors.roseBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.texte,
        title: Row(
          children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(widget.nom, style: AppText.titre(18)),
          ],
        ),
      ),
      body: _chargement
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose))
          : _erreur != null
              ? Center(child: Text(_erreur!,
                  style: AppText.corps(14, color: AppColors.erreur)))
              : _posts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.emoji,
                                style: const TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text(
                              'Aucun post sur ${widget.nom} pour le moment 🌸\nSois la première à publier !',
                              textAlign: TextAlign.center,
                              style: AppText.corps(14,
                                  color: AppColors.texteDoux),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _posts.length,
                      itemBuilder: (_, i) => _carte(_posts[i], i),
                    ),
    );
  }

  Widget _carte(dynamic p, int index) {
    final auteur =
        (p['auteure_prenom'] ?? p['prenom'] ?? 'Anonyme').toString();
    return GestureDetector(
      onTap: () {
        final id = int.tryParse(p['id'].toString());
        if (id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PostDetailScreen(idPost: id)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.rose.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarGradient(texte: auteur, taille: 40, seed: index),
                const SizedBox(width: 10),
                Text(auteur,
                    style: AppText.corps(15, w: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            Text(p['contenu']?.toString() ?? '',
                style: AppText.corps(14).copyWith(height: 1.4)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.favorite,
                    color: AppColors.rose, size: 16),
                const SizedBox(width: 4),
                Text('${p['nb_likes'] ?? 0}',
                    style: AppText.corps(12, color: AppColors.texteDoux)),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline,
                    color: AppColors.texteDoux, size: 15),
                const SizedBox(width: 4),
                Text('${p['nb_commentaires'] ?? 0}',
                    style: AppText.corps(12, color: AppColors.texteDoux)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
