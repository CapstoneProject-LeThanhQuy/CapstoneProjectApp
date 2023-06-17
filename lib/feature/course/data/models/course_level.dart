import 'package:easy_english/feature/course/data/models/vocabulary.dart';

class CourseLevel {
  int id;
  int level;
  String title;
  int totalWords;
  int learnedWords;
  int courseId;
  List<Vocabulary>? vocabularies;
  TypeUpdate? typeUpdate;

  CourseLevel(
    this.id,
    this.level,
    this.title,
    this.courseId,
    this.totalWords,
    this.learnedWords, {
    this.vocabularies,
    this.typeUpdate,
  });

  factory CourseLevel.copy(CourseLevel courseLevel) => CourseLevel(
        courseLevel.id,
        courseLevel.level,
        courseLevel.title,
        courseLevel.courseId,
        courseLevel.totalWords,
        courseLevel.learnedWords,
        typeUpdate: courseLevel.typeUpdate,
        vocabularies: courseLevel.vocabularies,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'level': level,
      'total_words': totalWords,
    };
  }

  factory CourseLevel.fromMap(Map<String, dynamic> json) {
    return CourseLevel(
      json["id"] ?? 0,
      json["level_difficult"] ?? 0,
      json["title"] ?? '',
      json["course_id"] ?? 0,
      json["total_words"] ?? 0,
      0,
    );
  }
}

enum TypeUpdate {
  isNew,
  isUpdate,
  isDelete,
}
