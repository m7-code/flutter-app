import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const cloudName = 'mzz0bigf';
  static const uploadPreset = 'ecommerce_unsigned';

  static Future<String> uploadImage(File file) async {
    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final req = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final res = await req.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode != 200) {
      throw Exception('Upload failed: $body');
    }
    return jsonDecode(body)['secure_url'] as String;
  }
}