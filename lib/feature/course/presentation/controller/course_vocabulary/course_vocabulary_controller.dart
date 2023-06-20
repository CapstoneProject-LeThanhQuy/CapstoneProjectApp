import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_with_course_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CourseVocabularyController extends BaseController<CourseLevel> {
  final GetVocabulariesWithLevelLocalUsecase _getVocabulariesWithLevelLocalUsecase;
  CourseVocabularyController(this._getVocabulariesWithLevelLocalUsecase);

  RxList<Vocabulary> vocabularies = RxList.empty();
  CourseLevel? courseLevel;

  RxBool isHasNewWord = true.obs;

  @override
  void onInit() {
    super.onInit();

    courseLevel = input;
    onGetListVocabularyWithLevel(input.id);
  }

  void onGetListVocabularyWithLevel(int id) {
    AppConfig.isSpeakLearn = false;
    _getVocabulariesWithLevelLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          vocabularies.value = val
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
                  vocabulary.wordType ?? 'NONE',
                  vocabulary.lastTimeLearning ?? '0',
                ),
              )
              .toList();
          difficltWords.value = BaseHelper.totalWordDifficult(vocabularies);
          reviewWords.value = BaseHelper.totalWordNeedReview(vocabularies);
          isHasNewWord.value = BaseHelper.isHasNewWords(vocabularies);
        },
        onError: (e) {
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
          print(e);
        },
      ),
      input: id,
    );
  }

  void learnNewWord() {
    if (vocabularies.isNotEmpty) {
      AppConfig.isSpeakLearn = false;
      N.toLearningPage(vocabularies: BaseHelper.selectWordToLearn(vocabularies));
    }
  }

  RxInt difficltWords = 0.obs;
  RxInt reviewWords = 0.obs;

  void learnDifficultWord() {
    if (vocabularies.isNotEmpty) {
      if (AppConfig.currentCourse.totalWords > 0 && BaseHelper.totalWordDifficult(vocabularies) > 0) {
        AppConfig.isSpeakLearn = false;
        N.toLearnDifficultWord(vocabularies: BaseHelper.allWordDifficult(vocabularies));
      }
    }
  }

  void reviewLearnedWord() {
    if (vocabularies.isNotEmpty) {
      if (AppConfig.currentCourse.totalWords > 0 && AppConfig.currentCourse.learnedWords > 0) {
        AppConfig.isSpeakLearn = false;
        N.toLearningPage(
          vocabularies: BaseHelper.selectWordToLearn(
            vocabularies,
            isReview: true,
          ),
        );
      }
    }
  }

  void speakLearnedWord() {
    if (vocabularies.isNotEmpty) {
      if (AppConfig.currentCourse.totalWords > 0 && AppConfig.currentCourse.learnedWords > 0) {
        AppConfig.isSpeakLearn = true;
        N.toLearningPage(
            vocabularies: BaseHelper.selectWordToLearn(
          vocabularies,
          isReview: true,
        ));
      }
    }
  }
}
