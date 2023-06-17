import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class GetImageWithKeyUsecase extends UseCaseIO<String, List<String>> {
  GetImageWithKeyUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<List<String>> build(String input) {
    return _courseRepo.getImageWithKeyWord(input);
  }
}
