import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: true, name: 'data')
class CourseDownloadModel {
  dynamic course;
  List<dynamic>? courseLevels;
  List<dynamic>? courseVocabularies;
  bool? isFollow;

  CourseDownloadModel({
    this.course,
    this.courseLevels,
    this.courseVocabularies,
    this.isFollow,
  });
}
