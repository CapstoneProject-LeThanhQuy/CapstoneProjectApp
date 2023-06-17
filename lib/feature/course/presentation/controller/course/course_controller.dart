import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_all_course_request.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_course_follow_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_course_usecase.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/extension/route_type.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CourseController extends BaseController {
  final GetCourseLocalUsecase _getCourseLocalUsecase;
  final GetAllCourseUsecase _getAllCourseUsecase;
  final GetAllCourseFollowUsecase _getAllCourseFollowUsecase;

  CourseController(
    this._getCourseLocalUsecase,
    this._getAllCourseUsecase,
    this._getAllCourseFollowUsecase,
  );

  RxList<Course> localCourses = RxList.empty();
  RxList<Course> myCourses = RxList.empty();
  RxList<Course> followCourses = RxList.empty();

  ScrollController scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);

  RxBool isLoading1 = false.obs;
  RxBool isLoading2 = false.obs;
  RxBool isLoading3 = false.obs;

  @override
  void onInit() {
    super.onInit();
    onGetListCourse();
  }

  void onRefresh() async {
    localCourses = RxList.empty();
    myCourses = RxList.empty();
    followCourses = RxList.empty();
    await Future.delayed(const Duration(milliseconds: 300));
    onGetListCourse();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 200));
    refreshController.loadComplete();
  }

  void onGetListCourse() {
    isLoading1.value = true;
    _getCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) async {
          await Future.delayed(const Duration(milliseconds: 1000));
          isLoading1.value = false;
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          localCourses.value = val
              .map((course) => Course(
                  course.id ?? 0,
                  course.publicId ?? 0,
                  course.title ?? '',
                  '',
                  course.image ?? '',
                  course.totalWords ?? 0,
                  course.learnedWords ?? 0,
                  course.member ?? 0,
                  course.progress ?? 0,
                  course.point ?? 0))
              .toList();
        },
        onError: (e) {
          isLoading1.value = false;
          print(e);
        },
      ),
    );

    isLoading2.value = true;
    _getAllCourseUsecase.execute(
      observer: Observer(
        onSuccess: (val) async {
          await Future.delayed(const Duration(milliseconds: 1000));
          isLoading2.value = false;
          if (kDebugMode) {
            print(val);
          }
          myCourses.value = val
              .map(
                (course) => Course(
                  course.id ?? 0,
                  int.parse(course.publicId ?? '0'),
                  course.title ?? '',
                  course.description ?? '',
                  course.image ?? '',
                  course.totalWords ?? 0,
                  0,
                  course.member ?? 0,
                  course.progress ?? 0,
                  0,
                ),
              )
              .toList();
        },
        onError: (e) {
          isLoading2.value = false;
          print(e);
        },
      ),
      input: GetAllCourseRequest(true, 0, 0),
    );

    isLoading3.value = true;
    _getAllCourseFollowUsecase.execute(
      observer: Observer(
        onSuccess: (val) async {
          await Future.delayed(const Duration(milliseconds: 1000));
          if (kDebugMode) {
            print(val);
          }
          followCourses.value = val.map((course) {
            return Course(
              course.id ?? 0,
              int.parse(course.publicId ?? '0'),
              course.title ?? '',
              course.description ?? '',
              course.image ?? '',
              course.totalWords ?? 0,
              0,
              course.member ?? 0,
              course.progress ?? 0,
              0,
            );
          }).toList();
          for (var course in localCourses) {
            followCourses.removeWhere((element) => element.id == course.id);
          }
          isLoading3.value = false;
        },
        onError: (e) {
          isLoading3.value = false;
          print(e);
        },
      ),
    );
  }

  void createCourse() {
    N.toCreateCoursePage();
  }

  void toCourseUpdate(int index) {
    Course course = myCourses[index];
    N.toCreateVocabulary(
      courseModel: CourseModel(
        id: course.id,
        title: course.title,
      ),
      type: RouteType.to,
    );
  }

  void toCourseDetail(int index) {
    Course course = followCourses[index];
    N.toHomeCourseDetail(
      courseModel: CourseModel(
        id: course.id,
        title: course.title,
      ),
    );
  }
}
