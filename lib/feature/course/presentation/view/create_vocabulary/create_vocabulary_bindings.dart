import 'package:easy_english/feature/course/domain/usecases/download_course_with_id_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_image_with_key_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_vocabularies_from_url_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/update_course_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/create_vocabulary/create_vocabulary_controller.dart';
import 'package:get/get.dart';

class CreateVocabularyBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetImageWithKeyUsecase(Get.find()));
    Get.lazyPut(() => GetVocabulariesFromUrlUsecase(Get.find()));
    Get.lazyPut(() => UpdateCourseUsecase(Get.find()));
    Get.lazyPut(() => DownloadCourseWithIdUsecase(Get.find()));
    Get.put(CreateVocabularyController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
