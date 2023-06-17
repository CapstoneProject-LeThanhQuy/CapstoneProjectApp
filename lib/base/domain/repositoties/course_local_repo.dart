import 'package:easy_english/base/data/local/model/course_update_local.dart';
import 'package:easy_english/base/data/local/model/course_local_model.dart';

abstract class CourseLocalRepo {
  Future<bool> createCourse(CourseLocal courseLocalModel);
  Future<List<CourseLocal>> getCourses();
  Future<bool> updateCourse(CourseUpdateLocal courseLocalModel);
}
