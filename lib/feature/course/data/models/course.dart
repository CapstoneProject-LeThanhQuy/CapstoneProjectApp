class Course {
  int id;
  int publicId;
  String title;
  String description;
  String image;
  int totalWords;
  int learnedWords;
  int member;
  int point;
  int progress;

  Course(
    this.id,
    this.publicId,
    this.title,
    this.description,
    this.image,
    this.totalWords,
    this.learnedWords,
    this.member,
    this.progress,
    this.point,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'progress': progress,
      'total_words': totalWords,
    };
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      '"id"': id,
      '"title"': '"$title"',
      '"image"': '"$image"',
      '"description"': '"$description"',
      '"progress"': progress,
      '"total_words"': totalWords,
      '"learned_words"': learnedWords,
      '"member"': member,
      '"point"': point,
      '"publicId"': publicId,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      json["id"],
      json["publicId"],
      json["title"],
      json["description"],
      json["image"],
      json["total_words"],
      json["learned_words"],
      json["member"],
      json["progress"],
      json["point"],
    );
  }
}
