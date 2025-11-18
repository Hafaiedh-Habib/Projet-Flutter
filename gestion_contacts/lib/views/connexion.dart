import 'package:flutter/material.dart';
import '../services/db.dart';
import '../models/user.dart';
import 'inscription.dart';
import 'accueil.dart';

class ConnexionPage extends StatefulWidget {
  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final numeroCtrl = TextEditingController();
  final mdpCtrl = TextEditingController();

  Future<void> login() async {
    if (nomCtrl.text.isEmpty ||
        prenomCtrl.text.isEmpty ||
        numeroCtrl.text.isEmpty ||
        mdpCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tous les champs sont obligatoires"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    User? user = await DB.instance.login(
      nomCtrl.text.trim().toLowerCase(),
      prenomCtrl.text.trim().toLowerCase(),
      numeroCtrl.text.trim(),
      mdpCtrl.text.trim(),
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AccueilPage(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Informations incorrectes"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.indigo.shade700),
      filled: true,
      fillColor: Colors.indigo.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.indigo, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        title: Text("Connexion"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(controller: nomCtrl, decoration: inputStyle("Nom")),
            SizedBox(height: 12),
            TextField(controller: prenomCtrl, decoration: inputStyle("Prénom")),
            SizedBox(height: 12),
            TextField(
              controller: numeroCtrl,
              decoration: inputStyle("Numéro"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            TextField(
              controller: mdpCtrl,
              decoration: inputStyle("Mot de passe"),
              obscureText: true,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text("Se connecter", style: TextStyle(fontSize: 16)),
              onPressed: login,
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text(
                "Créer un compte",
                style: TextStyle(
                  color: Colors.indigo.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InscriptionPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
