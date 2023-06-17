import 'package:easy_english/feature/course/presentation/controller/learning_difficult_words/learning_difficult_words_controller.dart';
import 'package:get/get.dart';

class LearningDifficultWordsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(LearningDifficultWordsController());
  }
}
