import 'package:easy_english/base/domain/usecases/get_vocabularies_with_course_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CourseVocabularyController extends BaseController<CourseLevel> {
  final GetVocabulariesWithLevelLocalUsecase _getVocabulariesWithLevelLocalUsecase;
  CourseVocabularyController(this._getVocabulariesWithLevelLocalUsecase);

  RxList<Vocabulary> vocabularies = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    onGetListVocabularyWithLevel();
  }

  void onGetListVocabularyWithLevel() {
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
                ),
              )
              .toList();
        },
        onError: (e) {
          print(e);
        },
      ),
      input: input.id,
    );
  }

  void learnNewWord() {
    N.toLearningPage(vocabularies: vocabularies);
  }
}
