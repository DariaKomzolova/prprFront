import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://prprback.onrender.com';

  static Future<bool> sendCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-code'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-code'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      return null;
    }
  }

  static Future<String> getStudentYearFromChoice(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/student_choice/${Uri.encodeComponent(email)}')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['program'];
    } else {
      throw Exception('Failed to load student year');
    }
  }
}
