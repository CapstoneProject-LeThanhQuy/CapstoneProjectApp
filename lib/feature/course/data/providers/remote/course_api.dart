import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/feature/course/data/models/course_download_model.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/list_course_model.dart';
import 'package:easy_english/feature/course/data/models/list_vocabulary_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/create_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/follow_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_all_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_vocabulary_from_url_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/update_course_request.dart';
import 'package:retrofit/http.dart';

part 'course_api.g.dart';

@RestApi(parser: Parser.DartJsonMapper)
abstract class CourseAPI {
  factory CourseAPI(Dio dioBuilder) = _CourseAPI;

  @POST('/course/vocabulary-from-url')
  Future<ListVocabularyModel> getVocabularyFromUrl(@Body() GetVocabularyFromUrlRequest request);

  @POST('/course/create')
  Future<CourseModel> crateCourse(@Body() CreateCourseRequest request);

  @GET('/course/image')
  Future<List<String>> getImageWithKeyWord(@Query('key_word') String request);

  @POST('/course/update')
  Future<bool> updateCourse(@Body() UpdateCourseRequest request);

  @GET('/course/course-by-id')
  Future<CourseDownloadModel> getCourseWithId(@Query('course_id') String request);

  @POST('/course/all-course')
  Future<ListCourseModel> getAllCourse(@Body() GetAllCourseRequest request);

  @POST('/course/follow')
  Future<bool> followCourse(@Body() FollowCourseRequest request);

  @GET('/course/my-follow')
  Future<ListCourseModel> getAllCourseFllow();

  @GET('/course/course-by-public-id')
  Future<ListCourseModel> getCourseWithPublicId(@Query('course_id') String request);
}
