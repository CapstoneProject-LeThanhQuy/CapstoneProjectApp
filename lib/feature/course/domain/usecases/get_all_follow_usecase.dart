import 'package:easy_english/feature/course/data/models/follow_model.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class GetAllFollowUsecase extends UseCaseIO<String, List<Follow>> {
  GetAllFollowUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<List<Follow>> build(String input) {
    return _courseRepo.getAllFollow(input);
  }
}
