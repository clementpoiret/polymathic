import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "Tasks.db";
  static final _databaseVersion = 1;

  static final tasksTable = 'tasks';
  static final statsTable = 'statistics';

  static final taskId = '_id';
  static final taskContent = 'content';
  static final taskIsImportant = 'important';
  static final taskIsUrgent = 'urgent';
  static final taskDuration = 'duration';

  static final statId = '_id';
  static final statDate = 'date';
  static final statImportant = 'important';
  static final statUrgent = 'urgent';
  static final statDuration = 'duration';
  static final statAdded = 'added';
  static final statRemoved = 'removed';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  DatabaseHelper._privateConstructor();
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$taskId = ?', whereArgs: [id]);
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map>> query(String sql) async {
    Database db = await instance.database;

    return await db.rawQuery(sql);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[taskId];
    return await db.update(table, row, where: '$taskId = ?', whereArgs: [id]);
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tasksTable (
      $taskId INTEGER PRIMARY KEY,
      $taskContent TEXT NOT NULL,
      $taskIsImportant INTEGER NOT NULL,
      $taskIsUrgent INTEGER NOT NULL,
      $taskDuration REAL NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $statsTable (
      $statId INTEGER PRIMARY KEY,
      $statDate TEXT NOT NULL,
      $statImportant INTEGER NOT NULL,
      $statUrgent INTEGER NOT NULL,
      $statDuration REAL NOT NULL,
      $statAdded INTEGER NOT NULL,
      $statRemoved INTEGER NOT NULL
    )
    ''');
  }

  Future<int> getAddedTasks({int isImportant, int isUrgent}) async {
    Database db = await instance.database;

    String sql = '''
        SELECT SUM($statAdded) 
        FROM $statsTable
        WHERE $statUrgent = $isUrgent
        AND $statImportant = $isImportant;
        ''';

    List<Map> output = await db.rawQuery(sql);
    var value = output.first.values?.first;

    if (value == null) {
      return 0;
    } else {
      return value;
    }
  }

  Future<int> getRemovedTasks({int isImportant, int isUrgent}) async {
    Database db = await instance.database;

    String sql = '''
        SELECT SUM($statRemoved) 
        FROM $statsTable
        WHERE $statUrgent = $isUrgent
        AND $statImportant = $isImportant;
        ''';

    List<Map> output = await db.rawQuery(sql);
    var value = output.first.values?.first;

    if (value == null) {
      return 0;
    } else {
      return value;
    }
  }
}
