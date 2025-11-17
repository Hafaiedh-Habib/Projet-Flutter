import 'package:flutter/material.dart';
import '../services/db.dart';

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
    final db = await DBService.instance.database;

    await db.insert('users', {
      'nom': nomCtrl.text,
      'prenom': prenomCtrl.text,
      'numero': numeroCtrl.text,
      'mot_de_passe': mdpCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nomCtrl, decoration: InputDecoration(labelText: "Nom")),
            TextField(controller: prenomCtrl, decoration: InputDecoration(labelText: "Prénom")),
            TextField(controller: numeroCtrl, decoration: InputDecoration(labelText: "Numéro")),
            TextField(controller: mdpCtrl, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Créer le compte"),
              onPressed: () async {
                await register();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
