class User {
  final int? id;
  final String nom;
  final String prenom;
  final String numero;
  final String motDePasse;

  User({
    this.id,
    required this.nom,
    required this.prenom,
    required this.numero,
    required this.motDePasse,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      numero: map['numero'],
      motDePasse: map['mot_de_passe'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'numero': numero,
      'mot_de_passe': motDePasse,
    };
  }
}
