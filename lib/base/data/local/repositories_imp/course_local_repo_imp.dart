import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:easy_english/base/data/local/model/course_update_local.dart';
import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

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

  @override
  Future<bool> updateCourse(CourseUpdateLocal courseUpdateLocal) async {
    try {
      final database = await dbProvider.database;
      Batch batch = database.batch();

      if (AppConfig.isReview) {
        batch.rawUpdate(
          'UPDATE course SET point = ? WHERE id = ?',
          [
            courseUpdateLocal.point,
            courseUpdateLocal.vocabularyList.first.courseId,
          ],
        );
      } else {
        batch.rawUpdate(
          'UPDATE course SET learned_words = ? , point = ? WHERE id = ?',
          [
            courseUpdateLocal.courseLearnedWord,
            courseUpdateLocal.point,
            courseUpdateLocal.vocabularyList.first.courseId,
          ],
        );

        batch.rawUpdate(
          'UPDATE course_level SET learned_words = ? WHERE id = ?',
          [
            courseUpdateLocal.levelLearnedWord,
            courseUpdateLocal.vocabularyList.first.levelId,
          ],
        );
      }

      for (var vocabulary in courseUpdateLocal.vocabularyList) {
        batch.rawUpdate(
          'UPDATE vocabulary SET progress = ? , difficult = ?, last_time_learning = ? WHERE id = ?',
          [
            vocabulary.progress,
            vocabulary.difficult,
            vocabulary.lastTimeLearning,
            vocabulary.id,
          ],
        );
      }

      await batch.commit();
      return true;
    } catch (error) {
      if (kDebugMode) print(error);
      return false;
    }
  }
}
