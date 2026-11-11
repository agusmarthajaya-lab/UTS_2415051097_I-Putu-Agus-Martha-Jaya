import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  final String _endpoint = 'https://zenquotes.io/api/random';

  Future<QuoteModel> fetchDailyQuote() async {
    try {
      final response = await http
          .get(Uri.parse(_endpoint))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          return QuoteModel.fromJson(decoded[0]);
        } else if (decoded is Map<String, dynamic>) {
          return QuoteModel.fromJson(decoded);
        } else {
          throw Exception('Format data JSON API tidak sesuai.');
        }
      } else {
        throw Exception('Gagal menghubungi API quote (HTTP ${response.statusCode}).');
      }
    } catch (e) {
      // Melempar error agar state error di UI tertangkap dengan baik
      throw Exception('Gagal memuat kutipan online: ${e.toString()}');
    }
  }
}
