import 'package:easy_english/base/domain/usecases/get_all_vocabulary_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_image_with_key_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_vocabularies_from_url_usecase.dart';
import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:get/get.dart';

class GameBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetAllVocabularyUsecase(Get.find()));
    Get.lazyPut(() => GetImageWithKeyUsecase(Get.find()));
    Get.lazyPut(() => GetVocabulariesFromUrlUsecase(Get.find()));
    Get.put(GameController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
