import 'package:flutter/material.dart';
import '../services/db.dart';
import '../models/user.dart';

class InscriptionPage extends StatefulWidget {
  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final numeroCtrl = TextEditingController();
  final mdpCtrl = TextEditingController();

  Future<void> register() async {
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

    await DB.instance.insertUser(User(
      nom: nomCtrl.text.trim().toLowerCase(),
      prenom: prenomCtrl.text.trim().toLowerCase(),
      numero: numeroCtrl.text.trim(),
      motDePasse: mdpCtrl.text.trim(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Compte créé avec succès"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
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
        title: Text("Inscription"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
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
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
              child: Text("Créer le compte", style: TextStyle(fontSize: 16)),
              onPressed: register,
            ),
          ],
        ),
      ),
    );
  }
}
