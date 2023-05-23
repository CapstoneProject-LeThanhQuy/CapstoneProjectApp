import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';

abstract class VocabularyLocalRepo {
  Future<bool> addVocabularies(List<VocabularyLocal> vocabularies);
  // TODO get with query
  Future<List<VocabularyLocal>> getVocabulariesWithCourseId(int courseID);
    // TODO get with query
  Future<List<VocabularyLocal>> getVocabulariesWithLevelId(int levelId);
}
