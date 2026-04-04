import 'package:baitap_buoi6/model/sinhvien.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_qlsv.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE sinhviens(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL
        )
        ''');
      },
    );
  }

  Future<int> insertSinhVien(SinhVien stu) async {
    final db = await database;
    return await db.insert(
      'sinhviens',
      stu.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SinhVien>> getSinhViens() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sinhviens');
    return List.generate(maps.length, (i) {
      return SinhVien(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
      );
    });
  }

  Future<int> updateSinhVien(SinhVien stu) async {
    final db = await database;
    return await db.update(
      'sinhviens',
      stu.toMap(),
      where: "id = ?",
      whereArgs: [stu.id],
    );
  }

  Future<int> deleteSinhVien(int id) async {
    final db = await database;
    return await db.delete('sinhviens', where: "id = ?", whereArgs: [id]);
  }
}
