import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'taskflow.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT NOT NULL,
            priority TEXT NOT NULL,
            isComplete INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;

    final maps = await db.query(
      'tasks',
      orderBy: 'dueDate ASC',
    );

    return maps.map(Task.fromMap).toList();
  }

  Future<void> insertTask(Task task) async {
    final db = await database;

    await db.insert(
      'tasks',
      task.toMap(),
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}