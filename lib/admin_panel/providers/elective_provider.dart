import 'package:flutter/material.dart';
import 'package:loginsso/admin_panel/models/elective.dart';
import 'package:loginsso/admin_panel/services/electives_api_service.dart';

class ElectivesProviderAdmin extends ChangeNotifier {
  final ElectivesApiService _apiService = ElectivesApiService();

  List<Elective> electives = [];
  List<String> availablePrograms = [];

  bool showForm = false;

  final formKey = GlobalKey<FormState>();

  final courseController = TextEditingController();
  final instructorController = TextEditingController();
  final descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String? selectedType;
  List<String> selectedCourses = [];

 int? editingIndex;


  String typeFilter = 'All';
  String instructorFilter = 'All';
  String yearFilter = 'All';
  String searchQuery = '';

  ElectivesProviderAdmin() {
    fetchElectives();
    fetchAvailablePrograms();
  }

  Future<void> fetchElectives() async {
    electives = await _apiService.fetchElectives();
    notifyListeners();
  }

  Future<void> fetchAvailablePrograms() async {
    availablePrograms = await _apiService.fetchAvailablePrograms();
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
    await fetchAvailablePrograms();
    cancelEditing();
  }

  Future<void> removeElectiveById(String id) async {
  await _apiService.deleteElective(id);
  electives.removeWhere((e) => e.id == id);
  notifyListeners();
}


  void setTypeFilter(String type) {
    typeFilter = type;
    notifyListeners();
  }

  void setInstructorFilter(String instructor) {
    instructorFilter = instructor;
    notifyListeners();
  }

  void setYearFilter(String year) {
    yearFilter = year;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    searchController.text = query;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );
    notifyListeners();
  }

  void clearFilters() {
    typeFilter = 'All';
    instructorFilter = 'All';
    yearFilter = 'All';
    notifyListeners();
  }

  List<Elective> get filteredElectives {
    return electives.where((e) {
      final matchesType = typeFilter == 'All' || e.type == typeFilter;
      final matchesInstructor = instructorFilter == 'All' || e.instructor == instructorFilter;
      final matchesYear = yearFilter == 'All' || e.years.contains(yearFilter);

      final matchesSearch = searchQuery.isEmpty ||
          e.course.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.instructor.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.type.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.years.any((year) => year.toLowerCase().contains(searchQuery.toLowerCase()));

      return matchesType && matchesInstructor && matchesYear && matchesSearch;
    }).toList();
  }

  List<String> get availableInstructors {
    final set = electives.map((e) => e.instructor).toSet().toList()..sort();
    return ['All', ...set];
  }

  List<String> get availableYears {
    final set = electives.expand((e) => e.years).toSet().toList()..sort();
    return ['All', ...set];
  }

  @override
  void dispose() {
    courseController.dispose();
    instructorController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
