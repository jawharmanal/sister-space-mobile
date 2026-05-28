// 🌸 Écran Messages — liste de conversations connectée à l'API
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';
import 'nouvelle_conversation_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<dynamic> _conversations = [];
  bool _chargement = true;
  String? _erreur;

  // Couleurs pastel cycliques pour les avatars
  static const _couleurs = [
    AppColors.catRose,
    AppColors.catBleu,
    AppColors.catVert,
    AppColors.catJaune,
    AppColors.catViolet,
    AppColors.catOrange,
  ];

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
      final convs = await ApiService.getConversations();
      setState(() {
        _conversations = convs;
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // En-tête
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages',
                  style: AppText.titreItalic(24),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const NouvelleConversationScreen()),
                  ).then((_) => _charger()),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.rose,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages',
                hintStyle: const TextStyle(color: AppColors.texteDoux),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.texteDoux),
                filled: true,
                fillColor: AppColors.blanc,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Liste
          Expanded(
            child: _chargement
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.rose))
                : _erreur != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(_erreur!,
                              style: const TextStyle(color: AppColors.erreur),
                              textAlign: TextAlign.center),
                        ),
                      )
                    : _conversations.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'Pas encore de conversation 🌸\nDémarre-en une depuis un profil !',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.texteDoux),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            color: AppColors.rose,
                            onRefresh: _charger,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: _conversations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 4),
                              itemBuilder: (_, i) =>
                                  _tile(_conversations[i], i),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _tile(dynamic c, int index) {
    // Champs renvoyés par ton service back :
    // id, derniere_activite, id_autre, autre_prenom, autre_pseudo,
    // dernier_message, date_dernier_message, nb_non_lus
    final prenom = (c['autre_prenom'] ?? '?').toString();
    final initiale = prenom.isNotEmpty ? prenom[0].toUpperCase() : '?';
    final dernier = c['dernier_message']?.toString() ?? '(aucun message)';
    final nbNonLus = int.tryParse(c['nb_non_lus']?.toString() ?? '0') ?? 0;
    final couleur = _couleurs[index % _couleurs.length];
    final idConv = int.tryParse(c['id'].toString()) ?? 0;

    String heure = '';
    final dateRaw = c['date_dernier_message']?.toString();
    if (dateRaw != null && dateRaw.length >= 16) {
      // ex "2026-05-27T14:32:00..." → "14:32"
      heure = dateRaw.substring(11, 16);
    }

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: couleur,
            child: Text(
              initiale,
              style: const TextStyle(
                color: AppColors.texte,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (nbNonLus > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.rose,
                  shape: BoxShape.circle,
                ),
                constraints:
                    const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '$nbNonLus',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        prenom,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: AppColors.texte),
      ),
      subtitle: Text(
        dernier,
        style: TextStyle(
          color: nbNonLus > 0 ? AppColors.texte : AppColors.texteDoux,
          fontSize: 13,
          fontWeight: nbNonLus > 0 ? FontWeight.w600 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        heure,
        style: const TextStyle(color: AppColors.texteDoux, fontSize: 12),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            idConversation: idConv,
            nom: prenom,
            couleur: couleur,
          ),
        ),
      ).then((_) => _charger()), // refresh au retour pour màj non lus
    );
  }
}
