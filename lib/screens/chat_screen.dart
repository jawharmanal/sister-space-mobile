// 🌸 Écran Chat — conversation connectée à l'API
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final int idConversation;
  final String nom;
  final Color couleur;
  const ChatScreen({
    super.key,
    required this.idConversation,
    required this.nom,
    required this.couleur,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  List<dynamic> _messages = [];
  int? _monId; // id de l'utilisatrice connectée
  bool _chargement = true;
  bool _envoi = false;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Récupère mon id (stocké au login)
    final moi = await ApiService.getUtilisatrice();
    _monId = int.tryParse(moi?['id'].toString() ?? '');
    await _charger();
  }

  Future<void> _charger() async {
    try {
      final data = await ApiService.getMessages(widget.idConversation);
      setState(() {
        _messages = (data['messages'] as List?) ?? [];
        _chargement = false;
      });
      // scroll en bas après affichage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    } catch (e) {
      setState(() {
        _erreur = e.toString().replaceAll('Exception: ', '');
        _chargement = false;
      });
    }
  }

  Future<void> _envoyer() async {
    final texte = _ctrl.text.trim();
    if (texte.isEmpty || _envoi) return;
    setState(() => _envoi = true);
    try {
      await ApiService.envoyerMessage(widget.idConversation, texte);
      _ctrl.clear();
      await _charger();
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
    return Scaffold(
      backgroundColor: AppColors.roseBg,
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
              decoration: const BoxDecoration(
                color: AppColors.blanc,
                border: Border(
                  bottom: BorderSide(color: AppColors.bordure, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: AppColors.texte, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: widget.couleur,
                    child: Text(
                      widget.nom.isNotEmpty
                          ? widget.nom[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          color: AppColors.texte,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.nom,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.texte,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Corps : messages
            Expanded(
              child: _chargement
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.rose))
                  : _erreur != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(_erreur!,
                                style: const TextStyle(
                                    color: AppColors.erreur),
                                textAlign: TextAlign.center),
                          ),
                        )
                      : _messages.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun message encore\nÉcris le premier 🌸',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: AppColors.texteDoux),
                              ),
                            )
                          : ListView.builder(
                              controller: _scroll,
                              padding: const EdgeInsets.all(16),
                              itemCount: _messages.length,
                              itemBuilder: (_, i) {
                                final m = _messages[i];
                                final idExp = int.tryParse(
                                    m['id_expeditrice'].toString());
                                final moi = idExp == _monId;
                                return Align(
                                  alignment: moi
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    constraints: const BoxConstraints(
                                        maxWidth: 260),
                                    decoration: BoxDecoration(
                                      color: moi
                                          ? AppColors.rose
                                          : AppColors.blanc,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(18),
                                        topRight: const Radius.circular(18),
                                        bottomLeft: Radius.circular(
                                            moi ? 18 : 4),
                                        bottomRight: Radius.circular(
                                            moi ? 4 : 18),
                                      ),
                                    ),
                                    child: Text(
                                      m['contenu']?.toString() ?? '',
                                      style: TextStyle(
                                        color: moi
                                            ? Colors.white
                                            : AppColors.texte,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
            // Zone de saisie
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.blanc),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: (_) => _envoyer(),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle:
                            const TextStyle(color: AppColors.texteDoux),
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
                    onTap: _envoi ? null : _envoyer,
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
                          : const Icon(Icons.send,
                              color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
