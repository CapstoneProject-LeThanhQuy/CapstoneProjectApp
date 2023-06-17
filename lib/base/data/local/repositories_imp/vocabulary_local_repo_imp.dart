import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

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
  Future<List<VocabularyLocal>> getVocabulariesWithCourseId(int courseID) async {
    final database = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await database.query('vocabulary', where: 'course_id = $courseID');
    List<VocabularyLocal> vocabularies = allRows.map((course) => VocabularyLocal.fromMap(course)).toList();

    return vocabularies;
  }

  @override
  Future<List<VocabularyLocal>> getVocabulariesWithLevelId(int levelId) async {
    final database = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await database.query('vocabulary', where: 'level_id = $levelId');
    List<VocabularyLocal> vocabularies = allRows.map((course) => VocabularyLocal.fromMap(course)).toList();

    return vocabularies;
  }

  @override
  Future<bool> updateVocabularyDifficult(Vocabulary vocabulary) async {
    try {
      final database = await dbProvider.database;
      Batch batch = database.batch();

      batch.rawUpdate(
        'UPDATE vocabulary SET difficult = ? WHERE id = ?',
        [
          0,
          vocabulary.id,
        ],
      );

      await batch.commit();
      return true;
    } catch (error) {
      if (kDebugMode) print(error);
      return false;
    }
  }
}
