// 🌸 Service API — connexion à ton back-end Railway
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://sister-space-backend-production.up.railway.app/api';

  // --- TOKEN ---
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> seDeconnecter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('utilisatrice');
  }

  // --- UTILISATRICE COURANTE ---
  static Future<void> _setUtilisatrice(Map<String, dynamic> u) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('utilisatrice', jsonEncode(u));
  }

  static Future<Map<String, dynamic>?> getUtilisatrice() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('utilisatrice');
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final h = {'Content-Type': 'application/json'};
    if (auth) {
      final t = await getToken();
      if (t != null) h['Authorization'] = 'Bearer $t';
    }
    return h;
  }

  // --- AUTH ---
  // Inscription (POST /api/auth/register)
  static Future<void> inscrire({
    required String email,
    required String motDePasse,
    required String prenom,
    required String pseudo,
    required String dateNaissance, // format YYYY-MM-DD
    required int idVille,
    required String bio,
    required List<int> centresInteret,
    required bool identificationFemme,
    required bool acceptationCgu,
    required bool consentementDonnees,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _headers(),
      body: jsonEncode({
        'email': email,
        'mot_de_passe': motDePasse,
        'prenom': prenom,
        'pseudo': pseudo,
        'date_naissance': dateNaissance,
        'id_ville': idVille,
        'bio': bio,
        'centres_interet': centresInteret,
        'identification_femme': identificationFemme,
        'acceptation_cgu': acceptationCgu,
        'consentement_donnees': consentementDonnees,
      }),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 201) return;
    throw Exception(data['message'] ?? 'Erreur d\'inscription');
  }

  static Future<Map<String, dynamic>> seConnecter(
      String email, String motDePasse) async {
    final r = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'mot_de_passe': motDePasse}),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      await _setToken(data['data']['token']);
      await _setUtilisatrice(data['data']['utilisatrice']);
      return data['data']['utilisatrice'];
    }
    throw Exception(data['message'] ?? 'Connexion impossible');
  }

  // --- POSTS ---
  static Future<List<dynamic>> getPosts({int? categorie}) async {
    final url = categorie != null
        ? '$baseUrl/posts?categorie=$categorie'
        : '$baseUrl/posts';
    final r =
        await http.get(Uri.parse(url), headers: await _headers(auth: true));
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      return (data['data'] as List?) ?? [];
    }
    throw Exception(data['message'] ?? 'Impossible de charger les posts');
  }

  static Future<Map<String, dynamic>> creerPost(String contenu,
      {List<String>? photosUrls}) async {
    final r = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: await _headers(auth: true),
      body: jsonEncode({
        'contenu': contenu,
        if (photosUrls != null) 'photos_urls': photosUrls,
      }),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 201) return data['data'];
    throw Exception(data['message'] ?? 'Erreur création post');
  }

  static Future<void> likerPost(int id) async {
    await http.post(
      Uri.parse('$baseUrl/posts/$id/like'),
      headers: await _headers(auth: true),
    );
  }

  static Future<void> unlikePost(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/posts/$id/like'),
      headers: await _headers(auth: true),
    );
  }

  // Détail d'un post AVEC ses commentaires (GET /posts/:id)
  static Future<Map<String, dynamic>> getPostDetail(int id) async {
    final r = await http.get(
      Uri.parse('$baseUrl/posts/$id'),
      headers: await _headers(auth: true),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      return (data['data'] as Map).cast<String, dynamic>();
    }
    throw Exception(data['message'] ?? 'Erreur chargement du post');
  }

  // Ajouter un commentaire (POST /posts/:id/commentaires)
  static Future<void> creerCommentaire(int idPost, String contenu) async {
    final r = await http.post(
      Uri.parse('$baseUrl/posts/$idPost/commentaires'),
      headers: await _headers(auth: true),
      body: jsonEncode({'contenu': contenu}),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 201) return;
    throw Exception(data['message'] ?? 'Erreur commentaire');
  }

  // Lister les utilisatrices actives (pour démarrer une conversation)
  static Future<List<dynamic>> getUtilisatrices() async {
    final r = await http.get(
      Uri.parse('$baseUrl/utilisatrices'),
      headers: await _headers(auth: true),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) return (data['data'] as List?) ?? [];
    throw Exception(data['message'] ?? 'Erreur utilisatrices');
  }

  // Démarrer (ou récupérer) une conversation (POST /conversations)
  static Future<int> demarrerConversation(int idAutre) async {
    final r = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: await _headers(auth: true),
      body: jsonEncode({'id_utilisatrice_2': idAutre}),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200 || r.statusCode == 201) {
      final d = data['data'] ?? data;
      return int.parse(d['id'].toString());
    }
    throw Exception(data['message'] ?? 'Erreur conversation');
  }

  // ==================== PROFIL (PARAMÈTRES) ====================

  // Modifier mon profil (PUT /api/utilisatrices/moi)
  static Future<Map<String, dynamic>> modifierProfil({
    String? prenom,
    String? pseudo,
    String? bio,
    String? photoUrl,
  }) async {
    final r = await http.put(
      Uri.parse('$baseUrl/utilisatrices/moi'),
      headers: await _headers(auth: true),
      body: jsonEncode({
        if (prenom != null) 'prenom': prenom,
        if (pseudo != null) 'pseudo': pseudo,
        if (bio != null) 'bio': bio,
        if (photoUrl != null) 'photo_url': photoUrl,
      }),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      // Mettre à jour l'utilisatrice stockée localement
      final actuelle = await getUtilisatrice() ?? <String, dynamic>{};
      final Map<String, dynamic> maj = {
        ...actuelle,
        ...((data['data'] as Map?)?.cast<String, dynamic>() ?? {}),
      };
      await _setUtilisatrice(maj);
      return maj;
    }
    throw Exception(data['message'] ?? 'Erreur modification profil');
  }

  // Changer mon mot de passe (PUT /api/utilisatrices/moi/mot-de-passe)
  static Future<void> changerMotDePasse(
      String ancien, String nouveau) async {
    final r = await http.put(
      Uri.parse('$baseUrl/utilisatrices/moi/mot-de-passe'),
      headers: await _headers(auth: true),
      body: jsonEncode({
        'ancien_mot_de_passe': ancien,
        'nouveau_mot_de_passe': nouveau,
      }),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) return;
    throw Exception(data['message'] ?? 'Erreur changement mot de passe');
  }

  // Supprimer mon compte (DELETE /api/utilisatrices/moi)
  static Future<void> supprimerCompte(String motDePasse) async {
    final r = await http.delete(
      Uri.parse('$baseUrl/utilisatrices/moi'),
      headers: await _headers(auth: true),
      body: jsonEncode({'mot_de_passe': motDePasse}),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      await seDeconnecter();
      return;
    }
    throw Exception(data['message'] ?? 'Erreur suppression compte');
  }

  // ==================== MESSAGES / CONVERSATIONS ====================

  // Lister mes conversations
  static Future<List<dynamic>> getConversations() async {
    final r = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: await _headers(auth: true),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      if (data is Map && data['data'] != null) return data['data'] as List;
      if (data is List) return data;
      return [];
    }
    throw Exception(data['message'] ?? 'Erreur conversations');
  }

  // Récupérer les messages d'une conversation
  static Future<Map<String, dynamic>> getMessages(int idConversation) async {
    final r = await http.get(
      Uri.parse('$baseUrl/conversations/$idConversation/messages'),
      headers: await _headers(auth: true),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 200) {
      if (data is Map && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      }
      return data as Map<String, dynamic>;
    }
    throw Exception(data['message'] ?? 'Erreur messages');
  }

  // Envoyer un message
  static Future<Map<String, dynamic>> envoyerMessage(
      int idConversation, String contenu) async {
    final r = await http.post(
      Uri.parse('$baseUrl/conversations/$idConversation/messages'),
      headers: await _headers(auth: true),
      body: jsonEncode({'contenu': contenu}),
    );
    final data = jsonDecode(r.body);
    if (r.statusCode == 201 || r.statusCode == 200) {
      if (data is Map && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      }
      return data as Map<String, dynamic>;
    }
    throw Exception(data['message'] ?? 'Erreur envoi message');
  }
}
