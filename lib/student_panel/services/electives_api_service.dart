import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/elective.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ElectivesApiService {
  final String baseUrl = 'https://prprback.onrender.com';
  final supabase = Supabase.instance.client;

  Future<List<Elective>> fetchElectives() async {
    final data = await supabase.from('electives').select('*');
    return (data as List<dynamic>)
        .map((e) => Elective.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, String>> getDeadline() async {
  final url = Uri.parse('$baseUrl/deadline');
  final response = await http.get(url);

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


  Future<void> submitChoices(String email, List<String?> tech, List<String?> hum) async {
    final url = Uri.parse('$baseUrl/student_choice/update');

    final body = {
      "email": email,
      "tech1": tech[0],
      "tech2": tech[1],
      "tech3": tech[2],
      "tech4": tech[3],
      "tech5": tech[4],
      "hum1": hum[0],
      "hum2": hum[1],
      "hum3": hum[2],
      "hum4": hum[3],
      "hum5": hum[4],
    };

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit choices');
    }
  }
}
