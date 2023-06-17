class CourseLocal {
  int? id;
  int? publicId;
  String? title;
  String? image;
  int? learnedWords;
  int? totalWords;
  int? progress;
  int? member;
  int? point;

  CourseLocal({
    required this.id,
    required this.publicId,
    required this.title,
    required this.image,
    required this.learnedWords,
    required this.totalWords,
    required this.progress,
    required this.member,
    required this.point,
  });

  CourseLocal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    image = map['image'];
    learnedWords = map['learned_words'];
    totalWords = map['total_words'];
    progress = map['progress'];
    member = map['member'];
    point = map['point'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'image': image,
      'learned_words': learnedWords,
      'total_words': totalWords,
      'progress': progress,
      'member': member,
      'point': point,
    };
    return map;
  }
}
