class Contact {
  final int? id;
  final String nom;
  final String prenom;
  final String numero;
  final int userId;

  Contact({
    this.id,
    required this.nom,
    required this.prenom,
    required this.numero,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'numero': numero,
      'user_id': userId,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      numero: map['numero'],
      userId: map['user_id'],
    );
  }
}