import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static final LocalStorage _localStorage = LocalStorage._internal();

  factory LocalStorage() {
    return _localStorage;
  }

  LocalStorage._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    return await initDB();
  }

  static const String DB_NAME = 'easy_english.db';

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  List<String> course = [
    'title TEXT NOT NULL',
    'image TEXT NOT NULL',
    'learned_words INTEGER NOT NULL',
    'total_words INTEGER NOT NULL',
    'point INTEGER DEFAULT 0',
    'progress INTEGER NOT NULL',
    'member INTEGER NOT NULL',
  ];

  List<String> courseLevel = [
    'level INTEGER NOT NULL',
    'title TEXT NOT NULL',
    'learned_words INTEGER NOT NULL',
    'total_words INTEGER NOT NULL',
    'course_id INTEGER NOT NULL',
  ];

  List<String> vocabulary = [
    'english_text TEXT NOT NULL',
    'vietnamese_text TEXT NOT NULL',
    'image TEXT NOT NULL',
    'progress INTEGER DEFAULT 0',
    'difficult INTEGER DEFAULT 0',
    'course_id INTEGER NOT NULL',
    'level_id INTEGER NOT NULL',
  ];
  _onCreate(Database database, int version) async {
    //tạo database

    var courseQuery = "CREATE TABLE course (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL";
    for (var element in course) {
      courseQuery += ", $element";
    }
    courseQuery += ");";
    await database.execute(courseQuery);

    var courseLevelQuery = "CREATE TABLE course_level (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL";
    for (var element in courseLevel) {
      courseLevelQuery += ", $element";
    }
    courseLevelQuery += ");";
    await database.execute(courseLevelQuery);

    var vocabularyQuery = "CREATE TABLE vocabulary (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL";
    for (var element in vocabulary) {
      vocabularyQuery += ", $element";
    }
    vocabularyQuery += ");";
    await database.execute(vocabularyQuery);
  }

  // Future<Employee> save(Employee employee) async {
  //   // insert employee vào bảng đơn giản
  //   var dbClient = await db;
  //   employee.id = await dbClient.insert(TABLE, employee.toMap());
  //   return employee;
  //   /*
  //   await dbClient.transaction((txn) async {
  //     var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
  //     return await txn.rawInsert(query); //các bạn có thể sử dụng rawQuery nếu truy vẫn phức tạp để thay thế cho các phước thức có sẵn của lớp Database.
  //   });
  //   */
  // }

  // Future<List<Employee>> getEmployees() async {
  //   //get list employees đơn giản
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
  //   //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
  //   List<Employee> employees = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       employees.add(Employee.fromMap(maps[i]));
  //     }
  //   }
  //   return employees;
  // }

  // Future<int> delete(int id) async {
  //   // xóa employee
  //   var dbClient = await db;
  //   return await dbClient
  //       .delete(TABLE, where: '$ID = ?', whereArgs: [id]); //where - xóa tại ID nào, whereArgs - argument là gì?
  // }

  // Future<int> update(Employee employee) async {
  //   var dbClient = await db;
  //   return await dbClient.update(TABLE, employee.toMap(), where: '$ID = ?', whereArgs: [employee.id]);
  // }

  Future close() async {
    //close khi không sử dụng
    var dbClient = await database;
    dbClient.close();
  }
}
