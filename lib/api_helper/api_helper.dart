import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsAPI {
  static const String _apiKey =
      '043ed6bdf91d40b587f9a92a535edc78'; // Replace with your API key
  static Future<List<dynamic>> fetchNews() async {
    final Uri apiUrl = Uri.parse(
      'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$_apiKey',
    );

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
