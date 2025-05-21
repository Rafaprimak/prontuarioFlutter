import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class DailyAppointmentsScreen extends StatefulWidget {
  @override
  _DailyAppointmentsScreenState createState() => _DailyAppointmentsScreenState();
}

class _DailyAppointmentsScreenState extends State<DailyAppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();
  final AppointmentService _appointmentService = AppointmentService();
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas do Dia'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Consultas para ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _appointmentService.getAppointmentsByDate(_selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar consultas: ${snapshot.error}'));
                }
                
                List<Appointment> appointments = snapshot.data ?? [];
                if (appointments.isEmpty) {
                  return Center(child: Text('Não há consultas agendadas para esta data.'));
                }
                
                // Ordenar por horário
                appointments.sort((a, b) => a.time.compareTo(b.time));
                
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    Appointment appointment = appointments[index];
                    
                    // Definir cor baseada no status
                    Color statusColor;
                    switch (appointment.status) {
                      case 'scheduled':
                        statusColor = Colors.green;
                        break;
                      case 'cancelled':
                        statusColor = Colors.red;
                        break;
                      case 'completed':
                        statusColor = Colors.blue;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(appointment.time),
                        ),
                        title: Text(appointment.patientName),
                        subtitle: Text('${appointment.specialty} - ${appointment.doctor}'),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            appointment.status.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          // Mostrar opções para a consulta
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.info),
                                    title: Text('Detalhes da Consulta'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Navegar para tela de detalhes (a ser implementada)
                                    },
                                  ),
                                  if (appointment.status == 'scheduled')
                                    ListTile(
                                      leading: Icon(Icons.cancel, color: Colors.red),
                                      title: Text('Cancelar Consulta'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Confirmar cancelamento
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Cancelar Consulta'),
                                            content: Text('Tem certeza que deseja cancelar esta consulta?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  // Cancelar consulta
                                                  _appointmentService
                                                    .cancelAppointment(appointment.id)
                                                    .then((_) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Consulta cancelada com sucesso!'))
                                                      );
                                                    })
                                                    .catchError((error) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Erro ao cancelar consulta: $error'))
                                                      );
                                                    });
                                                },
                                                child: Text('Sim'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}