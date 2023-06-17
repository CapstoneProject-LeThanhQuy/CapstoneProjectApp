import 'package:easy_english/feature/course/domain/usecases/create_course_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/create_course/create_course_controller.dart';
import 'package:get/get.dart';

class CreateCourseBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateCourseUsecase(Get.find()));
    Get.put(CreateCourseController(Get.find()));
  }
}
