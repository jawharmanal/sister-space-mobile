// 🌸 Écran 3 — Create post (création de post + photo, connecté à l'API)
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../services/cloudinary_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _ctrl = TextEditingController();
  bool _envoi = false;
  String? _categorie;
  String? _photoUrl;
  bool _uploadEnCours = false;

  final _categories = [
    {'label': 'Advice', 'color': AppColors.catRose},
    {'label': 'Outing', 'color': AppColors.catBleu},
    {'label': 'Question', 'color': AppColors.catVert},
    {'label': 'Recommend', 'color': AppColors.catJaune},
  ];

  Future<void> _ajouterPhoto() async {
    setState(() => _uploadEnCours = true);
    try {
      final url = await CloudinaryService.choisirEtUploader();
      if (url != null) setState(() => _photoUrl = url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.erreur,
          content: Text(e.toString().replaceAll('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadEnCours = false);
    }
  }

  Future<void> _publier() async {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() => _envoi = true);
    try {
      await ApiService.creerPost(
        _ctrl.text.trim(),
        photosUrls: _photoUrl != null ? [_photoUrl!] : null,
      );
      if (!mounted) return;
      _ctrl.clear();
      setState(() => _photoUrl = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.succes,
          content: Text('Post publié 🌸'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.erreur,
          content: Text(e.toString().replaceAll('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nouveau post',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.texte)),
                ElevatedButton(
                  onPressed: _envoi ? null : _publier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _envoi
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Post'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ctrl,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText:
                    'Partage ton bon plan, ta question, ton coup de cœur... 🌸',
                hintStyle: const TextStyle(color: AppColors.texteDoux),
                filled: true,
                fillColor: AppColors.blanc,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.bordure),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.bordure),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Zone photo
            if (_photoUrl != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      _photoUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _photoUrl = null),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _uploadEnCours ? null : _ajouterPhoto,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.roseClair.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.bordure),
                  ),
                  child: Center(
                    child: _uploadEnCours
                        ? const Column(
                            children: [
                              CircularProgressIndicator(
                                  color: AppColors.rose),
                              SizedBox(height: 8),
                              Text('Upload en cours...',
                                  style: TextStyle(
                                      color: AppColors.roseFonce)),
                            ],
                          )
                        : const Column(
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: AppColors.rose, size: 32),
                              SizedBox(height: 8),
                              Text('Ajouter une photo',
                                  style: TextStyle(
                                      color: AppColors.roseFonce)),
                              Text('(max 5 Mo)',
                                  style: TextStyle(
                                      color: AppColors.texteDoux,
                                      fontSize: 12)),
                            ],
                          ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text('Tag your post:',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.texte)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((c) {
                final actif = _categorie == c['label'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _categorie = c['label'] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: actif
                          ? AppColors.rose
                          : (c['color'] as Color).withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c['label'] as String,
                      style: TextStyle(
                        color: actif ? Colors.white : AppColors.texte,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
