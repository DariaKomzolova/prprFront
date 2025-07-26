import 'dart:convert';
import 'package:http/http.dart' as http;

class ProgramsApiService {
  final String baseUrl = 'https://prprback.onrender.com/programs';

  Future<List<Map<String, dynamic>>> fetchPrograms() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load programs');
    }
  }

  Future<void> createProgram(Map<String, dynamic> program) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(program),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create program');
    }
  }

  Future<void> updateProgram(String name, Map<String, dynamic> program) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$name'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(program),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update program');
    }
  }

  Future<void> deleteProgram(String name) async {
    final response = await http.delete(Uri.parse('$baseUrl/$name'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete program');
    }
  }
}
