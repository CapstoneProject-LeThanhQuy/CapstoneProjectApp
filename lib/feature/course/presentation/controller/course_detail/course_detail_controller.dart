import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/base/domain/usecases/get_course_level_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CourseDetailController extends BaseController<Course> {
  final GetCourseLevelLocalUsecase _getCourseLevelLocalUsecase;
  final GetVocabulariesWithCourseLocalUsecase _getVocabulariesWithCourseLocalUsecase;

  CourseDetailController(
    this._getCourseLevelLocalUsecase,
    this._getVocabulariesWithCourseLocalUsecase,
  );

  RxList<CourseLevel> courseLevels = RxList.empty();
  List<Vocabulary> allVocabularies = [];

  RxString? title;
  RxBool isHasNewWord = false.obs;
  RxInt point = 0.obs;

  @override
  void onInit() {
    super.onInit();
    title?.value = input.title;
    onGetListCourseLevel(input.id);
  }

  void onGetListCourseLevel(id) {
    AppConfig.isSpeakLearn = false;
    _getCourseLevelLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print(val);
          }

          courseLevels.value = val
              .map(
                (courseLevel) => CourseLevel(
                  courseLevel.id ?? 0,
                  courseLevel.level ?? 0,
                  courseLevel.title ?? '',
                  courseLevel.courseId ?? 0,
                  courseLevel.totalWords ?? 0,
                  courseLevel.learnedWords ?? 0,
                ),
              )
              .toList();
          point.value = AppConfig.currentCourse.point;
          getAllVocabularies();
        },
        onError: (e) {
          print(e);
        },
      ),
      input: id,
    );
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
          difficltWords.value = BaseHelper.totalWordDifficult(allVocabularies);
          reviewWords.value = BaseHelper.totalWordNeedReview(allVocabularies);
          isHasNewWord.value = BaseHelper.isHasNewWords(allVocabularies);
        },
        onError: (e) async {
          systemError();
          print(e);
        },
      ),
      input: AppConfig.currentCourse.id,
    );
  }

  void learnNewWords() {
    if (allVocabularies.isNotEmpty) {
      AppConfig.isSpeakLearn = false;
      for (var level in courseLevels) {
        if (level.learnedWords < level.totalWords) {
          List<Vocabulary> listVocabularies =
              allVocabularies.where((vocabulary) => vocabulary.levelId == level.id).toList();
          AppConfig.currentCourseLevel = level;
          N.toLearningPage(vocabularies: BaseHelper.selectWordToLearn(listVocabularies));
          return;
        }
      }
      N.toLearningPage(
          vocabularies: BaseHelper.selectWordToLearn(
        allVocabularies,
        isReview: true,
      ));
    }
  }

  RxInt difficltWords = 0.obs;
  RxInt reviewWords = 0.obs;

  void learnDifficultWord() {
    if (allVocabularies.isNotEmpty) {
      if (AppConfig.currentCourse.totalWords > 0 && BaseHelper.totalWordDifficult(allVocabularies) > 0) {
        AppConfig.isSpeakLearn = false;
        N.toLearnDifficultWord(vocabularies: BaseHelper.allWordDifficult(allVocabularies));
      }
    }
  }

  void reviewLearnedWord() {
    if (allVocabularies.isNotEmpty) {
      if (AppConfig.currentCourse.totalWords > 0 && AppConfig.currentCourse.learnedWords > 0) {
        AppConfig.isSpeakLearn = false;
        N.toLearningPage(
          vocabularies: BaseHelper.selectWordToLearn(
            allVocabularies,
            isReview: true,
          ),
        );
      }
    }
  }

  void speakLearnedWord() {
    if (allVocabularies.isNotEmpty) {
      if (AppConfig.currentCourse.totalWords > 0 && AppConfig.currentCourse.learnedWords > 0) {
        AppConfig.isSpeakLearn = true;
        N.toLearningPage(
            vocabularies: BaseHelper.selectWordToLearn(
          allVocabularies,
          isReview: true,
        ));
      }
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
