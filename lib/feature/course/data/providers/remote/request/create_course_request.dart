class CreateCourseRequest {
  String? title;
  String? description;
  String? image;
  int? progress;
  String? password;

  CreateCourseRequest(
    this.title,
    this.description,
    this.image,
    this.progress,
    this.password,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'progress': progress,
      'password': password,
    };
  }
}
