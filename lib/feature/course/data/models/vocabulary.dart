import 'package:easy_english/feature/course/data/models/course_level.dart';

class Vocabulary {
  int id;
  String englishText;
  String vietnameseText;
  String image;
  int difficult;
  int progress;
  int courseId;
  int levelId;
  String wordType;
  String lastTimeLearning;
  TypeUpdate? typeUpdate;

  Vocabulary(
    this.id,
    this.englishText,
    this.vietnameseText,
    this.image,
    this.progress,
    this.difficult,
    this.courseId,
    this.levelId,
    this.wordType,
    this.lastTimeLearning, {
    this.typeUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english_text': englishText,
      'vietnamese_text': vietnameseText,
      'image': image,
      'level_id': levelId,
      'word_type': wordType,
    };
  }

  Map<String, dynamic> toJsonView() {
    return {
      'id': id,
      'english_text': englishText,
      'vietnamese_text': vietnameseText,
      'image': image,
      'difficult': difficult,
      'progress': progress,
      'level_id': levelId,
      'word_type': wordType,
      'last_time_learning': lastTimeLearning,
    };
  }

  factory Vocabulary.fromMap(Map<String, dynamic> json) {
    return Vocabulary(
      json["id"],
      json["english_text"] ?? '',
      json["vietnamese_text"] ?? '',
      json["image"] ?? '',
      0,
      0,
      json["course_id"] ?? 0,
      json["level_id"] ?? 0,
      json["word_type"] ?? '',
      '0',
    );
  }
}
