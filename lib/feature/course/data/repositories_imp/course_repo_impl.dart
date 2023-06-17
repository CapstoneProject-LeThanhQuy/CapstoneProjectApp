import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/course/data/models/course_download_model.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/list_course_model.dart';
import 'package:easy_english/feature/course/data/models/list_vocabulary_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/course_api.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/create_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/follow_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_all_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_vocabulary_from_url_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/update_course_request.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  final _courseApi = Get.find<CourseAPI>();

  @override
  Future<ListVocabularyModel> getVocabulariesFromUrl(GetVocabularyFromUrlRequest request) {
    return _courseApi.getVocabularyFromUrl(request);
  }

  @override
  Future<CourseModel> createCourse(CreateCourseRequest request) {
    return _courseApi.crateCourse(request);
  }

  @override
  Future<List<String>> getImageWithKeyWord(String request) {
    return _courseApi.getImageWithKeyWord(request);
  }

  @override
  Future<bool> updateCourse(UpdateCourseRequest request) {
    return _courseApi.updateCourse(request);
  }

  @override
  Future<CourseDownloadModel> getCourseWithId(String request) {
    return _courseApi.getCourseWithId(request);
  }

  @override
  Future<List<CourseModel>> getAllCourse(GetAllCourseRequest request) async {
    ListCourseModel listCourseModel = await _courseApi.getAllCourse(request);

    return (listCourseModel.courses ?? []).map((course) => CourseModel.fromMap(course)).toList();
  }

  @override
  Future<bool> followCourse(FollowCourseRequest request) {
    return _courseApi.followCourse(request);
  }


  @override
  Future<List<CourseModel>> getAllCourseFllow() async {
    ListCourseModel listCourseModel = await _courseApi.getAllCourseFllow();

    return (listCourseModel.courses ?? []).map((course) => CourseModel.fromMap(course)).toList();
  }
}
