import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cards.dart';

class CardApi {
  static Future<List<FetchedCards>> fetchCards(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Manalyze/1.0 (dev@manalyze.com)',
      },
    );

    final body = response.body;
    final json = jsonDecode(body);

    if (response.statusCode != 200) {
      throw Exception(json['details'] ?? 'Unable to fetch cards');
    }

    final data = json['data'] as List<dynamic>?;

    if (data == null) {
      throw Exception('Response did not contain a card list');
    }

    return data
        .map((e) => FetchedCards.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
