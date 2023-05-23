import 'package:easy_english/base/domain/usecases/get_course_level_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CourseDetailController extends BaseController<Course> {
  final GetCourseLevelLocalUsecase _getCourseLevelLocalUsecase;
  CourseDetailController(this._getCourseLevelLocalUsecase);

  RxList<CourseLevel> courseLevels = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    onGetListCourseLevel();
  }

  void onGetListCourseLevel() {
    _getCourseLevelLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          courseLevels.value = val
              .map(
                (courseLevel) => CourseLevel(
                  courseLevel.id ?? 0,
                  courseLevel.level ?? 0,
                  courseLevel.title ?? '',
                  courseLevel.totalWords ?? 0,
                  courseLevel.learnedWords ?? 0,
                ),
              )
              .toList();
        },
        onError: (e) {
          print(e);
        },
      ),
      input: input.id,
    );
  }
}
