import 'package:flutter/material.dart';
import 'package:loginsso/admin_panel/models/elective.dart';
import 'package:loginsso/admin_panel/services/electives_api_service.dart';

class ElectivesProviderInstr extends ChangeNotifier {
  final ElectivesApiService _apiService = ElectivesApiService();

  List<Elective> electives = [];
  bool showForm = false;

  final formKey = GlobalKey<FormState>();

  final courseController = TextEditingController();
  final instructorController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedType;
  List<String> selectedCourses = [];

  int? editingIndex;

  ElectivesProviderAdmin() {
    fetchElectives();
  }

  Future<void> fetchElectives() async {
    electives = await _apiService.fetchElectives();
    notifyListeners();
  }

  void toggleFormVisibility() {
    showForm = !showForm;
    if (!showForm) cancelEditing();
    notifyListeners();
  }

  void setSelectedType(String? value) {
    selectedType = value;
    notifyListeners();
  }

  void setSelectedCourses(List<String> value) {
    selectedCourses = value;
    notifyListeners();
  }

  void startEditing(int index) {
    final e = electives[index];
    editingIndex = index;
    courseController.text = e.course;
    instructorController.text = e.instructor;
    descriptionController.text = e.description;
    selectedType = e.type;
    selectedCourses = List.from(e.years);
    showForm = true;
    notifyListeners();
  }

  void cancelEditing() {
    editingIndex = null;
    courseController.clear();
    instructorController.clear();
    descriptionController.clear();
    selectedType = null;
    selectedCourses = [];
    showForm = false;
    notifyListeners();
  }

  Future<void> saveElective() async {
    print('SAVE CLICKED');
    if (!formKey.currentState!.validate()) {
      print('FORM NOT VALID');
      return;
    }
    if (!formKey.currentState!.validate()) return;

    final elective = Elective(
      id: editingIndex != null ? electives[editingIndex!].id : '',
      course: courseController.text,
      instructor: instructorController.text,
      type: selectedType ?? '',
      years: selectedCourses,
      description: descriptionController.text,
    );

    if (editingIndex != null) {
      await _apiService.updateElective(elective.id, elective);
    } else {
      await _apiService.addElective(elective);
    }

    await fetchElectives();
    cancelEditing();
  }

  Future<void> removeElective(int index) async {
    final id = electives[index].id;
    await _apiService.deleteElective(id);
    await fetchElectives();
  }

  @override
  void dispose() {
    courseController.dispose();
    instructorController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
