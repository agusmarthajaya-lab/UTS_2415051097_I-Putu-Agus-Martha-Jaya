import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  final String _baseUrl = 'https://zenquotes.io/api/random';

  Future<QuoteModel> fetchDailyQuote() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return QuoteModel.fromJson(data[0]);
      } else {
        throw Exception('Gagal memuat quote motivasi.');
      }
    } catch (e) {
      return QuoteModel(
        quote: "Do small things with great love.",
        author: "Mother Teresa",
      );
    }
  }
}