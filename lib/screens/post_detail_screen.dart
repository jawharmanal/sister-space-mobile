// 🌸 Détail d'un post avec ses commentaires
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../widgets/avatar_gradient.dart';

class PostDetailScreen extends StatefulWidget {
  final int idPost;
  const PostDetailScreen({super.key, required this.idPost});
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _ctrl = TextEditingController();
  Map<String, dynamic>? _post;
  List<dynamic> _commentaires = [];
  bool _chargement = true;
  bool _envoi = false;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final data = await ApiService.getPostDetail(widget.idPost);
      setState(() {
        _post = data;
        // Les commentaires sont soit dans data['commentaires'], soit data['comments']
        _commentaires = (data['commentaires'] as List?) ??
            (data['comments'] as List?) ??
            [];
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreur = e.toString().replaceAll('Exception: ', '');
        _chargement = false;
      });
    }
  }

  Future<void> _commenter() async {
    if (_ctrl.text.trim().isEmpty || _envoi) return;
    setState(() => _envoi = true);
    try {
      await ApiService.creerCommentaire(widget.idPost, _ctrl.text.trim());
      _ctrl.clear();
      await _charger();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.erreur,
        content: Text(e.toString().replaceAll('Exception: ', '')),
      ));
    } finally {
      if (mounted) setState(() => _envoi = false);
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
        title: Text('Post', style: AppText.titre(18)),
      ),
      body: _chargement
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose))
          : _erreur != null
              ? Center(child: Text(_erreur!,
                  style: AppText.corps(14, color: AppColors.erreur)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _cartePost(),
                          const SizedBox(height: 16),
                          Text('Commentaires (${_commentaires.length})',
                              style: AppText.corps(14, w: FontWeight.w700)),
                          const SizedBox(height: 8),
                          if (_commentaires.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Text('Sois la première à commenter 🌸',
                                    style: AppText.corps(13,
                                        color: AppColors.texteDoux)),
                              ),
                            )
                          else
                            ..._commentaires
                                .map((c) => _carteCommentaire(c)),
                        ],
                      ),
                    ),
                    _zoneCommentaire(),
                  ],
                ),
    );
  }

  Widget _cartePost() {
    final p = _post!;
    final auteur =
        (p['auteure_prenom'] ?? p['prenom'] ?? 'Anonyme').toString();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarGradient(texte: auteur, taille: 42, seed: 1),
              const SizedBox(width: 10),
              Text(auteur, style: AppText.corps(15, w: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(p['contenu']?.toString() ?? '',
              style: AppText.corps(15).copyWith(height: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.rose, size: 18),
              const SizedBox(width: 5),
              Text('${p['nb_likes'] ?? 0}',
                  style: AppText.corps(13, color: AppColors.texteDoux)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _carteCommentaire(dynamic c) {
    final auteur =
        (c['auteure_prenom'] ?? c['prenom'] ?? 'Anonyme').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarGradient(texte: auteur, taille: 32, seed: 2),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(auteur, style: AppText.corps(13, w: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(c['contenu']?.toString() ?? '',
                    style: AppText.corps(13, color: AppColors.texte)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoneCommentaire() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                onSubmitted: (_) => _commenter(),
                decoration: InputDecoration(
                  hintText: 'Ajoute un commentaire...',
                  hintStyle:
                      AppText.corps(14, color: AppColors.texteDoux),
                  filled: true,
                  fillColor: AppColors.roseBg,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _envoi ? null : _commenter,
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.rose,
                  shape: BoxShape.circle,
                ),
                child: _envoi
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
