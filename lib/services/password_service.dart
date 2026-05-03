// lib/services/password_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/password_item.dart';
import 'encryption_service.dart';

class PasswordService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'passwords_secure.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        accountName TEXT NOT NULL,
        password TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        category INTEGER NOT NULL DEFAULT 5,
        notes TEXT,
        website TEXT
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE passwords ADD COLUMN category INTEGER NOT NULL DEFAULT 5');
      await db.execute('ALTER TABLE passwords ADD COLUMN notes TEXT');
      await db.execute('ALTER TABLE passwords ADD COLUMN website TEXT');
    }
  }

  // Create with encryption
  Future<int> insertPassword(PasswordItem password) async {
    final db = await database;
    final encryptedPassword = EncryptionService.encrypt(password.password);
    final encryptedItem = password.copyWith(password: encryptedPassword);
    return await db.insert('passwords', encryptedItem.toMap());
  }

  // Read All with decryption
  Future<List<PasswordItem>> getAllPasswords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('passwords', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      final item = PasswordItem.fromMap(maps[i]);
      return item.copyWith(password: EncryptionService.decrypt(item.password));
    });
  }

  // Get by category
  Future<List<PasswordItem>> getPasswordsByCategory(PasswordCategory category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      where: 'category = ?',
      whereArgs: [category.index],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) {
      final item = PasswordItem.fromMap(maps[i]);
      return item.copyWith(password: EncryptionService.decrypt(item.password));
    });
  }

  // Search
  Future<List<PasswordItem>> searchPasswords(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      where: 'accountName LIKE ? OR notes LIKE ? OR website LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) {
      final item = PasswordItem.fromMap(maps[i]);
      return item.copyWith(password: EncryptionService.decrypt(item.password));
    });
  }

  // Update
  Future<int> updatePassword(PasswordItem password) async {
    final db = await database;
    final encryptedPassword = EncryptionService.encrypt(password.password);
    final encryptedItem = password.copyWith(password: encryptedPassword);
    return await db.update(
      'passwords',
      encryptedItem.toMap(),
      where: 'id = ?',
      whereArgs: [password.id],
    );
  }

  // Delete
  Future<int> deletePassword(int id) async {
    final db = await database;
    return await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}