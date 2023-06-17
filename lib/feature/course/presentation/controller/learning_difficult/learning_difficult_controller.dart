import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/update_vocabulary_difficult_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/presentation/controller/learning/learning_controller.dart';
import 'package:easy_english/feature/course/presentation/controller/learning_difficult_words/learning_difficult_words_controller.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_helper.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LearningDifficultController extends BaseController<Vocabulary> {
  final GetVocabulariesWithCourseLocalUsecase _getVocabulariesWithCourseLocalUsecase;
  final UpdateVocabularyDifficultLocalUsecase _updateVocabularyDifficultLocalUsecase;

  LearningDifficultController(
    this._getVocabulariesWithCourseLocalUsecase,
    this._updateVocabularyDifficultLocalUsecase,
  );

  Vocabulary? vocabulary;
  RxInt currentIndex = 0.obs;
  Rx<TypeLearning> currentType = TypeLearning.difficultWord.obs;
  bool isSpeaking = false;
  final CommonTextToSpeech _commonTextToSpeech = CommonTextToSpeech();
  RxList<String> listKeyReview = RxList.empty();
  RxList<Vocabulary> allVocabularies = RxList.empty();
  RxBool isReview = false.obs;
  RxBool isCompleted = false.obs;
  bool chooseVietnamese = false;
  List<Vocabulary> anotherAnswers = [];

  @override
  void onInit() {
    super.onInit();
    vocabulary = input;
    if (vocabulary != null) {
      getStart();
    } else {
      systemError();
    }
  }

  void speechText({Function? completed}) {
    try {
      _commonTextToSpeech.speech(
        vocabulary?.englishText ?? '',
        completed: completed,
      );
    } catch (e) {
      completed!();
    }
  }

  void getStart() {
    _getVocabulariesWithCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          allVocabularies.value = val
              .map(
                (vocabulary) => Vocabulary(
                  vocabulary.id ?? 0,
                  (vocabulary.englishText ?? '').toUpperCase(),
                  (vocabulary.vietnameseText ?? '').toUpperCase(),
                  vocabulary.image ?? '',
                  vocabulary.progress ?? 0,
                  vocabulary.difficult ?? 0,
                  vocabulary.courseId ?? 0,
                  vocabulary.levelId ?? 0,
                  vocabulary.wordType ?? '',
                  vocabulary.lastTimeLearning ?? '',
                ),
              )
              .toList();
          learnWord();
        },
        onError: (e) async {
          systemError();
          print(e);
        },
      ),
      input: AppConfig.currentCourse.id,
    );
  }

  void learnWord() {
    switch (currentIndex.value) {
      case 0:
        speechText();
        currentType.value = TypeLearning.difficultWord;
        break;
      case 1:
        chooseVietnamese = true;
        anotherAnswers = getRandomVocabulary();
        currentType.value = TypeLearning.learningWord;
        break;
      case 2:
        chooseVietnamese = false;
        anotherAnswers = getRandomVocabulary();
        currentType.value = TypeLearning.learningWord;
        break;
      case 3:
      case 4:
        isReview = true.obs;
        reviewWords();
        break;
      default:
        completeLearning();
    }
    currentIndex.value += 1;
  }

  void completeLearning() {
    isCompleted.value = true;
    try {
      _updateVocabularyDifficultLocalUsecase.execute(
        observer: Observer(
          onSuccess: (val) {
            if (val) {
              Get.find<LearningDifficultWordsController>().refreshWords(vocabulary!);
              Get.find<HomeController>().onRefresh();
              Get.back();
            } else {
              systemError();
            }
          },
          onError: (e) async {
            systemError();
            print(e);
          },
        ),
        input: vocabulary!,
      );
    } catch (e) {
      print(e);
      systemError();
    }
  }

  void reviewWords() {
    listKeyReview = RxList.empty();
    currentType.value = TypeLearning.learningWord;

    listKeyReview.addAll({...(vocabulary?.englishText ?? '').split('')});
    if (listKeyReview.length < 5) {
      listKeyReview.addAll({...getRandomString(6).split('')});
    } else if (listKeyReview.length < 10) {
      listKeyReview.addAll({...getRandomString(4).split('')});
    } else {
      listKeyReview.addAll({...getRandomString(1).split('')});
    }
  }

  void refreshWord() {
    currentIndex.value = 0;
    learnWord();
  }

  List<Vocabulary> getRandomVocabulary() {
    try {
      var currentVocabulary = vocabulary;
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
        if (vocabulary.id == currentVocabulary?.id) {
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
    } catch (e) {
      systemError();
      return [];
    }
  }

  String getRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  void systemError() async {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      title: 'ERROR',
      desc: 'Một số lỗi đã xảy ra với hệ thống, vui lòng thử lại sau',
      descTextStyle: AppTextStyle.w600s17(ColorName.black000),
      btnOkText: 'Okay',
      btnOkOnPress: () {},
      onDismissCallback: (_) {
        Get.back();
      },
    ).show();
  }
}
