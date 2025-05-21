import 'package:flutter/material.dart';
import 'patient_registration_screen.dart';
import 'appointment_scheduling_screen.dart';
import 'daily_appointments_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Agendamento Médico'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: <Widget>[
            _buildMenuCard(
              context,
              'Cadastrar Paciente',
              Icons.person_add,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientRegistrationScreen()),
              ),
            ),
            _buildMenuCard(
              context,
              'Agendar Consulta',
              Icons.calendar_today,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppointmentSchedulingScreen()),
              ),
            ),
            _buildMenuCard(
              context,
              'Consultas do Dia',
              Icons.view_list,
              Colors.amber,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DailyAppointmentsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 64.0,
              color: color,
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}