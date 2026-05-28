// 🌸 Écran Inscription — connecté à ton API (POST /api/auth/register)
// Reprend exactement le formulaire de ton site web : villes en dur (10),
// centres d'intérêt en dur (8), cases RGPD obligatoires.

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import 'welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Champs
  final _prenom = TextEditingController();
  final _pseudo = TextEditingController();
  final _email = TextEditingController();
  final _mdp = TextEditingController();
  final _bio = TextEditingController();
  DateTime? _dateNaissance;
  int _idVille = 1;

  final List<int> _interets = [];
  bool _identFemme = false;
  bool _cgu = false;
  bool _rgpd = false;

  bool _envoi = false;
  String? _erreur;
  bool _succes = false;

  // Mêmes listes que ton front web 🌸
  static const _villes = [
    {'id': 1, 'nom': 'Paris'},
    {'id': 2, 'nom': 'Lyon'},
    {'id': 3, 'nom': 'Marseille'},
    {'id': 4, 'nom': 'Toulouse'},
    {'id': 5, 'nom': 'Bordeaux'},
    {'id': 6, 'nom': 'Nice'},
    {'id': 7, 'nom': 'Nantes'},
    {'id': 8, 'nom': 'Strasbourg'},
    {'id': 9, 'nom': 'Montpellier'},
    {'id': 10, 'nom': 'Lille'},
  ];

  static const _centres = [
    {'id': 1, 'nom': 'Restos', 'emoji': '🍴'},
    {'id': 2, 'nom': 'Cinéma', 'emoji': '🎬'},
    {'id': 3, 'nom': 'Shopping', 'emoji': '🛍️'},
    {'id': 4, 'nom': 'Culture', 'emoji': '🎨'},
    {'id': 5, 'nom': 'Sport', 'emoji': '💪'},
    {'id': 6, 'nom': 'Bien-être', 'emoji': '🌿'},
    {'id': 7, 'nom': 'Musique', 'emoji': '🎵'},
    {'id': 8, 'nom': 'Voyages', 'emoji': '✈️'},
  ];

  void _toggleInteret(int id) {
    setState(() {
      if (_interets.contains(id)) {
        _interets.remove(id);
      } else if (_interets.length < 5) {
        _interets.add(id);
      }
    });
  }

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.rose,
            onPrimary: Colors.white,
            onSurface: AppColors.texte,
          ),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _dateNaissance = d);
  }

  Future<void> _inscrire() async {
    setState(() => _erreur = null);

    // Validations
    if (_prenom.text.trim().isEmpty ||
        _pseudo.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _mdp.text.isEmpty ||
        _dateNaissance == null) {
      setState(() => _erreur = 'Remplis tous les champs obligatoires 🌸');
      return;
    }
    if (_interets.length < 3) {
      setState(() => _erreur = "Choisis au moins 3 centres d'intérêt 🌸");
      return;
    }
    if (!_identFemme || !_cgu || !_rgpd) {
      setState(() => _erreur = 'Tu dois accepter toutes les conditions');
      return;
    }

    setState(() => _envoi = true);
    try {
      final dateStr =
          "${_dateNaissance!.year.toString().padLeft(4, '0')}-${_dateNaissance!.month.toString().padLeft(2, '0')}-${_dateNaissance!.day.toString().padLeft(2, '0')}";
      await ApiService.inscrire(
        email: _email.text.trim(),
        motDePasse: _mdp.text,
        prenom: _prenom.text.trim(),
        pseudo: _pseudo.text.trim(),
        dateNaissance: dateStr,
        idVille: _idVille,
        bio: _bio.text.trim(),
        centresInteret: _interets,
        identificationFemme: _identFemme,
        acceptationCgu: _cgu,
        consentementDonnees: _rgpd,
      );
      setState(() => _succes = true);
    } catch (e) {
      setState(() => _erreur = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_succes) return _ecranSucces();
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bouton retour
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.texte, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              // Logo
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.rose, AppColors.roseFonce],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🌸', style: TextStyle(fontSize: 26)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Rejoins-nous',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texte,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'chez Sister Space',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: AppColors.rose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'La communauté rien que pour nous ✨',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.texteDoux,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _label('PRÉNOM'),
              TextField(controller: _prenom, decoration: _deco('Manal')),
              const SizedBox(height: 14),
              _label('PSEUDO'),
              TextField(controller: _pseudo, decoration: _deco('@toi')),
              const SizedBox(height: 14),
              _label('EMAIL'),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: _deco('ton@email.com'),
              ),
              const SizedBox(height: 14),
              _label('MOT DE PASSE'),
              TextField(
                controller: _mdp,
                obscureText: true,
                decoration: _deco('••••••••'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  'Min. 8 caractères : maj / min / chiffre / spécial',
                  style:
                      TextStyle(fontSize: 11, color: AppColors.texteDoux),
                ),
              ),
              const SizedBox(height: 14),
              _label('DATE DE NAISSANCE'),
              GestureDetector(
                onTap: _choisirDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.roseBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.bordure),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.rose, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        _dateNaissance == null
                            ? 'jj/mm/aaaa'
                            : '${_dateNaissance!.day.toString().padLeft(2, '0')}/${_dateNaissance!.month.toString().padLeft(2, '0')}/${_dateNaissance!.year}',
                        style: TextStyle(
                          color: _dateNaissance == null
                              ? AppColors.texteDoux
                              : AppColors.texte,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _label('VILLE'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.roseBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.bordure),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _idVille,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.rose),
                    items: _villes
                        .map((v) => DropdownMenuItem<int>(
                              value: v['id'] as int,
                              child: Text(v['nom'] as String,
                                  style: const TextStyle(
                                      color: AppColors.texte)),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _idVille = v!),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _label('BIO (optionnel)'),
              TextField(
                controller: _bio,
                maxLines: 3,
                maxLength: 150,
                decoration: _deco('Présente-toi en quelques mots...'),
              ),
              const SizedBox(height: 8),
              _label('TES PASSIONS (${_interets.length}/5 — min. 3)'),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _centres.map((c) {
                  final actif = _interets.contains(c['id']);
                  return GestureDetector(
                    onTap: () => _toggleInteret(c['id'] as int),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: actif
                            ? const LinearGradient(colors: [
                                AppColors.rose,
                                AppColors.roseFonce,
                              ])
                            : null,
                        color: actif ? null : AppColors.blanc,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: actif
                              ? AppColors.rose
                              : AppColors.bordure,
                        ),
                      ),
                      child: Text(
                        '${c['emoji']} ${c['nom']}',
                        style: TextStyle(
                          color:
                              actif ? Colors.white : AppColors.texteDoux,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _label('AVANT DE CONTINUER'),
              const SizedBox(height: 4),
              _checkbox(_identFemme, "Je m'identifie comme une femme 🌸",
                  (v) => setState(() => _identFemme = v ?? false)),
              _checkbox(
                  _cgu,
                  "J'accepte les CGU et la politique de confidentialité",
                  (v) => setState(() => _cgu = v ?? false)),
              _checkbox(
                  _rgpd,
                  "Je consens au traitement de mes données (RGPD)",
                  (v) => setState(() => _rgpd = v ?? false)),
              if (_erreur != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.erreur.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _erreur!,
                    style: const TextStyle(color: AppColors.erreur),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _envoi ? null : _inscrire,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: _envoi
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Créer mon compte 🌸',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          color: AppColors.texteDoux, fontSize: 13),
                      children: [
                        TextSpan(text: 'Déjà membre ? '),
                        TextSpan(
                          text: 'Connecte-toi ✨',
                          style: TextStyle(
                            color: AppColors.rose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ecranSucces() {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.rose, AppColors.roseFonce],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🌸', style: TextStyle(fontSize: 38)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bienvenue dans la team !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texte,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ton compte est presque prêt',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: AppColors.rose,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.roseClair.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.bordure),
                  ),
                  child: const Text(
                    '💗 Ton inscription a bien été reçue !\nNotre équipe va valider ton compte rapidement et tu recevras une confirmation pour rejoindre la communauté ✨',
                    style: TextStyle(
                      color: AppColors.texte,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WelcomeScreen()),
                      (_) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rose,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Retour à la connexion',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- helpers visuels ----
  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(s,
            style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: AppColors.texteDoux)),
      );

  InputDecoration _deco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.texteDoux),
        filled: true,
        fillColor: AppColors.roseBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.bordure),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.bordure),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
        ),
      );

  Widget _checkbox(bool valeur, String texte, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: valeur,
              onChanged: onChanged,
              activeColor: AppColors.rose,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!valeur),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(texte,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.texte)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
