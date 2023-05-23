class VocabularyLocal {
  int? id;
  String? englishText;
  String? vietnameseText;
  String? image;
  int? progress;
  int? difficult;
  int? courseId;
  int? levelId;

  VocabularyLocal({
    this.id,
    required this.englishText,
    required this.vietnameseText,
    required this.image,
    required this.progress,
    required this.difficult,
    required this.courseId,
    required this.levelId,
  });

  VocabularyLocal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    englishText = map['english_text'];
    vietnameseText = map['vietnamese_text'];
    image = map['image'];
    progress = map['progress'];
    courseId = map['course_id'];
    levelId = map['level_id'];
    difficult = map['difficult'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'english_text': englishText,
      'vietnamese_text': vietnameseText,
      'image': image,
      'progress': progress,
      'course_id': courseId,
      'level_id': levelId,
      'difficult': difficult,
    };
    return map;
  }
}
