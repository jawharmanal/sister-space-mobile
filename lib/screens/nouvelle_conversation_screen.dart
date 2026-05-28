// 🌸 Nouvelle conversation — choisir une utilisatrice à qui écrire
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import '../widgets/avatar_gradient.dart';
import 'chat_screen.dart';

class NouvelleConversationScreen extends StatefulWidget {
  const NouvelleConversationScreen({super.key});
  @override
  State<NouvelleConversationScreen> createState() =>
      _NouvelleConversationScreenState();
}

class _NouvelleConversationScreenState
    extends State<NouvelleConversationScreen> {
  List<dynamic> _utilisatrices = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final list = await ApiService.getUtilisatrices();
      setState(() {
        _utilisatrices = list;
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreur = e.toString().replaceAll('Exception: ', '');
        _chargement = false;
      });
    }
  }

  Future<void> _ouvrir(dynamic u) async {
    try {
      final idAutre = int.parse(u['id'].toString());
      final idConv = await ApiService.demarrerConversation(idAutre);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            idConversation: idConv,
            nom: (u['prenom'] ?? 'Sister').toString(),
            couleur: AppColors.catRose,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.erreur,
        content: Text(e.toString().replaceAll('Exception: ', '')),
      ));
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
        title: Text('Nouvelle conversation', style: AppText.titre(18)),
      ),
      body: _chargement
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose))
          : _erreur != null
              ? Center(child: Text(_erreur!,
                  style: AppText.corps(14, color: AppColors.erreur)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _utilisatrices.length,
                  itemBuilder: (_, i) {
                    final u = _utilisatrices[i];
                    final prenom = (u['prenom'] ?? '?').toString();
                    final pseudo = (u['pseudo'] ?? '').toString();
                    return ListTile(
                      leading: AvatarGradient(
                          texte: prenom, taille: 44, seed: i),
                      title: Text(prenom,
                          style: AppText.corps(15, w: FontWeight.w600)),
                      subtitle: Text('@$pseudo',
                          style: AppText.corps(12,
                              color: AppColors.texteDoux)),
                      trailing: const Icon(Icons.chat_bubble_outline,
                          color: AppColors.rose, size: 20),
                      onTap: () => _ouvrir(u),
                    );
                  },
                ),
    );
  }
}
