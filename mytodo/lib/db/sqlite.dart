// import 'dart:html';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databasename = 'mytodo.db';
  static final _databaseversion = 1;
  static final table1name = 'tasks';
  static final table1id = 'id';
  static final table1title = 'title';
  static final table1description = 'description';
  static final table1tasktime = 'tasktime';
  static final table1taskdate = 'taskdate';
  static final table1taskpriority = 'taskpriority';
  static final table2name = 'notifications';
  static final table2id = 'id';
  // static final _table2

  DatabaseHelper._constructor();
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializedatabase();
    return _database!;
  }

  _initializedatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databasename);
    return await openDatabase(path,
        version: _databaseversion, onCreate: createtable);
  }

  Future createtable(Database db, int version) {
    return db.execute('''
      CREATE TABLE $table1name(
      $table1id INTEGER PRIMARY KEY,
      $table1title VARCHAR(50) NOT NULL,
      $table1description VARCHAR(50) NOT NULL,
      $table1taskdate DATE NOT NULL,
      $table1tasktime TEXT NOT NULL,
      $table1taskpriority INTEGER NOT NULL)
    ''');
  }

  Future<int> insertdata(Map<String, dynamic> data) async {
    Database db = await instance.database;
    return await db.insert(table1name, data);
  }

  Future<List<Map<String, dynamic>>> getdata() async {
    Database db = await instance.database;
    return await db.query(table1name);
  }
}
