import 'package:easy_english/base/data/local/model/course_level_local_model.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/course_level_local_repo.dart';

class CreateCourseLevelLocalUsecase extends UseCaseIO<CourseLevelLocal, bool> {
  CreateCourseLevelLocalUsecase(this.courseLevelLocalRepo);
  final CourseLevelLocalRepo courseLevelLocalRepo;

  @override
  Future<bool> build(CourseLevelLocal input) {
    return courseLevelLocalRepo.createCourseLevel(input);
  }
}
