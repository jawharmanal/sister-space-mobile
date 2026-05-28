// 🌸 Service d'upload d'images vers Cloudinary
// Même logique que ton site web : upload direct (unsigned preset).
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'dlqr1ku21';
  static const String uploadPreset = 'sister_space_unsigned';

  /// Ouvre le sélecteur d'image, upload vers Cloudinary, retourne l'URL.
  /// Retourne null si l'utilisatrice annule.
  static Future<String?> choisirEtUploader() async {
    final picker = ImagePicker();
    final XFile? fichier =
        await picker.pickImage(source: ImageSource.gallery);
    if (fichier == null) return null; // annulé

    // Lire les octets (compatible web ET mobile)
    final bytes = await fichier.readAsBytes();

    // Vérif taille (5 Mo max, comme ton web)
    if (bytes.length > 5 * 1024 * 1024) {
      throw Exception('Image trop lourde (max 5 Mo)');
    }

    // Préparer la requête multipart
    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fichier.name,
      ));

    final reponse = await request.send();
    final corps = await reponse.stream.bytesToString();

    if (reponse.statusCode != 200) {
      throw Exception('Échec de l\'upload de l\'image');
    }

    final data = jsonDecode(corps);
    return data['secure_url'] as String; // URL HTTPS publique
  }
}
