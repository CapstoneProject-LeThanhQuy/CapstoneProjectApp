import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';
import 'package:flutter/foundation.dart';

class VocabularyLocalRepoImp implements VocabularyLocalRepo {
  final dbProvider = LocalStorage();

  @override
  Future<bool> addVocabularies(List<VocabularyLocal> vocabularies) async {
    try {
      final database = await dbProvider.database;
      database.insert('vocabulary', vocabularies[0].toMap());
      return true;
    } catch (error) {
      if (kDebugMode) print(error);
      return false;
    }
  }

  @override
  Future<List<VocabularyLocal>> getVocabularies(int courseID) async {
    final database = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await database.query('vocabulary', where: 'course_id = $courseID');
    List<VocabularyLocal> vocabularies = allRows.map((course) => VocabularyLocal.fromMap(course)).toList();

    return vocabularies;
  }
}
