import 'dart:async';
import 'dart:io' as io;

import 'package:three_thousand/database/model/time_recording.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "activity.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Activity(id INTEGER PRIMARY KEY, counter INTEGER, activity TEXT, recording TEXT)");
  }

  Future<int> saveRecording(Time record) async {
    var dbClient = await db;
    int res = await dbClient.insert("Activity", record.toMap());
    return res;
  }

  Future<List<Time>> getRecording() async {
    var dbClient = await db;
    List<Map> idMapTimelist = await dbClient.rawQuery('SELECT * FROM Activity');
    List<Time> employees = new List();
    for (int i = 0; i < idMapTimelist.length; i++) {
      var times = new Time(idMapTimelist[i]["counter"], idMapTimelist[i]["recording"], idMapTimelist[i]["activity"]);
      times.setTimeId(idMapTimelist[i]["id"]);
      employees.add(times); 
      // print(idMapTimelist);
    } 
    return employees;
  }

  Future deleteAll() async {
    var dbClient = await db;
    dbClient.rawDelete('DELETE FROM Activity');
  }

  Future<int> deleteTimes(Time record) async {
    var dbClient = await db;
    int res =
      await dbClient.rawDelete('DELETE FROM Activity WHERE id = ?', [record.id]);
      print(res);
    return res;
  }

  Future<bool> update(Time record) async {
    var dbClient = await db;
    int res = await dbClient.update("Activity", record.toMap(),
      where: "id = ?", whereArgs: <int>[record.id]);
    return res > 0 ? true : false;
  }
}