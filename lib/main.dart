import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/prontuario_list_screen.dart'; // Tela principal com lista de prontuários
import 'firebase_options.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter está pronto antes de iniciar
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Inicializa o Firebase com configurações da plataforma
  );
  runApp(MyApp()); // Inicia o app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prontuário Eletrônico',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ProntuarioListScreen(), // Tela inicial do app
    );
    }
  }