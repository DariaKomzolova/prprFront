import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/elective.dart';
import '../services/programs_api_service.dart';

class ElectivesApiService {
  final _client = Supabase.instance.client;
  final ProgramsApiService _programsApiService = ProgramsApiService();

  Future<List<Elective>> fetchElectives() async {
    final response = await _client.from('electives').select();
    return (response as List)
        .map((e) => Elective.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addElective(Elective elective) async {
  print('TRYING TO ADD TO SUPABASE');
  try {
    final response = await _client
        .from('electives')
        .insert({
          'course': elective.course,
          'instructor': elective.instructor,
          'type': elective.type,
          'years': elective.years,
          'description': elective.description,
        })
        .select();

    print('INSERTED: $response');
  } catch (e) {
    print('ERROR DURING INSERT: $e');
  }
}


  Future<void> deleteElective(String id) async {
    await _client.from('electives').delete().eq('id', id);
  }

  Future<void> updateElective(String id, Elective updated) async {
    await _client.from('electives').update(updated.toJson()).eq('id', id);
  }

  Future<List<String>> fetchAvailablePrograms() async {
  /*   final response = await _client.from('Programs').select('name');

    final data = response as List<dynamic>;

    return data.map((item) => item['name'] as String).toList(); */

    final programs = await _programsApiService.fetchPrograms();
    return programs.map((p) => p['name'] as String).toList();
  }
}
