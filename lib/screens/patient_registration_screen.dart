import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/patient_service.dart';
import 'package:intl/intl.dart';

class PatientRegistrationScreen extends StatefulWidget {
  @override
  _PatientRegistrationScreenState createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _birthDate;
  final PatientService _patientService = PatientService();
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Paciente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o telefone';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_birthDate == null 
                  ? 'Selecione a data de nascimento' 
                  : 'Data: ${DateFormat('dd/MM/yyyy').format(_birthDate!)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _birthDate != null) {
                    // Cria novo paciente
                    Patient newPatient = Patient(
                      id: '', // Será definido pelo Firestore
                      name: _nameController.text,
                      phone: _phoneController.text,
                      birthDate: _birthDate!,
                    );
                    
                    // Salva no Firebase
                    _patientService.addPatient(newPatient).then((patientId) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Paciente cadastrado com sucesso!'))
                      );
                      Navigator.pop(context); // Volta para tela anterior
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar paciente: $error'))
                      );
                    });
                  } else if (_birthDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selecione a data de nascimento'))
                    );
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}