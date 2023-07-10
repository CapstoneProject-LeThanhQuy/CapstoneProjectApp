import 'package:easy_english/feature/course/data/providers/remote/request/learing_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class LearingCourseUsecase extends UseCaseIO<LearingCourseRequest, bool> {
  LearingCourseUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<bool> build(LearingCourseRequest input) {
    return _courseRepo.learingCourse(input);
  }
}
