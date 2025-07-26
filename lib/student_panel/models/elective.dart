import 'dart:convert';
class Elective {
  final String id;
  final String course;
  final String instructor;
  final String type;
  final List<String> years;
  final String description;
  
  int? priority;

  Elective({
    required this.id,
    required this.course,
    required this.instructor,
    required this.type,
    required this.years,
    required this.description,
    this.priority,
  });

  factory Elective.fromJson(Map<String, dynamic> json) {
    final rawYears = json['years'];
    return Elective(
      id: json['id'],
      course: json['course'],
      instructor: json['instructor'],
      type: json['type'],
      years: rawYears is String
          ? List<String>.from(jsonDecode(rawYears))
          : List<String>.from(rawYears ?? []),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course,
      'instructor': instructor,
      'type': type,
      'years': years,
      'description': description,
    };
  }
}
