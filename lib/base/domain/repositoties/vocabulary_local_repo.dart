import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';

abstract class VocabularyLocalRepo {
  Future<bool> addVocabularies(List<VocabularyLocal> vocabularies);

  Future<List<VocabularyLocal>> getVocabulariesWithCourseId(int courseID);

  Future<List<VocabularyLocal>> getVocabulariesWithLevelId(int levelId);

  Future<bool> updateVocabularyDifficult(Vocabulary vocabulary);
}
