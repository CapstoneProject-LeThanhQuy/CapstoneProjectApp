import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class GetCourseWithPublicIdUsecase extends UseCaseIO<String, List<CourseModel>> {
  GetCourseWithPublicIdUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<List<CourseModel>> build(String input) {
    return _courseRepo.getCourseWithPublicId(input);
  }
}
