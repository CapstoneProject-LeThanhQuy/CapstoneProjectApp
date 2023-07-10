import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: true, name: 'data')
class FollowModel {
  dynamic myFollow;
  List<dynamic>? follows;

  FollowModel({
    this.follows,
    this.myFollow,
  });
}

class Follow {
  int id;
  int courseId;
  int userId;
  String userName;
  int rating;
  String comment;
  int learnedWords;
  int difficultWords;
  int point;

  Follow({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.learnedWords,
    required this.difficultWords,
    required this.point,
    required this.rating,
  });

  factory Follow.fromMap(Map<String, dynamic> json) {
    return Follow(
      id: json["id"],
      courseId: json["course_id"],
      userId: json["user_id"],
      userName: json["user_name"],
      comment: json["comment"],
      learnedWords: json["learned_words"],
      difficultWords: json["difficult_words"],
      point: json["point"],
      rating: json["rating"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'learnedWords': learnedWords,
      'difficultWords': difficultWords,
      'point': point,
      'rating': rating,
    };
  }
}
