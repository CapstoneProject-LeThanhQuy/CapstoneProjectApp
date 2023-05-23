import 'package:easy_english/base/data/local/model/course_level_local_model.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/course_level_local_repo.dart';

class GetCourseLevelLocalUsecase extends UseCaseIO<int, List<CourseLevelLocal>> {
  GetCourseLevelLocalUsecase(this.courseLevelLocalRepo);
  final CourseLevelLocalRepo courseLevelLocalRepo;

  @override
  Future<List<CourseLevelLocal>> build(int input) {
    return courseLevelLocalRepo.getCourseLevels(input);
  }
}
