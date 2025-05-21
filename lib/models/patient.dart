class Patient {
  final String id;
  final String name;
  final String phone;
  final DateTime birthDate;

  Patient({
    required this.id, 
    required this.name, 
    required this.phone, 
    required this.birthDate
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map, String id) {
    return Patient(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      birthDate: DateTime.parse(map['birthDate']),
    );
  }
}