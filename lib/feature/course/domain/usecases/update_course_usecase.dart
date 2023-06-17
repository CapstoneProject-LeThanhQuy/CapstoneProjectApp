import 'package:easy_english/feature/course/data/providers/remote/request/update_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class UpdateCourseUsecase extends UseCaseIO<UpdateCourseRequest, bool> {
  UpdateCourseUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<bool> build(UpdateCourseRequest input) {
    return _courseRepo.updateCourse(input);
  }
}
