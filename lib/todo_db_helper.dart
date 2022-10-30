import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/todo.dart';

class ToDoDBHelper{

  static const _dbName = 'todo.db';
  static const _dbVersion = 1;

  static const _todoTableName = 'todos';
  static String? path;

  ToDoDBHelper._privateConstructor();
  static final ToDoDBHelper instance = ToDoDBHelper._privateConstructor();

  static Database? _database;

  Future get database async{
    if(_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _dbName);
    return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
    );
  }


  Future _onCreate(Database db, int version) async{
    await db.execute('CREATE TABLE $_todoTableName(id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT, dateTime TEXT)');
  }

  static Future getFileData() async{
    return getDatabasesPath().then((value){
      return path = value;
    });
  }

  Future insertToDo(ToDo toDo) async{
    Database database = await instance.database;
    return await database.insert(_todoTableName, ToDo.toMap(toDo), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<ToDo>> getToDoSList() async{
    Database database = await instance.database;
    List<Map<String, dynamic>> maps = await database.query(_todoTableName);
    print(maps);
    return ToDo.fromMapList(maps);
  }
  
  Future<ToDo> updateToDo(ToDo toDo) async{
    Database database = await instance.database;
    await database.update(_todoTableName, ToDo.toMap(toDo), where: 'id = ?', whereArgs: [toDo.id]);

    return toDo;
  }

  Future deleteToDo(ToDo toDo) async{
    Database database = await instance.database;
    await database.delete(_todoTableName, where: 'id = ?', whereArgs: [toDo.id]);

    return toDo;
  }
}