import 'package:easy_english/base/domain/usecases/create_course_level_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_vocabularies_local_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/download_course_with_id_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/follow_course_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_follow_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/rate_course_usecase.dart';
import 'package:easy_english/feature/home/presentation/controller/home_course_detail/home_course_detail_controller.dart';
import 'package:get/get.dart';

class HomeCourseDetailBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DownloadCourseWithIdUsecase(Get.find()));
    Get.lazyPut(() => FollowCourseUsecase(Get.find()));
    Get.lazyPut(() => CreateCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => CreateVocabulariesLocalUsecase(Get.find()));
    Get.lazyPut(() => CreateCourseLevelLocalUsecase(Get.find()));
    Get.lazyPut(() => GetAllFollowUsecase(Get.find()));
    Get.lazyPut(() => RateCourseUsecase(Get.find()));
    Get.put(HomeCourseDetailController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
