import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:easy_english/base/data/local/model/course_level_local_model.dart';
import 'package:easy_english/base/domain/repositoties/course_level_local_repo.dart';
import 'package:flutter/foundation.dart';

class CourseLevelLocalRepoImp implements CourseLevelLocalRepo {
  final dbProvider = LocalStorage();

  @override
  Future<bool> createCourseLevel(CourseLevelLocal courseLevelLocalModel) async {
    try {
      final database = await dbProvider.database;
      database.insert('course_level', courseLevelLocalModel.toMap());
      return true;
    } catch (error) {
      if (kDebugMode) print(error);
      return false;
    }
  }

  @override
  Future<List<CourseLevelLocal>> getCourseLevels(int courseId) async {
    final database = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await database.query('course_level', where: 'course_id = $courseId');
    List<CourseLevelLocal> courseLevels = allRows.map((course) => CourseLevelLocal.fromMap(course)).toList();

    return courseLevels;
  }
}
