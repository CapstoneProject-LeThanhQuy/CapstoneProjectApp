import 'package:easy_english/base/domain/usecases/get_all_vocabulary_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_course_follow_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_course_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_course_with_public_id_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_vocabularies_from_url_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/feature/setting/presentation/controller/setting/setting_controller.dart';
import 'package:get/get.dart';
import './tab_bar_controller.dart';

class TabBarBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => GetAllCourseUsecase(Get.find()));
    Get.lazyPut(() => GetAllCourseFollowUsecase(Get.find()));
    Get.lazyPut(() => GetVocabulariesWithCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => GetCourseWithPublicIdUsecase(Get.find()));
    Get.lazyPut(
      () => HomeController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
    Get.lazyPut(
      () => CourseController(
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
    Get.lazyPut(() => GetAllVocabularyUsecase(Get.find()));
    Get.lazyPut(
      () => GameController(
        Get.find(),
        Get.find(),
      ),
    );
    Get.lazyPut(() => SettingController(Get.find()));
    Get.put(TabBarController());
  }
}
