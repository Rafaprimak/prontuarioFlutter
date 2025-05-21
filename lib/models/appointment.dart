class Appointment {
  final String id;
  final String patientId;
  final String patientName; // For easier display
  final DateTime date;
  final String time;
  final String specialty;
  final String doctor;
  final String status; // 'scheduled', 'completed', 'cancelled'

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.time,
    required this.specialty,
    required this.doctor,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'time': time,
      'specialty': specialty,
      'doctor': doctor,
      'status': status,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      date: DateTime.parse(map['date']),
      time: map['time'] ?? '',
      specialty: map['specialty'] ?? '',
      doctor: map['doctor'] ?? '',
      status: map['status'] ?? 'scheduled',
    );
  }
}