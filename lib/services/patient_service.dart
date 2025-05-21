import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';

class PatientService {
  final CollectionReference patientsCollection = 
      FirebaseFirestore.instance.collection('patients');
  
  // Add a new patient
  Future<String> addPatient(Patient patient) async {
    DocumentReference docRef = await patientsCollection.add(patient.toMap());
    return docRef.id;
  }
  
  // Get all patients
  Stream<List<Patient>> getPatients() {
    return patientsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Patient.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
  
  // Get a specific patient
  Future<Patient?> getPatient(String id) async {
    DocumentSnapshot doc = await patientsCollection.doc(id).get();
    if (doc.exists) {
      return Patient.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
  
  // Update a patient
  Future<void> updatePatient(Patient patient) async {
    return patientsCollection.doc(patient.id).update(patient.toMap());
  }
  
  // Delete a patient
  Future<void> deletePatient(String id) async {
    return patientsCollection.doc(id).delete();
  }
}