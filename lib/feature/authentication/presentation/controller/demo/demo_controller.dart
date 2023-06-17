import 'dart:convert';

import 'package:easy_english/base/data/local/model/course_level_local_model.dart';
import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/usecases/create_course_level_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_vocabularies_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_course_level_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_with_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/presentation/speech_to_text.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../../base/domain/base_observer.dart';
import '../../../domain/usecases/get_user_data_usecase.dart';

class DemoController extends GetxController {
  final GetDataUserUsecase _getDataUserUsecase;

  final CreateCourseLocalUsecase _createCourseLocalUsecase;
  final GetCourseLocalUsecase _getCourseLocalUsecase;

  final CreateVocabulariesLocalUsecase _createVocabulariesLocalUsecase;
  final GetVocabulariesWithCourseLocalUsecase _getVocabulariesWithCourseLocalUsecase;
  final GetVocabulariesWithLevelLocalUsecase _getVocabulariesWithLevelLocalUsecase;

  final CreateCourseLevelLocalUsecase _createCourseLevelLocalUsecase;
  final GetCourseLevelLocalUsecase _getCourseLevelLocalUsecase;

  DemoController(
    this._getDataUserUsecase,
    this._createCourseLocalUsecase,
    this._getCourseLocalUsecase,
    this._createVocabulariesLocalUsecase,
    this._getVocabulariesWithCourseLocalUsecase,
    this._getVocabulariesWithLevelLocalUsecase,
    this._getCourseLevelLocalUsecase,
    this._createCourseLevelLocalUsecase,
  );

  RxString textApi = ''.obs;
  final formKey = GlobalKey<FormBuilderState>();
  // final phomeTextEditingController = TextEditingController();
  // final memoTextEditingController = TextEditingController();
  // final passwordTextEditingController = TextEditingController();

  final titleTextEditingController = TextEditingController();
  final totalWordsTextEditingController = TextEditingController();
  final learnedWordsTextEditingController = TextEditingController();
  final imageTextEditingController = TextEditingController();
  final memberTextEditingController = TextEditingController();
  final progressWordsTextEditingController = TextEditingController();
  final levelTextEditingController = TextEditingController();
  final englishTextTextEditingController = TextEditingController();
  final vietnameseTextTextEditingController = TextEditingController();

  late List<TextEditingController> listTextEditingController;
  late List<String> title;

  final speechToText = CommonSpeechToText();
  final textToSpeech = CommonTextToSpeech();

  int currentCourseId = 0;

  @override
  void onInit() {
    super.onInit();
    listTextEditingController = [
      titleTextEditingController,
      totalWordsTextEditingController,
      learnedWordsTextEditingController,
      imageTextEditingController,
      memberTextEditingController,
      progressWordsTextEditingController,
      levelTextEditingController,
      englishTextTextEditingController,
      vietnameseTextTextEditingController
    ];
    title = [
      'title',
      'totalWords',
      'learnedWords',
      'image',
      'member',
      'progressWords',
      'level',
      'englishText',
      'vietnameseText',
    ];
  }

  RxList<CourseLocal> courses = RxList.empty();
  RxList<CourseLevelLocal> courseLevels = RxList.empty();
  RxList<VocabularyLocal> vocabularies = RxList.empty();

  void onCreateCourse() {
    _createCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
            print(val);
          }
        },
        onError: (e) {
          print(e);
        },
      ),
      input: CourseLocal(
        id: 0,
        publicId: 0,
        title: titleTextEditingController.text,
        totalWords: int.parse(totalWordsTextEditingController.text),
        learnedWords: int.parse(learnedWordsTextEditingController.text),
        image: imageTextEditingController.text,
        member: int.parse(memberTextEditingController.text),
        progress: int.parse(progressWordsTextEditingController.text),
        point: 0,
      ),
    );
  }

  void onGetListCourse() {
    vocabularies.value = [];
    courseLevels.value = [];
    _getCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          courses.value = val;
        },
        onError: (e) {
          print(e);
        },
      ),
    );
  }

  void onCreateCourseLevel(int courseID) {
    _createCourseLevelLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
            print(val);
          }
        },
        onError: (e) {
          print(e);
        },
      ),
      input: CourseLevelLocal(
        title: titleTextEditingController.text,
        totalWords: int.parse(totalWordsTextEditingController.text),
        learnedWords: int.parse(learnedWordsTextEditingController.text),
        level: int.parse(levelTextEditingController.text),
        courseId: courseID,
      ),
    );
  }

  void onGetListCourseLevel(int courseId) {
    currentCourseId = courseId;
    vocabularies.value = [];
    _getCourseLevelLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          courseLevels.value = val;
        },
        onError: (e) {
          print(e);
        },
      ),
      input: courseId,
    );
  }

  void onCreateVocabulary(int courseID, int LevelID) {
    _createVocabulariesLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Okkkkkkkkkkkkkkkkk');
            print(val);
          }
        },
        onError: (e) {
          print(e);
        },
      ),
      input: [
        VocabularyLocal(
          englishText: englishTextTextEditingController.text,
          vietnameseText: vietnameseTextTextEditingController.text,
          courseId: courseID,
          levelId: LevelID,
          progress: int.parse(progressWordsTextEditingController.text),
          image: imageTextEditingController.text,
          difficult: 0,
          wordType: 'NONE',
          lastTimeLearning: '',
        )
      ],
    );
  }

  void onGetListVocabularyWithCourse(int courseID) {
    courseLevels.value = [];
    _getVocabulariesWithCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          vocabularies.value = val;
        },
        onError: (e) {
          print(e);
        },
      ),
      input: courseID,
    );
  }

  void onGetListVocabularyWithLevel(int levelId) {
    courseLevels.value = courseLevels.where((i) => i.id == levelId).toList();
    _getVocabulariesWithLevelLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          vocabularies.value = val;
        },
        onError: (e) {
          print(e);
        },
      ),
      input: levelId,
    );
  }

  void onTap() {
    _getDataUserUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          if (kDebugMode) {
            print(val.toJson());
          }
          textApi.value = jsonEncode(val.toJson());
        },
        onError: (e) {
          print(e);
        },
      ),
    );
  }

  // void onTapSpeechToText() {
  //   speechToText.listen(
  //     (text) => {phomeTextEditingController.text = text},
  //   );
  // }

  // void onTapTextToSpeech() {
  //   textToSpeech.speech(memoTextEditingController.text);
  // }

  // void onTapTextToSpeechStop() {
  //   textToSpeech.stop();
  // }
}
