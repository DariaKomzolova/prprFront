class Elective {
  final String course;
  final String instructor;
  final String type;
  final List<String> selectedCourses;
  final String description;

  Elective({
    required this.course,
    required this.instructor,
    required this.type,
    required this.selectedCourses,
    required this.description,
  });

  factory Elective.fromMap(Map<String, dynamic> map) {
    return Elective(
      course: map['course'] ?? '',
      instructor: map['instructor'] ?? '',
      type: map['type'] ?? '',
      selectedCourses: List<String>.from(map['selectedCourses'] ?? []),
      description: map['description'] ?? '',
    );
  }

  List<String> toExcelRow() {
  return [
    course,
    instructor,
    type,
    selectedCourses.join(', '),
    description,
  ];
}


  Map<String, dynamic> toMap() {
    return {
      'course': course,
      'instructor': instructor,
      'type': type,
      'selectedCourses': selectedCourses,
      'description': description,
    };
  }
}
