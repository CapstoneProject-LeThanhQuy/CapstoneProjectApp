import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';

class GetAllVocabularyUsecase extends UseCase<List<VocabularyLocal>> {
  GetAllVocabularyUsecase(this.vocabularyLocalRepo);
  final VocabularyLocalRepo vocabularyLocalRepo;

  @override
  Future<List<VocabularyLocal>> build() {
    return vocabularyLocalRepo.getAllVocabulary();
  }
}
