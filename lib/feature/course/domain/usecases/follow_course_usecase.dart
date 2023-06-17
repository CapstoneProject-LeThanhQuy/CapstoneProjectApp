import 'package:easy_english/feature/course/data/providers/remote/request/follow_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class FollowCourseUsecase extends UseCaseIO<FollowCourseRequest, bool> {
  FollowCourseUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<bool> build(FollowCourseRequest input) {
    return _courseRepo.followCourse(input);
  }
}
