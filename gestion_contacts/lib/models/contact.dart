import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact {
  @HiveField(0)
  String nom;

  @HiveField(1)
  String prenom;

  @HiveField(2)
  String numero;

  Contact({
    required this.nom,
    required this.prenom,
    required this.numero,
  });
}
