import 'dart:math';

import 'package:easy_english/base/data/local/model/course_update_local.dart';
import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/update_course_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/feature/course/presentation/controller/course_detail/course_detail_controller.dart';
import 'package:easy_english/feature/course/presentation/controller/course_vocabulary/course_vocabulary_controller.dart';
import 'package:easy_english/feature/home/data/models/target.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_helper.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LearningController extends BaseController<List<Vocabulary>> {
  final GetVocabulariesWithCourseLocalUsecase _getVocabulariesWithCourseLocalUsecase;
  final StorageService _storageService;
  final UpdateCourseLocalUsecase _updateCourseLocalUsecase;
  LearningController(
    this._getVocabulariesWithCourseLocalUsecase,
    this._updateCourseLocalUsecase,
    this._storageService,
  );

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

  RxBool isCompleted = false.obs;
  RxBool isReview = false.obs;
  RxList<String> listKeyReview = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    getAllVocabularies();
    _storageService.setCurrentCourse(AppConfig.currentCourse.toJsonLocal().toString()).then((value) {
      Get.find<HomeController>().getCurrentCourse();
    });
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
                  vocabulary.courseId ?? 0,
                  vocabulary.levelId ?? 0,
                  vocabulary.wordType ?? '',
                  vocabulary.lastTimeLearning ?? '',
                ),
              )
              .toList();
          vocabularies.value = input;
          AppConfig.isReview = vocabularies.firstWhereOrNull((vocabulary) => vocabulary.progress == 0) == null;
          isReview.value = AppConfig.isReview;
          if (input.length < 5) {
            listIndexRandom = [];
            for (var i = 0; i < input.length; i++) {
              listIndexRandom.add(i);
              listIndexRandom.add(i);
              listIndexRandom.add(i);
            }
            if (listIndexRandom.length < 12) {
              while (true) {
                listIndexRandom.add(Random().nextInt(input.length - 1));
                if (listIndexRandom.length == 12) {
                  break;
                }
              }
            }
          }
          listIndexRandom = AppHelper.shuffle(listIndexRandom).cast<int>();

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
    try {
      _commonTextToSpeech.speech(
        vocabularies[listIndexRandom[currentIndex.value]].englishText,
        completed: completed,
      );
    } catch (e) {
      completed!();
    }
  }

  void removeDifficulty() {
    // TO DO Update DB
    vocabularies[listIndexRandom[currentIndex.value]].difficult = 0;
  }

  void nextWord() {
    switch (currentType.value) {
      case TypeLearning.newWord:
        vocabularies[listIndexRandom[currentIndex.value]].progress += 1;
        learnedWord += 1;
        point += 150;
        newWords.add(vocabularies[listIndexRandom[currentIndex.value]].id);
        break;
      case TypeLearning.learningWord:
        reviewWords.add(vocabularies[listIndexRandom[currentIndex.value]].id);
        vocabularies[listIndexRandom[currentIndex.value]].progress += 1;
        if (vocabularies[listIndexRandom[currentIndex.value]].difficult > 0) {
          vocabularies[listIndexRandom[currentIndex.value]].difficult -= 1;
        }

        point += 200;
        break;
      case TypeLearning.difficultWord:
        reviewWords.add(vocabularies[listIndexRandom[currentIndex.value]].id);
        if (vocabularies[listIndexRandom[currentIndex.value]].difficult > 0) {
          vocabularies[listIndexRandom[currentIndex.value]].difficult -= 1;
        }
        point += 50;
        break;
      default:
    }
    if (currentIndex.value == maxIndex - 1) {
      completeLearing();
      isCompleted.value = true;
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
    } else if (isReview.value) {
      listKeyReview = RxList.empty();
      currentType.value = TypeLearning.learningWord;
      var currentVocabulary = vocabularies[listIndexRandom[currentIndex.value]];
      listKeyReview.addAll({...currentVocabulary.englishText.split('')});
      if (listKeyReview.length < 5) {
        listKeyReview.addAll({...getRandomString(6).split('')});
      } else if (listKeyReview.length < 10) {
        listKeyReview.addAll({...getRandomString(4).split('')});
      } else {
        listKeyReview.addAll({...getRandomString(1).split('')});
      }
    } else {
      currentType.value = TypeLearning.learningWord;
      chooseVietnamese = Random().nextDouble() > .3;
      anotherAnswers = getRandomVocabulary();
    }
  }

  String getRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  List<Vocabulary> getRandomVocabulary() {
    try {
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
    } catch (e) {
      systemError();
      return [];
    }
  }

  List<int> reviewWords = [];
  List<int> newWords = [];
  void updateTarget() {
    Target target = AppConfig.currentTarget;
    bool isCompleted = false;
    if ((target.newWords + target.learnedWords) >= target.targetWord) {
      isCompleted = true;
    }
    target.listNewWords = {...(newWords + target.listNewWords)}.toList();
    target.listReviewedWords = {...(reviewWords + target.listReviewedWords)}.toList();
    target.newWords = target.listNewWords.length;
    target.learnedWords = target.listReviewedWords.length;
    target.time = (target.newWords + target.learnedWords) ~/ 12;
    if ((target.newWords + target.learnedWords) >= target.targetWord && !isCompleted) {
      target.consecutiveDays = target.consecutiveDays + 1;
    }

    target.record = max(target.record, target.consecutiveDays);
    _storageService.setTarget(target.toJson().toString()).then(
      (value) {
        Get.find<HomeController>().onRefresh();
      },
    );
  }

  int learnedWord = 0;
  void completeLearing() {
    try {
      List<VocabularyLocal> vocabularyList = vocabularies
          .map(
            (element) => VocabularyLocal(
              id: element.id,
              englishText: element.englishText,
              vietnameseText: element.vietnameseText,
              image: element.image,
              progress: element.progress,
              difficult: element.difficult,
              courseId: element.courseId,
              levelId: element.levelId,
              wordType: element.wordType,
              lastTimeLearning: (DateTime.now().toUtc().millisecondsSinceEpoch).toString(),
            ),
          )
          .toList();
      if (!AppConfig.isReview) {
        AppConfig.currentCourseLevel.learnedWords = AppConfig.currentCourseLevel.learnedWords + learnedWord;
        AppConfig.currentCourse.learnedWords = AppConfig.currentCourse.learnedWords + learnedWord;
      }
      AppConfig.currentCourse.point = AppConfig.currentCourse.point + point.value;
      _updateCourseLocalUsecase.execute(
        observer: Observer(
          onSuccess: (val) {
            if (kDebugMode) {
              print('Gettttttttttttttttttttttttttt');
              print(val);
            }
            if (val) {
              updateTarget();
              if (Get.isRegistered<CourseVocabularyController>()) {
                Get.find<CourseVocabularyController>().onGetListVocabularyWithLevel(vocabularyList.first.levelId!);
              }
              if (Get.isRegistered<CourseDetailController>()) {
                Get.find<CourseDetailController>().onGetListCourseLevel(AppConfig.currentCourse.id);
              }
              if (Get.isRegistered<CourseController>()) {
                Get.find<CourseController>().onGetListCourse();
              }
              Get.find<HomeController>().getCurrentCourse();

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
        input: CourseUpdateLocal(
          point: AppConfig.currentCourse.point,
          levelLearnedWord: AppConfig.currentCourseLevel.learnedWords,
          courseLearnedWord: AppConfig.currentCourse.learnedWords,
          vocabularyList: vocabularyList,
        ),
      );
    } catch (e) {
      print(e);
      systemError();
    }
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

enum TypeLearning {
  newWord,
  reviewWord,
  learningWord,
  difficultWord,
}
