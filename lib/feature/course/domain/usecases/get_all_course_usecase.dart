import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_all_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class GetAllCourseUsecase extends UseCaseIO<GetAllCourseRequest, List<CourseModel>> {
  GetAllCourseUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<List<CourseModel>> build(GetAllCourseRequest input) {
    return _courseRepo.getAllCourse(input);
  }
}
