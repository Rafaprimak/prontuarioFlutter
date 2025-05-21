import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';

class AppointmentService {
  final CollectionReference appointmentsCollection = 
      FirebaseFirestore.instance.collection('appointments');
  
  // Add a new appointment
  Future<String> addAppointment(Appointment appointment) async {
    DocumentReference docRef = await appointmentsCollection.add(appointment.toMap());
    return docRef.id;
  }
  
  // Get all appointments
  Stream<List<Appointment>> getAppointments() {
    return appointmentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Appointment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
  
  // Get appointments by date
  Stream<List<Appointment>> getAppointmentsByDate(DateTime date) {
    // Start and end of the selected date
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return appointmentsCollection
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Appointment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }
  
  // Cancel an appointment
  Future<void> cancelAppointment(String id) async {
    return appointmentsCollection.doc(id).update({'status': 'cancelled'});
  }
}