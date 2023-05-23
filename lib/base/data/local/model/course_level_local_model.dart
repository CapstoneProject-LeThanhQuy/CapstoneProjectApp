class CourseLevelLocal {
  int? id;
  int? level;
  String? title;
  int? learnedWords;
  int? totalWords;
  int? courseId;

  CourseLevelLocal({
    this.id,
    required this.level,
    required this.title,
    required this.learnedWords,
    required this.totalWords,
    required this.courseId,
  });

  CourseLevelLocal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    level = map['level'];
    title = map['title'];
    learnedWords = map['learned_words'];
    totalWords = map['total_words'];
    courseId = map['course_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'level': level,
      'title': title,
      'learned_words': learnedWords,
      'total_words': totalWords,
      'course_id': courseId,
    };
    return map;
  }
}
