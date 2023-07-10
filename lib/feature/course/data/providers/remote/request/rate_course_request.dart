class RateCourseRequest {
  int? courseId;
  int? rate;
  String? comment;

  RateCourseRequest(
    this.courseId,
    this.rate,
    this.comment,
  );

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'rate': rate,
      'comment': comment,
    };
  }
}
