import 'dart:convert';

import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/usecases/create_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_vocabularies_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_local_usecase.dart';
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
  final GetVocabulariesLocalUsecase _getVocabulariesLocalUsecase;

  DemoController(
    this._getDataUserUsecase,
    this._createCourseLocalUsecase,
    this._getCourseLocalUsecase,
    this._createVocabulariesLocalUsecase,
    this._getVocabulariesLocalUsecase,
  );

  RxString textApi = ''.obs;
  final formKey = GlobalKey<FormBuilderState>();
  final phomeTextEditingController = TextEditingController();
  final memoTextEditingController = TextEditingController();
  final sqlTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  final speechToText = CommonSpeechToText();
  final textToSpeech = CommonTextToSpeech();

  RxList<CourseLocal> courses = RxList.empty();
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
        name: sqlTextEditingController.text,
        totalWords: 10,
        maxLevel: 5,
      ),
    );
  }

  void onGetListCourse() {
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

  void onCreateVocabulary(int courseID) {
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
          englishText: sqlTextEditingController.text,
          vietnameseText: sqlTextEditingController.text,
          times: 1,
          level: 1,
          courseId: courseID,
        )
      ],
    );
  }

  void onGetListVocabulary(int courseID) {
    _getVocabulariesLocalUsecase.execute(
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

  void onTapSpeechToText() {
    speechToText.listen(
      (text) => {phomeTextEditingController.text = text},
    );
  }

  void onTapTextToSpeech() {
    textToSpeech.speech(memoTextEditingController.text);
  }

  // void onTapTextToSpeechStop() {
  //   textToSpeech.stop();
  // }
}
