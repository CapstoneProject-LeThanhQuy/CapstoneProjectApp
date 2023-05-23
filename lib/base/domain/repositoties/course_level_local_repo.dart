import 'package:easy_english/base/data/local/model/course_level_local_model.dart';

abstract class CourseLevelLocalRepo {
  Future<bool> createCourseLevel(CourseLevelLocal courseLevelLocalModel);
  // TODO get with query
  Future<List<CourseLevelLocal>> getCourseLevels(int courseId);
}
