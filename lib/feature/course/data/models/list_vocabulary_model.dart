import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: false, name: 'data')
class ListVocabularyModel {
  List<dynamic>? words;

  ListVocabularyModel(this.words);
}
