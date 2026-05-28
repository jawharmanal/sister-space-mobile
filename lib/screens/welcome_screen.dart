// 🌸 Welcome / Login — compact, fidèle à la maquette (logo carré, fond dégradé)
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDE4EF), Color(0xFFFFF6FA), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4, 0.7],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Logo carré arrondi (comme la maquette)
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.rose, AppColors.roseFonce],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text('S',
                      style: AppText.titreItalic(24, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 22),
              // Titre
              RichText(
                text: TextSpan(
                  style: AppText.titre(26),
                  children: [
                    const TextSpan(text: 'Welcome to '),
                    TextSpan(
                      text: 'Sister Space.',
                      style: AppText.titreItalic(26),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Un espace créé pour les femmes — à partager, à grandir ensemble.",
                style: AppText.corps(13, color: AppColors.texteDoux),
              ),
              const SizedBox(height: 24),
              _label('EMAIL'),
              const SizedBox(height: 6),
              _champ(_email, 'ton@email.com'),
              const SizedBox(height: 14),
              _label('PASSWORD'),
              const SizedBox(height: 6),
              _champ(_mdp, '••••••••', secret: true),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text('Forgot password?',
                    style: AppText.corps(12, color: AppColors.rose)
                        .copyWith(fontStyle: FontStyle.italic)),
              ),
              if (_erreur != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.erreur.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_erreur!,
                      style: AppText.corps(12, color: AppColors.erreur),
                      textAlign: TextAlign.center),
                ),
              ],
              const SizedBox(height: 16),
              // Bouton Sign in
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _chargement ? null : _connecter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: _chargement
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text('Sign in',
                          style: AppText.corps(15, w: FontWeight.w700)
                              .copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('or continue with',
                    style: AppText.corps(12, color: AppColors.texteDoux)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _social('', 'Apple')),
                  const SizedBox(width: 10),
                  Expanded(child: _social('G', 'Google')),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RegisterScreen()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: AppText.corps(13, color: AppColors.texteDoux),
                      children: [
                        const TextSpan(text: 'New here? '),
                        TextSpan(
                          text: 'Create account',
                          style: AppText.corps(13,
                              color: AppColors.rose, w: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String s) => Text(s,
      style: AppText.corps(11, color: AppColors.texteDoux, w: FontWeight.w700)
          .copyWith(letterSpacing: 1));

  Widget _champ(TextEditingController c, String hint, {bool secret = false}) {
    return TextField(
      controller: c,
      obscureText: secret,
      style: AppText.corps(14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.corps(14, color: AppColors.texteDoux),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.bordure),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.bordure),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
        ),
      ),
    );
  }

  Widget _social(String icone, String texte) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.bordure),
        padding: const EdgeInsets.symmetric(vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icone.isNotEmpty) ...[
            Text(icone,
                style: AppText.corps(14, w: FontWeight.w700)),
            const SizedBox(width: 6),
          ] else ...[
            const Icon(Icons.apple, size: 18, color: AppColors.texte),
            const SizedBox(width: 6),
          ],
          Text(texte, style: AppText.corps(13, w: FontWeight.w600)),
        ],
      ),
    );
  }
}
