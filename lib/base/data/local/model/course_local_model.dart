class CourseLocal {
  int? id;
  String? name;
  int? totalWords;
  int? maxLevel;

  CourseLocal({
    this.id,
    required this.name,
    required this.totalWords,
    required this.maxLevel,
  });

  CourseLocal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    totalWords = map['total_words'];
    maxLevel = map['max_level'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'total_words': totalWords,
      'max_level': maxLevel,
    };
    return map;
  }
}
