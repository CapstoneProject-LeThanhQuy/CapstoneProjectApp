class VocabularyLocal {
  int? id;
  String? englishText;
  String? vietnameseText;
  int? times;
  int? level;
  int? courseId;

  VocabularyLocal({
    this.id,
    required this.englishText,
    required this.vietnameseText,
    this.times,
    required this.level,
    required this.courseId,
  });

  VocabularyLocal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    englishText = map['english_text'];
    vietnameseText = map['vietnamese_text'];
    times = map['times'];
    level = map['level'];
    courseId = map['course_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'english_text': englishText,
      'vietnamese_text': vietnameseText,
      'times': times,
      'level': level,
      'course_id': courseId,
    };
    return map;
  }
}
