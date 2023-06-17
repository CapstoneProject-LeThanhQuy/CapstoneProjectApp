import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: false, name: 'data')
class CourseModel {
  int? id;
  String? title;
  String? description;
  String? image;
  int? progress;
  int? totalWords;
  int? member;
  double? rating;
  String? publicId;
  int? userId;
  String? password;

  CourseModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.progress,
    this.totalWords,
    this.member,
    this.rating,
    this.publicId,
    this.userId,
    this.password,
  });

  Map<String, dynamic> toJsonView() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'progress': progress,
      'totalWords': totalWords,
      'member': member,
      'rating': rating,
      'publicId': publicId,
      'userId': userId,
      'password': password,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'progress': progress,
      'total_words': totalWords,
      'password': password,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> json) {
    return CourseModel(
      id: json["id"],
      userId: json["user_id"],
      publicId: json["public_id"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
      totalWords: json["total_words"],
      progress: json["progress"],
      member: json["member"],
      rating: json["rating"],
      password: json["password"],
    );
  }
}
