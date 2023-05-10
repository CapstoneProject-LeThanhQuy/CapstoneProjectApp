import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';
import 'package:flutter/foundation.dart';

class CourseLocalRepoImp implements CourseLocalRepo {
  final dbProvider = LocalStorage();

  @override
  Future<bool> createCourse(CourseLocal courseLocalModel) async {
    try {
      final database = await dbProvider.database;
      database.insert('course', courseLocalModel.toMap());
      return true;
    } catch (error) {
      if (kDebugMode) print(error);
      return false;
    }
  }

  @override
  Future<List<CourseLocal>> getCourses() async {
    final database = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await database.query('course');
    List<CourseLocal> courses = allRows.map((course) => CourseLocal.fromMap(course)).toList();

    return courses;
  }
}
