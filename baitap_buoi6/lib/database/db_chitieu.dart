import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/chitieu.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_chitieu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chitieus (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noidung TEXT NOT NULL,
            sotien REAL NOT NULL,
            ghichu TEXT
          )
        ''');
      },
    );
  }

  // Thêm chi tiêu mới
  Future<int> insertChiTieu(ChiTieu ct) async {
    final db = await database;
    return await db.insert(
      'chitieus',
      ct.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lấy danh sách chi tiêu
  Future<List<ChiTieu>> getChiTieus() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chitieus');
    return List.generate(maps.length, (i) => ChiTieu.fromMap(maps[i]));
  }

  // Xóa chi tiêu (bổ sung thêm để quản lý tốt hơn)
  Future<int> deleteChiTieu(int id) async {
    final db = await database;
    return await db.delete('chitieus', where: "id = ?", whereArgs: [id]);
  }
}
