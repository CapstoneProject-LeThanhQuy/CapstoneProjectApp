import 'package:easy_english/base/domain/usecases/get_vocabularies_with_course_local_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/course_vocabulary/course_vocabulary_controller.dart';
import 'package:get/get.dart';

class CourseVocabularyBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetVocabulariesWithLevelLocalUsecase(Get.find()));

    Get.put(CourseVocabularyController(Get.find()));
  }
}
