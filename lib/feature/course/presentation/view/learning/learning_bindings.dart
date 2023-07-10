import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/update_course_local_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/learing_course_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/learning/learning_controller.dart';
import 'package:get/get.dart';

class LearningBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetVocabulariesWithCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => UpdateCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => LearingCourseUsecase(Get.find()));

    Get.put(LearningController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
