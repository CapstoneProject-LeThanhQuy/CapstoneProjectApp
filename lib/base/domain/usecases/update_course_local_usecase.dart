import 'package:easy_english/base/data/local/model/course_update_local.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';

class UpdateCourseLocalUsecase extends UseCaseIO<CourseUpdateLocal, bool> {
  UpdateCourseLocalUsecase(this.courseLocalRepo);
  final CourseLocalRepo courseLocalRepo;

  @override
  Future<bool> build(CourseUpdateLocal input) {
    return courseLocalRepo.updateCourse(input);
  }
}