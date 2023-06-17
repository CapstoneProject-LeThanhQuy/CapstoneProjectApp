import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/update_vocabulary_difficult_local_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/learning_difficult/learning_difficult_controller.dart';
import 'package:get/get.dart';

class LearningDifficultBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetVocabulariesWithCourseLocalUsecase(Get.find()));
    Get.lazyPut(() => UpdateVocabularyDifficultLocalUsecase(Get.find()));
    Get.put(LearningDifficultController(
      Get.find(),
      Get.find(),
    ));
  }
}
