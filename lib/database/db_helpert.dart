import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recette.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'app.db'); // Renommé pour généraliser
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Création de la table recettes
        await db.execute('''
          CREATE TABLE recettes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT,
            ingredients TEXT,
            etapes TEXT,
            imagePath TEXT
          )
        ''');

        // Création de la table users pour l'authentification
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ----- Recettes -----
  Future<int> insertRecette(Recette recette) async {
    final dbClient = await db;
    return await dbClient.insert('recettes', recette.toMap());
  }

  Future<List<Recette>> getRecettes() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('recettes');
    return maps.map((map) => Recette.fromMap(map)).toList();
  }

  Future<void> deleteRecette(int id) async {
    final dbClient = await db;
    await dbClient.delete('recettes', where: 'id = ?', whereArgs: [id]);
  }

  // ----- Users -----
  Future<int> insertUser(String email, String password) async {
    final dbClient = await db;
    return await dbClient.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.abort, // pour éviter les doublons email
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }
}
