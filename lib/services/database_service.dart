import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/contact_model.dart';
import '../models/safe_location_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fpt_guard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        student_id TEXT UNIQUE,
        phone TEXT NOT NULL,
        email TEXT,
        created_at TEXT
      )
    ''');

    // Emergency contacts table
    await db.execute('''
      CREATE TABLE emergency_contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        contact_name TEXT NOT NULL,
        contact_phone TEXT NOT NULL,
        contact_email TEXT,
        contact_type TEXT DEFAULT 'personal',
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Safe locations table
    await db.execute('''
      CREATE TABLE safe_locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT,
        latitude REAL,
        longitude REAL,
        distance INTEGER,
        location_type TEXT,
        created_at TEXT
      )
    ''');

    // SOS alerts table
    await db.execute('''
      CREATE TABLE sos_alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        latitude REAL,
        longitude REAL,
        address TEXT,
        status TEXT DEFAULT 'active',
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Insert sample safe locations
    await db.insert('safe_locations', {
      'name': 'Cổng FPT Cần Thơ',
      'address': 'Đường 3/2, Xuân Khánh, Ninh Kiều, Cần Thơ',
      'latitude': 10.012404,
      'longitude': 105.731777,
      'distance': 200,
      'location_type': 'fpt',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('safe_locations', {
      'name': 'Bảo vệ Khu A',
      'address': 'Khu A, FPT Cần Thơ',
      'latitude': 10.012800,
      'longitude': 105.732100,
      'distance': 350,
      'location_type': 'security',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('safe_locations', {
      'name': 'Công an Phường Xuân Khánh',
      'address': 'Xuân Khánh, Ninh Kiều, Cần Thơ',
      'latitude': 10.013500,
      'longitude': 105.733000,
      'distance': 500,
      'location_type': 'police',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // User CRUD operations
  Future<UserModel?> getUser() async {
    final db = await database;
    final maps = await db.query('users', orderBy: 'id DESC', limit: 1);
    
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toDbMap());
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toDbMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Contact CRUD operations
  Future<List<ContactModel>> getContacts() async {
    final db = await database;
    final maps = await db.query(
      'emergency_contacts',
      where: 'contact_type = ?',
      whereArgs: ['personal'],
      orderBy: 'created_at DESC',
    );
    
    return List.generate(maps.length, (i) {
      return ContactModel.fromMap(maps[i]);
    });
  }

  Future<int> insertContact(ContactModel contact) async {
    final db = await database;
    return await db.insert('emergency_contacts', contact.toMap());
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'emergency_contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Safe locations
  Future<List<SafeLocationModel>> getSafeLocations() async {
    final db = await database;
    final maps = await db.query('safe_locations', orderBy: 'distance ASC');
    
    return List.generate(maps.length, (i) {
      return SafeLocationModel.fromMap(maps[i]);
    });
  }

  // SOS Alert
  Future<int> insertSOSAlert({
    required int userId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final db = await database;
    return await db.insert('sos_alerts', {
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': 'active',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

