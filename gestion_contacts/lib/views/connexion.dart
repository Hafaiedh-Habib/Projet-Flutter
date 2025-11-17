import 'package:flutter/material.dart';
import '../services/db.dart';
import 'accueil.dart';
import 'inscription.dart';
import '../../models/user.dart';
/* import 'package:sqflite/sqflite.dart'; */

class ConnexionPage extends StatefulWidget {
  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final numeroCtrl = TextEditingController();
  final mdpCtrl = TextEditingController();

  Future<User?> login() async {
    final db = await DBService.instance.database;

    final res = await db.query(
      'users',
      where: 'numero = ? AND mot_de_passe = ?',
      whereArgs: [numeroCtrl.text, mdpCtrl.text],
    );

    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: numeroCtrl,
              decoration: InputDecoration(labelText: "Numéro"),
            ),
            TextField(
              controller: mdpCtrl,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Se connecter"),
              onPressed: () async {
                final user = await login();
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => AccueilPage(user: user)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Identifiants incorrects")),
                  );
                }
              },
            ),
            TextButton(
              child: Text("Créer un compte"),
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
