import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recette.dart';
import '../database/db_helpert.dart';
import 'detail_recette_ecrant.dart'; // Pour voir le détail d'une recette

class ListeRecettesEcrant extends StatefulWidget {
  const ListeRecettesEcrant({super.key});

  @override
  State<ListeRecettesEcrant> createState() => _ListeRecettesEcrantState();
}

class _ListeRecettesEcrantState extends State<ListeRecettesEcrant> {
  late Future<List<Recette>> _recettesFuture;

  @override
  void initState() {
    super.initState();
    // On récupère toutes les recettes depuis la base de données
    _recettesFuture = DatabaseHelper().getRecettes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Recettes"),
        backgroundColor: Color.fromARGB(255, 210, 26, 26),
      ),
      body: FutureBuilder<List<Recette>>(
        future: _recettesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune recette enregistrée"));
          }

          final recettes = snapshot.data!;

          return ListView.builder(
            itemCount: recettes.length,
            itemBuilder: (context, index) {
              final recette = recettes[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: recette.imagePath != null
                    ? Image.file(
                        File(recette.imagePath!),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.fastfood),
                title: Text(recette.titre),
                subtitle: Text(
                  recette.ingredients.length > 30
                      ? recette.ingredients.substring(0, 30) + '...'
                      : recette.ingredients,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Quand on clique sur une recette, on va à l'écran de détail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailRecetteEcrant(recette: recette),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
