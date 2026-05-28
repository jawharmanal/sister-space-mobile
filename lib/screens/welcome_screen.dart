// 🌸 Écran 1 — Welcome / Login (style maquette)
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../widgets/main_layout.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _email = TextEditingController();
  final _mdp = TextEditingController();
  bool _chargement = false;
  String? _erreur;

  Future<void> _connecter() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final u = await ApiService.seConnecter(_email.text.trim(), _mdp.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainLayout(prenom: u['prenom'] ?? 'Sister'),
        ),
      );
    } catch (e) {
      setState(() => _erreur = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Logo rond avec S
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.rose, AppColors.roseFonce],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Titre Welcome to Sister Space
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texte,
                  ),
                  children: [
                    TextSpan(text: 'Welcome to '),
                    TextSpan(
                      text: 'Sister\nSpace.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.rose,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Un espace cr\u00e9\u00e9 pour les femmes \u2014 \u00e0 partager, \u00e0 grandir ensemble.",
                style: TextStyle(color: AppColors.texteDoux, fontSize: 14),
              ),
              const SizedBox(height: 32),
              // EMAIL
              const Text(
                'EMAIL',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texteDoux,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _email,
                decoration: _deco('ton@email.com'),
              ),
              const SizedBox(height: 20),
              // PASSWORD
              const Text(
                'PASSWORD',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texteDoux,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _mdp,
                obscureText: true,
                decoration: _deco('\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022'),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.rose,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
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
              const SizedBox(height: 16),
              // Bouton Sign in
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _chargement ? null : _connecter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: _chargement
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'or continue with',
                  style: TextStyle(color: AppColors.texteDoux, fontSize: 12),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _boutonSocial('\uF8FF', 'Apple', Colors.black)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _boutonSocial('G', 'Google', AppColors.texte)),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RegisterScreen()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: AppColors.texteDoux, fontSize: 13),
                      children: [
                        const TextSpan(text: 'New here? '),
                        TextSpan(
                          text: 'Create account',
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _deco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.texteDoux),
        filled: true,
        fillColor: AppColors.roseBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.bordure),
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

  Widget _boutonSocial(String icone, String texte, Color couleur) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.bordure),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icone, style: TextStyle(color: couleur, fontSize: 16)),
          const SizedBox(width: 8),
          Text(texte,
              style: TextStyle(
                  color: AppColors.texte, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
