import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loginsso/student_panel/models/elective.dart';
import 'package:loginsso/student_panel/services/electives_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:loginsso/login/app_state.dart';

class ElectivesProviderStudent extends ChangeNotifier {
  final ElectivesApiService _apiService = ElectivesApiService();
  final AppState appState;

  String? deadlineStart;
  String? deadlineEnd;


  List<Elective> all = [];

  final Map<String, int> selectedTech = {};
  final Map<String, int> selectedHum = {};

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String instructorFilter = 'All';

  bool isSubmittedTech = false;
  bool isSubmittedHum = false;

  String? studentProgram;

  ElectivesProviderStudent(this.appState) {
    _init();
  }

  Future<void> _init() async {
    if (appState.email != null && appState.year != null) {
      await loadElectives(appState.year!);
      await reloadChoices(appState.email!);
    }
  }

  Future<void> loadDeadline() async {
  final deadline = await _apiService.getDeadline();
  deadlineStart = deadline['start'];
  deadlineEnd = deadline['end'];
  notifyListeners();
}


  void setSearchQuery1(String query) {
  searchQuery = query;
  notifyListeners();
}


  Future<void> loadElectives(String program) async {
    final allElectives = await _apiService.fetchElectives();
    all = allElectives.where((e) => e.years.contains(program)).toList();
    studentProgram = program;
    notifyListeners();
  }

  List<Elective> filtered(List<Elective> list) {
    return list.where((e) {
      final matchesSearch = searchQuery.isEmpty ||
          e.course.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.instructor.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesInstructor = instructorFilter == 'All' || e.instructor == instructorFilter;
      return matchesSearch && matchesInstructor;
    }).toList();
  }

  List<Elective> get techElectives => filtered(all.where((e) => e.type == 'Tech').toList());
  List<Elective> get humElectives => filtered(all.where((e) => e.type == 'Hum').toList());

  List<String> get availableInstructors {
    final set = all.map((e) => e.instructor).toSet().toList()..sort();
    return ['All', ...set];
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setInstructorFilter(String instructor) {
    instructorFilter = instructor;
    notifyListeners();
  }

  void clearFilters() {
    searchQuery = '';
    instructorFilter = 'All';
    searchController.clear();
    notifyListeners();
  }

  void selectTech(String id, int priority) {
    selectedTech[id] = priority;
    isSubmittedTech = false;
    notifyListeners();
  }

  void selectHum(String id, int priority) {
    selectedHum[id] = priority;
    isSubmittedHum = false;
    notifyListeners();
  }

  void removeTech(String id) {
    selectedTech.remove(id);
    isSubmittedTech = false;
    notifyListeners();
  }

  void removeHum(String id) {
    selectedHum.remove(id);
    isSubmittedHum = false;
    notifyListeners();
  }

  Future<void> submitTechChoices() async {
    final body = {
      "email": appState.email,
      "tech1": null,
      "tech2": null,
      "tech3": null,
      "tech4": null,
      "tech5": null,
      "hum1": null,
      "hum2": null,
      "hum3": null,
      "hum4": null,
      "hum5": null,
    };

    for (final e in all) {
      if (e.type == 'Tech' && selectedTech.containsKey(e.id)) {
        final priority = selectedTech[e.id]!;
        body["tech$priority"] = e.course;
      }
    }

    for (final e in all) {
      if (e.type == 'Hum' && selectedHum.containsKey(e.id)) {
        final priority = selectedHum[e.id]!;
        body["hum$priority"] = e.course;
      }
    }

    final url = Uri.parse('https://prprback.onrender.com/student_choice/update');

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit tech choices');
    }

    isSubmittedTech = true;
    notifyListeners();
  }

  Future<void> submitHumChoices() async {
    final body = {
      "email": appState.email,
      "tech1": null,
      "tech2": null,
      "tech3": null,
      "tech4": null,
      "tech5": null,
      "hum1": null,
      "hum2": null,
      "hum3": null,
      "hum4": null,
      "hum5": null,
    };

    for (final e in all) {
      if (e.type == 'Hum' && selectedHum.containsKey(e.id)) {
        final priority = selectedHum[e.id]!;
        body["hum$priority"] = e.course;
      }
    }

    for (final e in all) {
      if (e.type == 'Tech' && selectedTech.containsKey(e.id)) {
        final priority = selectedTech[e.id]!;
        body["tech$priority"] = e.course;
      }
    }

    final url = Uri.parse('https://prprback.onrender.com/student_choice/update');

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit hum choices');
    }

    isSubmittedHum = true;
    notifyListeners();
  }

  Future<void> reloadChoices(String email) async {
    final response = await http.get(Uri.parse('https://prprback.onrender.com/student_choice/$email'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      selectedTech.clear();
      selectedHum.clear();

      for (final e in all) {
        if (e.type == 'Tech') {
          for (int i = 1; i <= 5; i++) {
            if (data['tech$i'] == e.course) {
              selectedTech[e.id] = i;
            }
          }
        } else if (e.type == 'Hum') {
          for (int i = 1; i <= 5; i++) {
            if (data['hum$i'] == e.course) {
              selectedHum[e.id] = i;
            }
          }
        }
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
