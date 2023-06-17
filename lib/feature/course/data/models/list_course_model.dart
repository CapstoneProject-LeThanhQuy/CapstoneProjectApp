import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: false, name: 'data')
class ListCourseModel {
  List<dynamic>? courses;
  int? total;

  ListCourseModel(this.courses, this.total);
}
