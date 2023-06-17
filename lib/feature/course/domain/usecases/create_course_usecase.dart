import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/create_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class CreateCourseUsecase extends UseCaseIO<CreateCourseRequest, CourseModel> {
  CreateCourseUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<CourseModel> build(CreateCourseRequest input) {
    return _courseRepo.createCourse(input);
  }
}
