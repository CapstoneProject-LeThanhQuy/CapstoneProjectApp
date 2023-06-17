import 'package:easy_english/feature/course/data/models/list_vocabulary_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_vocabulary_from_url_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class GetVocabulariesFromUrlUsecase
    extends UseCaseIO<GetVocabularyFromUrlRequest, ListVocabularyModel> {
  GetVocabulariesFromUrlUsecase(this._courseRepo);
  final CourseRepo _courseRepo;

  @override
  Future<ListVocabularyModel> build(GetVocabularyFromUrlRequest input) {
    return _courseRepo.getVocabulariesFromUrl(input);
  }
}
