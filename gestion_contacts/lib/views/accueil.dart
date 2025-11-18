import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/contact.dart';
import '../services/db.dart';
import 'ajouter_contact.dart';
import 'modifier_contact.dart';

class AccueilPage extends StatefulWidget {
  final User user;
  const AccueilPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  final searchCtrl = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    setState(() => isLoading = true);
    final data = await DB.instance.getContactsByUser(widget.user.id!);
    setState(() {
      contacts = data;
      filteredContacts = data;
      isLoading = false;
    });
  }

  void searchContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = contacts;
      } else {
        filteredContacts = contacts.where((contact) {
          return contact.nom.toLowerCase().contains(query.toLowerCase()) ||
              contact.prenom.toLowerCase().contains(query.toLowerCase()) ||
              contact.numero.contains(query);
        }).toList();
      }
    });
  }

  Future<void> deleteContact(Contact contact) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirmation"),
        content: Text("Voulez-vous vraiment supprimer ce contact ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DB.instance.deleteContact(contact.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Contact supprimé"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      loadContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text("Mes Contacts"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.indigo.shade600,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Text(
                  "Bienvenue, ${widget.user.prenom} ${widget.user.nom}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: searchCtrl,
                  onChanged: searchContacts,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Rechercher un contact...",
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.indigo.shade700,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredContacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.contacts_outlined,
                              size: 80,
                              color: Colors.indigo.shade300,
                            ),
                            SizedBox(height: 16),
                            Text(
                              searchCtrl.text.isEmpty
                                  ? "Aucun contact"
                                  : "Aucun résultat",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.indigo.shade400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: filteredContacts.length,
                        itemBuilder: (ctx, i) {
                          final contact = filteredContacts[i];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo.shade600,
                                child: Text(
                                  contact.nom[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                "${contact.prenom} ${contact.nom}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                contact.numero,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ModifierContactPage(
                                            contact: contact,
                                          ),
                                        ),
                                      );
                                      loadContacts();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteContact(contact),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade600,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AjouterContactPage(userId: widget.user.id!),
            ),
          );
          loadContacts();
        },
      ),
    );
  }
}