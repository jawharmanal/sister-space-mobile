// 🌸 Écran Paramètres — 4 onglets (Mes infos / Photo / Mot de passe / Supprimer)
// Comme ton site web. Connecté à ton API.
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../services/cloudinary_service.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.roseBg,
      appBar: AppBar(
        backgroundColor: AppColors.rose,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('⚙️ Paramètres',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '👤 Mes infos'),
            Tab(text: '📷 Photo'),
            Tab(text: '🔒 Mot de passe'),
            Tab(text: '⚠️ Supprimer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _OngletInfos(),
          _OngletPhoto(),
          _OngletMotDePasse(),
          _OngletSupprimer(),
        ],
      ),
    );
  }
}

// ---------- Onglet 1 : Mes infos ----------
class _OngletInfos extends StatefulWidget {
  const _OngletInfos();
  @override
  State<_OngletInfos> createState() => _OngletInfosState();
}

class _OngletInfosState extends State<_OngletInfos> {
  final _prenom = TextEditingController();
  final _pseudo = TextEditingController();
  final _bio = TextEditingController();
  String _email = '';
  bool _envoi = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final u = await ApiService.getUtilisatrice();
    setState(() {
      _prenom.text = u?['prenom']?.toString() ?? '';
      _pseudo.text = u?['pseudo']?.toString() ?? '';
      _bio.text = u?['bio']?.toString() ?? '';
      _email = u?['email']?.toString() ?? '';
    });
  }

  Future<void> _enregistrer() async {
    setState(() => _envoi = true);
    try {
      await ApiService.modifierProfil(
        prenom: _prenom.text.trim(),
        pseudo: _pseudo.text.trim(),
        bio: _bio.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.succes,
        content: Text('Profil mis à jour 🌸'),
      ));
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.texte)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bordure.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(_email,
                style: const TextStyle(color: AppColors.texteDoux)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text("L'email ne peut pas être modifié",
                style:
                    TextStyle(fontSize: 11, color: AppColors.texteDoux)),
          ),
          const SizedBox(height: 16),
          _champ('Prénom *', _prenom),
          const SizedBox(height: 16),
          _champ('Pseudo *', _pseudo),
          const SizedBox(height: 16),
          _champ('Bio', _bio, lignes: 4),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _envoi ? null : _enregistrer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: _envoi
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('💾 Enregistrer les modifications',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _champ(String label, TextEditingController c, {int lignes = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.texte)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          maxLines: lignes,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.blanc,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.bordure),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.bordure),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- Onglet 2 : Photo ----------
class _OngletPhoto extends StatefulWidget {
  const _OngletPhoto();
  @override
  State<_OngletPhoto> createState() => _OngletPhotoState();
}

class _OngletPhotoState extends State<_OngletPhoto> {
  String? _photoUrl;
  String _prenom = '?';
  bool _upload = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final u = await ApiService.getUtilisatrice();
    setState(() {
      _photoUrl = u?['photo_profil_url']?.toString() ??
          u?['photoUrl']?.toString();
      _prenom = u?['prenom']?.toString() ?? '?';
    });
  }

  Future<void> _changer() async {
    setState(() => _upload = true);
    try {
      final url = await CloudinaryService.choisirEtUploader();
      if (url != null) {
        await ApiService.modifierProfil(photoUrl: url);
        setState(() => _photoUrl = url);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.succes,
          content: Text('Photo mise à jour 🌸'),
        ));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.erreur,
        content: Text(e.toString().replaceAll('Exception: ', '')),
      ));
    } finally {
      if (mounted) setState(() => _upload = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📷 Ma photo de profil',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texte)),
            const SizedBox(height: 8),
            const Text('Personnalise ton avatar',
                style: TextStyle(color: AppColors.texteDoux)),
            const SizedBox(height: 24),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.rose,
                border: Border.all(color: AppColors.roseClair, width: 4),
                image: _photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_photoUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: _photoUrl == null
                  ? Center(
                      child: Text(
                        _prenom.isNotEmpty ? _prenom[0].toUpperCase() : '?',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _upload ? null : _changer,
              icon: _upload
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.camera_alt, size: 18),
              label: const Text('Choisir une photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Onglet 3 : Mot de passe ----------
class _OngletMotDePasse extends StatefulWidget {
  const _OngletMotDePasse();
  @override
  State<_OngletMotDePasse> createState() => _OngletMotDePasseState();
}

class _OngletMotDePasseState extends State<_OngletMotDePasse> {
  final _ancien = TextEditingController();
  final _nouveau = TextEditingController();
  final _confirm = TextEditingController();
  bool _envoi = false;

  Future<void> _changer() async {
    if (_nouveau.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.erreur,
        content: Text('Les mots de passe ne correspondent pas'),
      ));
      return;
    }
    setState(() => _envoi = true);
    try {
      await ApiService.changerMotDePasse(_ancien.text, _nouveau.text);
      if (!mounted) return;
      _ancien.clear();
      _nouveau.clear();
      _confirm.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.succes,
        content: Text('Mot de passe modifié 🔒'),
      ));
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔒 Changer mon mot de passe',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texte)),
          const SizedBox(height: 4),
          const Text("Pour ta sécurité, on te demande l'ancien",
              style: TextStyle(color: AppColors.texteDoux)),
          const SizedBox(height: 20),
          _champ('Mot de passe actuel *', _ancien),
          const SizedBox(height: 16),
          _champ('Nouveau mot de passe *', _nouveau),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('Min 8 caractères, maj/min/chiffre/spécial',
                style:
                    TextStyle(fontSize: 11, color: AppColors.texteDoux)),
          ),
          const SizedBox(height: 16),
          _champ('Confirmer le nouveau mot de passe *', _confirm),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _envoi ? null : _changer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: _envoi
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('🔒 Changer mon mot de passe',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _champ(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.texte)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.blanc,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.bordure),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.bordure),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- Onglet 4 : Supprimer ----------
class _OngletSupprimer extends StatefulWidget {
  const _OngletSupprimer();
  @override
  State<_OngletSupprimer> createState() => _OngletSupprimerState();
}

class _OngletSupprimerState extends State<_OngletSupprimer> {
  final _mdp = TextEditingController();
  bool _confirme = false;
  bool _envoi = false;

  Future<void> _supprimer() async {
    if (!_confirme || _mdp.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.erreur,
        content: Text('Coche la case et entre ton mot de passe'),
      ));
      return;
    }
    setState(() => _envoi = true);
    try {
      await ApiService.supprimerCompte(_mdp.text);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (_) => false,
      );
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️ Supprimer mon compte',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.erreur)),
          const SizedBox(height: 8),
          const Text(
            'Cette action est irréversible. Tous tes posts, commentaires et messages seront supprimés.',
            style: TextStyle(color: AppColors.texteDoux),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.roseClair.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              "💔 On est tristes de te voir partir. Si tu as un problème, n'hésite pas à nous contacter avant !",
              style: TextStyle(color: AppColors.roseFonce),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Confirme avec ton mot de passe *',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.texte)),
          const SizedBox(height: 6),
          TextField(
            controller: _mdp,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.blanc,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.bordure),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.bordure),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _confirme,
                activeColor: AppColors.erreur,
                onChanged: (v) => setState(() => _confirme = v ?? false),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Je comprends que cette action est irréversible et supprimera définitivement mon compte et toutes mes données (droit à l'oubli RGPD).",
                    style: TextStyle(fontSize: 13, color: AppColors.texte),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _envoi ? null : _supprimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.erreur,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: _envoi
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('🗑️ Supprimer définitivement mon compte',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
