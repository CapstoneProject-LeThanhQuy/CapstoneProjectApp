import 'package:easy_english/feature/home/presentation/controller/vocabulary_detail/vocabulary_detail_controller.dart';
import 'package:get/get.dart';

class VocabularyDetailBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(VocabularyDetailController());
  }
}
