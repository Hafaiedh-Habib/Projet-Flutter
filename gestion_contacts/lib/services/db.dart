import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DB {
  DB._private();
  static final DB instance = DB._private();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            numero TEXT NOT NULL,
            mot_de_passe TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> login(String nom, String prenom, String numero, String mdp) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'nom = ? AND prenom = ? AND numero = ? AND mot_de_passe = ?',
      whereArgs: [nom, prenom, numero, mdp],
    );
    if (result.isNotEmpty) return User.fromMap(result.first);
    return null;
  }

}
