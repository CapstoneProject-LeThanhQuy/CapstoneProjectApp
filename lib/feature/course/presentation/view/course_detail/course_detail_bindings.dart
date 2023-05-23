import 'package:easy_english/base/domain/usecases/get_course_level_local_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/course_detail/course_detail_controller.dart';
import 'package:get/get.dart';

class CourseDetailBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetCourseLevelLocalUsecase(Get.find()));

    Get.put(CourseDetailController(Get.find()));
  }
}
