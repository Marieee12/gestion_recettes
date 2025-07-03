import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/recette.dart';
import 'password_hasher.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recettes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recettes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        etapes TEXT NOT NULL,
        imagePath TEXT
      )
    ''');

    print('Tables users et recettes créées avec succès!');
  }


  Future<int> insertUser(User user) async {
    final db = await database;
    try {
      final hashedPassword = PasswordHasher.hashPassword(user.password);
      final newUser = User(
        id: user.id, // id is auto-incremented, so it can be null
        name: user.name,
        email: user.email,
        password: hashedPassword,
      );
      return await db.insert('users', newUser.toMap());
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        print('Email déjà utilisé');
        return -1;
      }
      print('Erreur lors de l\'insertion: $e');
      return -1;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      final user = User.fromMap(maps.first);
      final isValid = PasswordHasher.verifyPassword(password, user.password);
      return isValid ? user : null;
    }
    return null;
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return maps.isNotEmpty;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> insertRecette(Recette recette) async {
    final db = await database;
    return await db.insert('recettes', recette.toMap());
  }

  Future<List<Recette>> getAllRecettes() async {
    final db = await database;
    final maps = await db.query('recettes');
    return List.generate(maps.length, (i) => Recette.fromMap(maps[i]));
  }

  Future<int> deleteRecette(int id) async {
    final db = await database;
    return await db.delete('recettes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateRecette(Recette recette) async {
    final db = await database;
    return await db.update(
      'recettes',
      recette.toMap(),
      where: 'id = ?',
      whereArgs: [recette.id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}

