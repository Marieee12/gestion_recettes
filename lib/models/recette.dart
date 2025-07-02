class Recette {
  final int? id;
  final String titre;
  final String ingredients;
  final String etapes;
  final String? imagePath; 

  Recette({
    this.id,
    required this.titre,
    required this.ingredients,
    required this.etapes,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'ingredients': ingredients,
      'etapes': etapes,
      'imagePath': imagePath,
    };
  }

  factory Recette.fromMap(Map<String, dynamic> map) {
    return Recette(
      id: map['id'],
      titre: map['titre'],
      ingredients: map['ingredients'],
      etapes: map['etapes'],
      imagePath: map['imagePath'],
    );
  }
}
