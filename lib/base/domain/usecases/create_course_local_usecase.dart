import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';

class CreateCourseLocalUsecase extends UseCaseIO<CourseLocal, bool> {
  CreateCourseLocalUsecase(this.courseLocalRepo);
  final CourseLocalRepo courseLocalRepo;

  @override
  Future<bool> build(CourseLocal input) {
    return courseLocalRepo.createCourse(input);
  }
}
