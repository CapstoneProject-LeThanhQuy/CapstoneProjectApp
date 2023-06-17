import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';

class UpdateVocabularyDifficultLocalUsecase extends UseCaseIO<Vocabulary, bool> {
  UpdateVocabularyDifficultLocalUsecase(this.vocabularyLocalRepo);
  final VocabularyLocalRepo vocabularyLocalRepo;

  @override
  Future<bool> build(Vocabulary input) {
    return vocabularyLocalRepo.updateVocabularyDifficult(input);
  }
}
