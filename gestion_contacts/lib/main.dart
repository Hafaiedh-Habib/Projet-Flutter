import 'package:flutter/material.dart';
import 'views/connexion.dart';
import 'services/db.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Obligatoire pour utiliser SQLite avant runApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login SQLite',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConnexionPage(),
    );
  }
}