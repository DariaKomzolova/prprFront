class StudentChoice {
  final String email;
  final String year;
  final String tech1;
  final String tech2;
  final String tech3;
  final String tech4;
  final String tech5;
  final String hum1;
  final String hum2;
  final String hum3;
  final String hum4;
  final String hum5;

  StudentChoice({
    required this.email,
    required this.year,
    required this.tech1,
    required this.tech2,
    required this.tech3,
    required this.tech4,
    required this.tech5,
    required this.hum1,
    required this.hum2,
    required this.hum3,
    required this.hum4,
    required this.hum5,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'year': year,
    'tech1': tech1,
    'tech2': tech2,
    'tech3': tech3,
    'tech4': tech4,
    'tech5': tech5,
    'hum1': hum1,
    'hum2': hum2,
    'hum3': hum3,
    'hum4': hum4,
    'hum5': hum5,
  };
}
