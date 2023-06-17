import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: false, name: 'data')
class AccountModel {
  int? id;
  String? username;
  String? email;
  String? phoneNumber;
  bool? gender;
  int? point;
  int? learnedWords;
  bool? isPremium;

  AccountModel({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.gender,
    this.point,
    this.learnedWords,
    this.isPremium,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'point': point,
      'learnedWords': learnedWords,
      'isPremium': isPremium,
    };
  }
}
