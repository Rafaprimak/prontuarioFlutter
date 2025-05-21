import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/appointment.dart';
import '../services/patient_service.dart';
import '../services/appointment_service.dart';
import 'package:intl/intl.dart';

class AppointmentSchedulingScreen extends StatefulWidget {
  @override
  _AppointmentSchedulingScreenState createState() => _AppointmentSchedulingScreenState();
}

class _AppointmentSchedulingScreenState extends State<AppointmentSchedulingScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientService _patientService = PatientService();
  final AppointmentService _appointmentService = AppointmentService();
  
  Patient? _selectedPatient;
  DateTime? _appointmentDate;
  String? _appointmentTime;
  String? _specialty;
  String? _doctor;
  
  List<String> _specialties = ['Clínica Geral', 'Cardiologia', 'Dermatologia', 'Pediatria', 'Ortopedia'];
  List<String> _doctors = ['Dr. Silva', 'Dra. Santos', 'Dr. Oliveira', 'Dra. Costa'];
  List<String> _timeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30'
  ];
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _appointmentDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );
    if (picked != null && picked != _appointmentDate) {
      setState(() {
        _appointmentDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Consulta'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown to select patient
              StreamBuilder<List<Patient>>(
                stream: _patientService.getPatients(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  
                  List<Patient> patients = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedPatient?.id, // Use ID instead of Patient object
                    decoration: InputDecoration(labelText: 'Paciente'),
                    items: patients.map((patient) {
                      return DropdownMenuItem<String>(
                        value: patient.id,
                        child: Text(patient.name),
                      );
                    }).toList(),
                    onChanged: (String? patientId) {
                      if (patientId != null) {
                        setState(() {
                          _selectedPatient = patients.firstWhere((patient) => patient.id == patientId);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um paciente';
                      }
                      return null;
                    },
                  );
                },
              ),
              
              SizedBox(height: 16),
              
              // Date picker
              ListTile(
                title: Text(_appointmentDate == null 
                  ? 'Selecione a data da consulta' 
                  : 'Data: ${DateFormat('dd/MM/yyyy').format(_appointmentDate!)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              
              SizedBox(height: 16),
              
              // Time dropdown
              DropdownButtonFormField<String>(
                value: _appointmentTime,
                decoration: InputDecoration(labelText: 'Horário'),
                items: _timeSlots.map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _appointmentTime = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um horário';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Specialty dropdown
              DropdownButtonFormField<String>(
                value: _specialty,
                decoration: InputDecoration(labelText: 'Especialidade'),
                items: _specialties.map((specialty) {
                  return DropdownMenuItem<String>(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _specialty = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma especialidade';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Doctor dropdown
              DropdownButtonFormField<String>(
                value: _doctor,
                decoration: InputDecoration(labelText: 'Médico'),
                items: _doctors.map((doctor) {
                  return DropdownMenuItem<String>(
                    value: doctor,
                    child: Text(doctor),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _doctor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um médico';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24),
              
              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _appointmentDate != null) {
                      // Criar nova consulta
                      Appointment newAppointment = Appointment(
                        id: '', // Será definido pelo Firestore
                        patientId: _selectedPatient!.id,
                        patientName: _selectedPatient!.name,
                        date: _appointmentDate!,
                        time: _appointmentTime!,
                        specialty: _specialty!,
                        doctor: _doctor!,
                        status: 'scheduled',
                      );
                      
                      // Salvar no Firebase
                      _appointmentService.addAppointment(newAppointment).then((appointmentId) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Consulta agendada com sucesso!'))
                        );
                        Navigator.pop(context); // Volta para a tela anterior
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao agendar consulta: $error'))
                        );
                      });
                    } else if (_appointmentDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selecione a data da consulta'))
                      );
                    }
                  },
                  child: Text('Agendar Consulta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}