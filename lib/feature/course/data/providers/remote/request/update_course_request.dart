import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';

class UpdateCourseRequest {
  CourseModel? course;
  List<CourseLevel>? listCourseLevelAdd;
  List<CourseLevel>? listCourseLevelUpdate;
  List<CourseLevel>? listCourseLevelDelete;
  List<Vocabulary>? vocabulariesAdd;
  List<Vocabulary>? vocabulariesUpdate;
  List<Vocabulary>? vocabulariesDelete;

  UpdateCourseRequest({
    this.course,
    this.listCourseLevelAdd,
    this.listCourseLevelUpdate,
    this.listCourseLevelDelete,
    this.vocabulariesAdd,
    this.vocabulariesUpdate,
    this.vocabulariesDelete,
  });

  Map<String, dynamic> toJson() {
    return {
      'course': course?.toJson(),
      'course_level_add': listCourseLevelAdd?.map((level) => level.toJson()).toList(),
      'course_level_update': listCourseLevelUpdate?.map((level) => level.toJson()).toList(),
      'course_level_delete': listCourseLevelDelete?.map((level) => level.toJson()).toList(),
      'vocabulary_add': vocabulariesAdd?.map((level) => level.toJson()).toList(),
      'vocabulary_update': vocabulariesUpdate?.map((level) => level.toJson()).toList(),
      'vocabulary_delete': vocabulariesDelete?.map((level) => level.toJson()).toList(),
    };
  }
}
