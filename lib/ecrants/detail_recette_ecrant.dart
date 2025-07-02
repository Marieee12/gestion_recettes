import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recette.dart';

class DetailRecetteEcrant extends StatelessWidget {
  final Recette recette;

  const DetailRecetteEcrant({super.key, required this.recette});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recette.titre,
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Color.fromARGB(255, 210, 26, 26),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image 
            if (recette.imagePath != null)
              Center(
                child: Image.file(
                  File(recette.imagePath!),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Titre "Ingrédients"
            Text(
              "Ingrédients",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(recette.ingredients),

            const SizedBox(height: 20),

            // Titre "Étapes"
            Text(
              "Étapes de préparation",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(recette.etapes),
          ],
        ),
      ),
    );
  }
}
