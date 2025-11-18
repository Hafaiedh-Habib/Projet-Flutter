import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/contact.dart';

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
      version: 2,
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
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            numero TEXT NOT NULL,
            user_id INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE contacts (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nom TEXT NOT NULL,
              prenom TEXT NOT NULL,
              numero TEXT NOT NULL,
              user_id INTEGER NOT NULL,
              FOREIGN KEY (user_id) REFERENCES users (id)
            )
          ''');
        }
      },
    );
  }

  // ===== USERS =====
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

  // ===== CONTACTS =====
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContactsByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'nom ASC',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contact>> searchContacts(int userId, String query) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'user_id = ? AND (nom LIKE ? OR prenom LIKE ? OR numero LIKE ?)',
      whereArgs: [userId, '%$query%', '%$query%', '%$query%'],
      orderBy: 'nom ASC',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }
}