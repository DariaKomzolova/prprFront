import 'package:http/http.dart' as http;
import 'dart:convert';

class DeadlineApiService {
  static const String baseUrl = 'https://prprback.onrender.com';

  static Future<void> setDeadline(String start, String end) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deadlines/set'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'start': start, 'end': end}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save deadline');
    }
  }

  static Future<Map<String, String?>> getDeadline() async {
    final response = await http.get(Uri.parse('$baseUrl/deadlines/get'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'start': data['start'],
        'end': data['end'],
      };
    } else {
      throw Exception('Failed to load deadline');
    }
  }
}
