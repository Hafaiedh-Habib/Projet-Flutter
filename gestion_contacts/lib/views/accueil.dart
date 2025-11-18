import 'package:flutter/material.dart';
import '../models/user.dart';

class AccueilPage extends StatelessWidget {
  final User user;
  const AccueilPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: Center(
        child: Text(
          "Bienvenue, ${user.nom} ${user.prenom} !",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
