import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/db.dart';

class ModifierContactPage extends StatefulWidget {
  final Contact contact;
  const ModifierContactPage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ModifierContactPage> createState() => _ModifierContactPageState();
}

class _ModifierContactPageState extends State<ModifierContactPage> {
  late TextEditingController nomCtrl;
  late TextEditingController prenomCtrl;
  late TextEditingController numeroCtrl;

  @override
  void initState() {
    super.initState();
    nomCtrl = TextEditingController(text: widget.contact.nom);
    prenomCtrl = TextEditingController(text: widget.contact.prenom);
    numeroCtrl = TextEditingController(text: widget.contact.numero);
  }

  Future<void> modifierContact() async {
    if (nomCtrl.text.isEmpty ||
        prenomCtrl.text.isEmpty ||
        numeroCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tous les champs sont obligatoires"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedContact = Contact(
      id: widget.contact.id,
      nom: nomCtrl.text.trim().toLowerCase(),
      prenom: prenomCtrl.text.trim().toLowerCase(),
      numero: numeroCtrl.text.trim(),
      userId: widget.contact.userId,
    );

    await DB.instance.updateContact(updatedContact);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Contact modifié avec succès"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.indigo.shade700),
      prefixIcon: Icon(icon, color: Colors.indigo.shade600),
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
        title: Text("Modifier le contact"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.edit,
              size: 80,
              color: Colors.indigo.shade600,
            ),
            SizedBox(height: 30),
            TextField(
              controller: nomCtrl,
              decoration: inputStyle("Nom", Icons.person_outline),
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16),
            TextField(
              controller: prenomCtrl,
              decoration: inputStyle("Prénom", Icons.person),
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16),
            TextField(
              controller: numeroCtrl,
              decoration: inputStyle("Numéro de téléphone", Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
              onPressed: modifierContact,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                  SizedBox(width: 8),
                  Text("Mettre à jour", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo.shade700,
                minimumSize: Size(double.infinity, 52),
                side: BorderSide(color: Colors.indigo.shade700, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomCtrl.dispose();
    prenomCtrl.dispose();
    numeroCtrl.dispose();
    super.dispose();
  }
}