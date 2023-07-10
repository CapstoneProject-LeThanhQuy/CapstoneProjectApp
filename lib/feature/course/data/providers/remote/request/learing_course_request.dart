class LearingCourseRequest {
  int? courseId;
  int? point;
  int? difficult;
  int? learned;

  LearingCourseRequest(
    this.courseId,
    this.point,
    this.difficult,
    this.learned,
  );

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'point': point,
      'difficult': difficult,
      'learned': learned,
    };
  }
}
