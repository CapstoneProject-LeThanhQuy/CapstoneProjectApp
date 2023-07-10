import 'package:easy_english/feature/course/data/providers/remote/request/rate_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class RateCourseUsecase extends UseCaseIO<RateCourseRequest, bool> {
  RateCourseUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<bool> build(RateCourseRequest input) {
    return _courseRepo.rateCourse(input);
  }
}
