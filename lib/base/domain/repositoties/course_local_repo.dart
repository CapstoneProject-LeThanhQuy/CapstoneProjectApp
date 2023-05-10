import 'package:easy_english/base/data/local/model/course_local_model.dart';

abstract class CourseLocalRepo {
  Future<bool> createCourse(CourseLocal courseLocalModel);
  // TODO get with query
  Future<List<CourseLocal>> getCourses();
}
