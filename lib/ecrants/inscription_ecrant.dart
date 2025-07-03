import 'package:flutter/material.dart';
import '../database/db_helpert.dart';
import '../models/user.dart';

class InscriptionEcrant extends StatefulWidget {
  const InscriptionEcrant({super.key});

  @override
  State<InscriptionEcrant> createState() => _InscriptionEcrantState();
}

class _InscriptionEcrantState extends State<InscriptionEcrant> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmController.text) {
      setState(() {
        _errorMessage = "Les mots de passe ne correspondent pas";
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final dbHelper = DatabaseHelper();

      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final result = await dbHelper.insertUser(user);

      if (result == -1) {
        setState(() {
          _errorMessage = "Cet email est déjà utilisé";
        });
      } else {
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie, connecte-toi !')),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur inconnue : $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 26, 26),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.person_add_alt_1, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  validator: (value) =>
                      value != null && value.length >= 2 ? null : 'Nom requis',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  validator: (value) =>
                      value != null && value.contains('@') ? null : 'Email invalide',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value != null && value.length >= 6 ? null : 'Minimum 6 caractères',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value != null && value.length >= 6 ? null : 'Minimum 6 caractères',
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 12),
                _loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'S’inscrire',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 210, 26, 26),
                            ),
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Déjà inscrit ? Se connecter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

