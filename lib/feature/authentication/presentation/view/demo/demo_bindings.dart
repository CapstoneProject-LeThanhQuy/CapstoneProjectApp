import 'package:easy_english/base/domain/usecases/create_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_vocabularies_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_local_usecase.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/get_user_data_usecase.dart';
import '../../controller/demo/demo_controller.dart';

class DemoBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetDataUserUsecase(Get.find()));
    Get.lazyPut(() => GetCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => CreateCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => GetVocabulariesLocalUsecase(Get.find()));
    Get.lazyPut(() => CreateVocabulariesLocalUsecase(Get.find()));

    Get.put(DemoController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
