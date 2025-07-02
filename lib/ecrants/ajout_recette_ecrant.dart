import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/recette.dart';
import '../database/db_helpert.dart';

class AjoutRecetteEcrant extends StatefulWidget {
  const AjoutRecetteEcrant({super.key});

  @override
  State<AjoutRecetteEcrant> createState() => _AjoutRecetteEcrantState();
}

class _AjoutRecetteEcrantState extends State<AjoutRecetteEcrant> {
  final _formKey = GlobalKey<FormState>();

  // Champs de saisie
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  File? _image; // Pour l'image choisie

  // Fonction pour choisir une image depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fonction pour enregistrer la recette dans la base SQLite
  Future<void> _enregistrerRecette() async {
    if (_formKey.currentState!.validate()) {
      final recette = Recette(
        titre: _titleController.text,
        ingredients: _ingredientsController.text,
        etapes: _stepsController.text,
        imagePath: _image?.path,
      );

      await DatabaseHelper().insertRecette(recette);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recette enregistrée !")),
      );

      Navigator.pop(context); // On retourne à l'écran précédent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nouvelle Recette",
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Color.fromARGB(255, 210, 26, 26),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ titre
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Titre",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 12),

              // Champ ingrédients
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: "Ingrédients",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Champ étapes
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: "Étapes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Bouton image
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text(
                  "Choisir une image",
                  style: TextStyle(color: Color.fromARGB(255, 210, 26, 26),
                  ),
                  ),
              ),
              const SizedBox(height: 12),

              // Aperçu image
              if (_image != null)
                Image.file(_image!, height: 180, fit: BoxFit.cover),

              const SizedBox(height: 20),

              // Bouton enregistrer
              ElevatedButton(
                onPressed: _enregistrerRecette,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 210, 26, 26),
                ),
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(color: Colors.white),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
