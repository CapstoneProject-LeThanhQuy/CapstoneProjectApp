import 'package:easy_english/feature/course/data/models/course_download_model.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/list_vocabulary_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/create_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/follow_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_all_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_vocabulary_from_url_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/update_course_request.dart';

abstract class CourseRepo {
  Future<ListVocabularyModel> getVocabulariesFromUrl(GetVocabularyFromUrlRequest request);
  Future<CourseModel> createCourse(CreateCourseRequest request);
  Future<List<String>> getImageWithKeyWord(String request);
  Future<bool> updateCourse(UpdateCourseRequest request);
  Future<CourseDownloadModel> getCourseWithId(String request);
  Future<List<CourseModel>> getAllCourse(GetAllCourseRequest request);
  Future<bool> followCourse(FollowCourseRequest request);
  Future<List<CourseModel>> getAllCourseFllow();
}
