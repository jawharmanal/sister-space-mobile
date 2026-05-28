// 🌸 Écran Profile — branché à ton back (profil + tes posts)
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import 'welcome_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _utilisatrice;
  List<dynamic> _mesPosts = [];
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
      // 1. Mon profil (stocké au login)
      final u = await ApiService.getUtilisatrice();
      // 2. Tous les posts → on filtre les miens
      final tous = await ApiService.getPosts();
      final monId = int.tryParse(u?['id'].toString() ?? '');
      final miens = tous.where((p) {
        final idAuteure = int.tryParse(
            (p['id_auteure'] ?? p['auteure_id'] ?? '').toString());
        return monId != null && idAuteure == monId;
      }).toList();
      setState(() {
        _utilisatrice = u;
        _mesPosts = miens;
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreur = e.toString().replaceAll('Exception: ', '');
        _chargement = false;
      });
    }
  }

  Future<void> _deconnexion() async {
    await ApiService.seDeconnecter();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const SafeArea(
        child: Center(child: CircularProgressIndicator(color: AppColors.rose)),
      );
    }
    if (_erreur != null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_erreur!,
                style: const TextStyle(color: AppColors.erreur),
                textAlign: TextAlign.center),
          ),
        ),
      );
    }

    final prenom = _utilisatrice?['prenom']?.toString() ?? '—';
    final pseudo = _utilisatrice?['pseudo']?.toString() ?? '';
    final bio = _utilisatrice?['bio']?.toString();

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.rose,
        onRefresh: _charger,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            // En-tête : @pseudo + déconnexion
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '@$pseudo',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.texte,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout,
                        color: AppColors.roseFonce),
                    onPressed: _deconnexion,
                    tooltip: 'Déconnexion',
                  ),
                ],
              ),
            ),
            // Avatar
            Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.rose, AppColors.roseFonce],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.blanc, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rose.withValues(alpha: 0.3),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    prenom.isNotEmpty ? prenom[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Prénom
            Center(
              child: Text(
                prenom,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texte,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Bio (si présente)
            if (bio != null && bio.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.texteDoux),
                ),
              ),
            const SizedBox(height: 20),
            // Stats (vraies)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Stat(valeur: '${_mesPosts.length}', label: 'posts'),
              ],
            ),
            const SizedBox(height: 20),
            // Bouton Edit profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    ).then((_) => _charger());
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.rose),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Modifier mon profil',
                      style: TextStyle(color: AppColors.rose)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Mes posts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded,
                      color: AppColors.rose, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Mes publications',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.texte,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_mesPosts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Tu n\'as pas encore publié 🌸',
                    style: TextStyle(color: AppColors.texteDoux),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: _mesPosts.map((p) => _cartePost(p)).toList(),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _cartePost(dynamic p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.rose.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (p['categorie_label'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.roseClair,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p['categorie_label'].toString(),
                    style: const TextStyle(
                        color: AppColors.roseFonce, fontSize: 11),
                  ),
                ),
              const Spacer(),
              Text(
                p['date_creation']?.toString().substring(0, 10) ?? '',
                style:
                    const TextStyle(fontSize: 11, color: AppColors.texteDoux),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            p['contenu']?.toString() ?? '',
            style: const TextStyle(
                fontSize: 14, color: AppColors.texte, height: 1.4),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.favorite_border,
                  color: AppColors.texteDoux, size: 16),
              const SizedBox(width: 4),
              Text('${p['nb_likes'] ?? 0}',
                  style: const TextStyle(
                      color: AppColors.texteDoux, fontSize: 12)),
              const SizedBox(width: 14),
              const Icon(Icons.chat_bubble_outline,
                  color: AppColors.texteDoux, size: 16),
              const SizedBox(width: 4),
              Text('${p['nb_commentaires'] ?? 0}',
                  style: const TextStyle(
                      color: AppColors.texteDoux, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String valeur;
  final String label;
  const _Stat({required this.valeur, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(valeur,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texte)),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.texteDoux)),
        ],
      ),
    );
  }
}
