import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/base_usecase.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';

class CreateVocabulariesLocalUsecase extends UseCaseIO<List<VocabularyLocal>, bool> {
  CreateVocabulariesLocalUsecase(this.vocabularyLocalRepo);
  final VocabularyLocalRepo vocabularyLocalRepo;

  @override
  Future<bool> build(List<VocabularyLocal> input) {
    return vocabularyLocalRepo.addVocabularies(input);
  }
}
