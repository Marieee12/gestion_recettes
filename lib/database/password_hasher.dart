import 'dart:convert';
import 'package:crypto/crypto.dart';

// Classe pour gérer le hachage des mots de passe
// Cette classe utilise l'algorithme SHA-256 pour sécuriser les mots de passe
class PasswordHasher {
  
  // Méthode pour hasher un mot de passe
  // Cette méthode convertit le mot de passe en hash SHA-256
  static String hashPassword(String password) {
    // Conversion du mot de passe en bytes UTF-8
    var bytes = utf8.encode(password);
    
    // Création du hash SHA-256
    var digest = sha256.convert(bytes);
    
    // Retourne le hash sous forme de string hexadécimale
    return digest.toString();
  }
  
  // Méthode pour vérifier un mot de passe
  // Compare le mot de passe saisi avec le hash stocké
  static bool verifyPassword(String password, String hashedPassword) {
    // Hash le mot de passe saisi
    String hashedInput = hashPassword(password);
    
    // Compare avec le hash stocké
    return hashedInput == hashedPassword;
  }
  
  // Méthode pour générer un salt (optionnel, pour plus de sécurité)
  // Un salt ajoute une couche de sécurité supplémentaire
  static String generateSalt() {
    // Génération d'un salt aléatoire de 16 caractères
    var random = DateTime.now().millisecondsSinceEpoch.toString();
    var bytes = utf8.encode(random);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }
  
  // Méthode pour hasher avec salt
  static String hashPasswordWithSalt(String password, String salt) {
    // Combine le mot de passe avec le salt
    String saltedPassword = password + salt;
    
    // Hash le résultat
    return hashPassword(saltedPassword);
  }
} 