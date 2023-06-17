class FollowCourseRequest {
  int? courseId;
  String? password;

  FollowCourseRequest(
    this.courseId,
    this.password,
  );

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'password': password,
    };
  }
}
