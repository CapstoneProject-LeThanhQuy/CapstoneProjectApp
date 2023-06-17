import 'package:easy_english/feature/course/data/models/course_download_model.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class DownloadCourseWithIdUsecase extends UseCaseIO<String, CourseDownloadModel> {
  DownloadCourseWithIdUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<CourseDownloadModel> build(String input) {
    return _courseRepo.getCourseWithId(input);
  }
}
