import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';

class GetCourseLocalUsecase extends UseCase<List<CourseLocal>> {
  GetCourseLocalUsecase(this.courseLocalRepo);
  final CourseLocalRepo courseLocalRepo;

  @override
  Future<List<CourseLocal>> build() {
    return courseLocalRepo.getCourses();
  }
}
