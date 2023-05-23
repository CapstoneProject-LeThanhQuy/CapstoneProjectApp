import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CourseController extends BaseController {
  final GetCourseLocalUsecase _getCourseLocalUsecase;
  CourseController(this._getCourseLocalUsecase);

  RxList<Course> courses = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    onGetListCourse();
  }

  void onGetListCourse() {
    _getCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          courses.value = val
              .map((course) => Course(
                    course.id ?? 0,
                    course.title ?? '',
                    course.image ?? '',
                    course.totalWords ?? 0,
                    course.learnedWords ?? 0,
                    course.member ?? 0,
                    course.progress ?? 0,
                  ))
              .toList();
        },
        onError: (e) {
          print(e);
        },
      ),
    );
  }
}
