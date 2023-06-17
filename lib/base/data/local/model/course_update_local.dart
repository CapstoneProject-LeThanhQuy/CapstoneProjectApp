import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';

class CourseUpdateLocal {
  int point;
  int levelLearnedWord;
  int courseLearnedWord;
  List<VocabularyLocal> vocabularyList;

  CourseUpdateLocal({
    required this.point,
    required this.levelLearnedWord,
    required this.courseLearnedWord,
    required this.vocabularyList,
  });
}
