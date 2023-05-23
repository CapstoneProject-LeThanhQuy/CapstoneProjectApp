import 'dart:math';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cherry_toast/cherry_toast.dart';

class LearningController extends BaseController<List<Vocabulary>> {
  GetVocabulariesWithCourseLocalUsecase _getVocabulariesWithCourseLocalUsecase;
  LearningController(this._getVocabulariesWithCourseLocalUsecase);

  var maxIndex = 12;

  RxList<Vocabulary> vocabularies = RxList.empty();
  List<Vocabulary> allVocabularies = [];

  List<int> listIndexRandom = [0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4];
  RxInt currentIndex = 0.obs;
  RxInt point = 0.obs;
  Rx<TypeLearning> currentType = TypeLearning.newWord.obs;

  bool chooseVietnamese = false;
  List<Vocabulary> anotherAnswers = [];
  bool isSpeaking = false;
  final CommonTextToSpeech _commonTextToSpeech = CommonTextToSpeech();

  @override
  void onInit() {
    super.onInit();
    getAllVocabularies();
  }

  void getAllVocabularies() {
    _getVocabulariesWithCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          allVocabularies = val
              .map(
                (vocabulary) => Vocabulary(
                  vocabulary.id ?? 0,
                  (vocabulary.englishText ?? '').toUpperCase(),
                  (vocabulary.vietnameseText ?? '').toUpperCase(),
                  vocabulary.image ?? '',
                  vocabulary.progress ?? 0,
                  vocabulary.difficult ?? 0,
                ),
              )
              .toList();
          listIndexRandom = AppHelper.shuffle(listIndexRandom).cast<int>();
          vocabularies.value = input;
          learningWord();
        },
        onError: (e) async {
          systemError();
          print(e);
        },
      ),
      input: AppConfig.currentCourse.id,
    );
  }

  void speechText({Function? completed}) {
    _commonTextToSpeech.speech(
      vocabularies[listIndexRandom[currentIndex.value]].englishText,
      completed: completed,
    );
  }

  void checkAnswer() {
    learningWord(isDifficultWord: true);
  }

  void removeDifficulty() {
    // TO DO Update DB
    vocabularies[listIndexRandom[currentIndex.value]].difficult = 0;
  }

  void nextWord() {
    switch (currentType.value) {
      case TypeLearning.newWord:
        vocabularies[listIndexRandom[currentIndex.value]].progress += 1;
        point += 150;
        break;
      case TypeLearning.learningWord:
        vocabularies[listIndexRandom[currentIndex.value]].progress += 1;
        if (vocabularies[listIndexRandom[currentIndex.value]].difficult > 0) {
          vocabularies[listIndexRandom[currentIndex.value]].difficult -= 1;
        }

        point += 200;
        break;
      case TypeLearning.difficultWord:
        if (vocabularies[listIndexRandom[currentIndex.value]].difficult > 0) {
          vocabularies[listIndexRandom[currentIndex.value]].difficult -= 1;
        }
        point += 50;
        break;
      default:
    }
    if (currentIndex.value == maxIndex - 1) {
      Get.back();
      return;
    }
    currentIndex.value = currentIndex.value + 1;
    learningWord();
  }

  void learningWord({bool isDifficultWord = false}) {
    if (vocabularies[listIndexRandom[currentIndex.value]].progress == 0) {
      currentType.value = TypeLearning.newWord;
      speechText();
    } else if (isDifficultWord) {
      point -= 100;
      if (point < 0) {
        point = 0.obs;
      }
      vocabularies[listIndexRandom[currentIndex.value]].difficult = 5;
      currentType.value = TypeLearning.difficultWord;
      speechText();
    } else {
      currentType.value = TypeLearning.learningWord;
      chooseVietnamese = Random().nextDouble() > .3;
      anotherAnswers = getRandomVocabulary();
    }
  }

  List<Vocabulary> getRandomVocabulary() {
    // try {
    var currentVocabulary = vocabularies[listIndexRandom[currentIndex.value]];
    var arrayRandomIndex = List<int>.generate(allVocabularies.length, (int index) => index);
    arrayRandomIndex = AppHelper.shuffle(arrayRandomIndex).cast<int>().sublist(0, 4);

    var anotherVocabularies = [
      allVocabularies[arrayRandomIndex[0]],
      allVocabularies[arrayRandomIndex[1]],
      allVocabularies[arrayRandomIndex[2]],
      allVocabularies[arrayRandomIndex[3]],
    ];
    var removeIndex = 0;
    for (var vocabulary in anotherVocabularies) {
      if (vocabulary.id == currentVocabulary.id) {
        anotherVocabularies.removeAt(removeIndex);
        break;
      }
      removeIndex += 1;
    }
    if (anotherVocabularies.length > 3) {
      anotherVocabularies = anotherVocabularies.sublist(0, 3);
    } else if (anotherVocabularies.length < 3) {
      systemError();
    }
    return anotherVocabularies;
    // } catch (e) {
    //   systemError();
    //   return [];
    // }
  }

  void systemError() async {
    CherryToast.error(
      title: const Text('Error'),
      action: const Text('Một số lỗi đã xảy ra với hệ thống, vui long thử lại sau'),
      animationType: AnimationType.fromTop,
      actionHandler: () {},
    ).show(Get.context!);
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.back();
    Get.back();
  }
}

enum TypeLearning {
  newWord,
  reviewWord,
  learningWord,
  difficultWord,
}
