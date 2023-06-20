import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_course_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_course_with_public_id_usecase.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetAllCourseUsecase(Get.find()));
    Get.lazyPut(() => GetAllCourseUsecase(Get.find()));
    Get.lazyPut(() => GetVocabulariesWithCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => GetCourseWithPublicIdUsecase(Get.find()));
    Get.put(HomeController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
