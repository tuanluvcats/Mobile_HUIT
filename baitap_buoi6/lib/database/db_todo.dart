import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'todo_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT,
            isDone INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertTodo(Todo todo) async =>
      (await database).insert('todos', todo.toMap());

  Future<List<Todo>> getTodos() async {
    final List<Map<String, dynamic>> maps = await (await database).query(
      'todos',
    );
    return maps.map((e) => Todo.fromMap(e)).toList();
  }

  Future<int> updateTodo(Todo todo) async => (await database).update(
    'todos',
    todo.toMap(),
    where: "id = ?",
    whereArgs: [todo.id],
  );

  Future<int> deleteTodo(int id) async =>
      (await database).delete('todos', where: "id = ?", whereArgs: [id]);
}
