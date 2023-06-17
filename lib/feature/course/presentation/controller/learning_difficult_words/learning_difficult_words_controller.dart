import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:get/get.dart';

class LearningDifficultWordsController extends BaseController<List<Vocabulary>> {
  RxList<Vocabulary> vocabularies = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    vocabularies.value = input;
  }

  void refreshWords(Vocabulary vocabulary) {
    try {
      vocabularies.remove(vocabulary);
      if (vocabularies.isEmpty) {
        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }

  void toLearnWord(int index) {
    N.toLearningDifficult(vocabulary: vocabularies[index]);
  }
}
