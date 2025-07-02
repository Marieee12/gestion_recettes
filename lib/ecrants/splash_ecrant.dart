import 'dart:async';
import 'package:flutter/material.dart';

class SplashEcrant extends StatefulWidget {
  const SplashEcrant({super.key});

  @override
  State<SplashEcrant> createState() => _SplashEcrantState();
}

class _SplashEcrantState extends State<SplashEcrant> {
  @override
  void initState() {
    super.initState();

    // On attend 3 secondes, puis on va vers la page de connexion
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 26, 26), // Fond rouge
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.food_bank, size: 100, color: Colors.white), // Icône
            SizedBox(height: 24),
            Text(
              'Chargement...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

