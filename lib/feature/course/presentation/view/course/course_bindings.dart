import 'package:easy_english/feature/Course/presentation/controller/course/course_controller.dart';
import 'package:get/get.dart';

class CourseBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CourseController());
  }
}
