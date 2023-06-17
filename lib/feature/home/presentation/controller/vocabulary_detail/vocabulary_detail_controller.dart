import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:get/get.dart';

class VocabularyDetailController extends BaseController<Vocabulary> {
  Vocabulary? vocabulary;

  @override
  void onInit() {
    super.onInit();
    vocabulary = input;
    if (vocabulary?.englishText != null) {
      speechText();
    }
  }

  final CommonTextToSpeech _commonTextToSpeech = CommonTextToSpeech();

  bool isPlaying = false;
  void speechText() {
    if (!isPlaying) {
      isPlaying = true;
      try {
        _commonTextToSpeech.speech(
          vocabulary?.englishText ?? '',
          completed: () {
            isPlaying = false;
          },
        );
      } catch (e) {
        isPlaying = false;
      }
    }
  }
}
