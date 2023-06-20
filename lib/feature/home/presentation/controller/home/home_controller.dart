import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/domain/usecases/get_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/get_vocabularies_withlevel_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_all_course_request.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_course_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_course_with_public_id_usecase.dart';
import 'package:easy_english/feature/home/data/models/target.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends BaseController {
  final GetAllCourseUsecase _getAllCourseUsecase;
  final GetVocabulariesWithCourseLocalUsecase _getVocabulariesWithCourseLocalUsecase;
  final GetCourseLocalUsecase _getCourseLocalUsecase;
  final StorageService _storageService;
  final GetCourseWithPublicIdUsecase _getCourseWithPublicIdUsecase;
  HomeController(
    this._getAllCourseUsecase,
    this._getCourseLocalUsecase,
    this._storageService,
    this._getVocabulariesWithCourseLocalUsecase,
    this._getCourseWithPublicIdUsecase,
  );

  RxBool isLoading = false.obs;
  RxList<CourseModel> listCourse = RxList.empty();
  int page = 0;
  int getCount = 10;
  bool isEnd = false;
  final refreshController = RefreshController(initialRefresh: false);

  ScrollController scrollController = ScrollController();

  bool isShowComplete = false;

  Rx<Target> target = Target(
    record: 0,
    consecutiveDays: 0,
    learnedWords: 0,
    newWords: 0,
    time: 0,
    currentDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    targetWord: 20,
    listNewWords: [],
    listReviewedWords: [],
    listNewWordsTime: [],
    listReviewedWordsTime: [],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent + 20) {
        if (!isLoading.value) {
          if (!isEnd) {
            page += 1;
            getData();
          }
        }
      }
    });
  }

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    page = 0;
    isEnd = false;
    isSearching.value = false;
    listCourse = RxList.empty();
    localCourses = RxList.empty();
    if (!isShowComplete) showCompleteTarget();
    getData();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 200));
    refreshController.loadComplete();
  }

  Rx<Course> curentCourse = Course(
    0,
    0,
    'Easy English',
    '',
    '',
    0,
    0,
    0,
    0,
    0,
  ).obs;

  RxInt difficltWords = 0.obs;
  RxInt reviewWords = 0.obs;
  List<Vocabulary> allVocabularies = [];
  void getCurrentCourse() {
    _storageService.getCurrentCourse().then(
      (value) {
        if (value.isNotEmpty) {
          print(jsonDecode(value));
          curentCourse = Course.fromJson(jsonDecode(value)).obs;
          _getVocabulariesWithCourseLocalUsecase.execute(
            observer: Observer(
              onSuccess: (val) async {
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
              },
              onError: (e) {
                print(e);
              },
            ),
            input: curentCourse.value.id,
          );
        }
      },
    );
  }

  void getDataTarget() {
    // _storageService.removeTarget();
    _storageService.getTarget().then(
      (value) {
        int timeNow = DateTime.now().toUtc().millisecondsSinceEpoch;
        if (value.isNotEmpty) {
          Target localTarget = Target.fromJson(jsonDecode(value));
          localTarget.newWords = localTarget.listNewWords.length;
          localTarget.learnedWords = localTarget.listReviewedWords.length;
          localTarget.time = (localTarget.listNewWordsTime.length + localTarget.listReviewedWordsTime.length) ~/ 24;
          target = localTarget.obs;
          AppConfig.currentTarget = localTarget;
          print(localTarget.toJson());
        } else {
          _storageService.setTarget(
            Target(
              record: 0,
              consecutiveDays: 0,
              learnedWords: 0,
              newWords: 0,
              time: 0,
              currentDate: timeNow,
              targetWord: 20,
              listNewWords: [],
              listReviewedWords: [],
              listReviewedWordsTime: [],
              listNewWordsTime: [],
            ).toJson().toString(),
          );
        }

        DateTime currentDate = DateTime.fromMicrosecondsSinceEpoch(timeNow * 1000);
        DateTime lastTargetDate = DateTime.fromMicrosecondsSinceEpoch(target.value.currentDate * 1000);

        if (currentDate.day > lastTargetDate.day ||
            currentDate.month > lastTargetDate.month ||
            currentDate.year > lastTargetDate.year) {
          int consecutiveDays = (target.value.learnedWords + target.value.newWords) < target.value.targetWord
              ? 0
              : target.value.consecutiveDays;

          if (currentDate.year > lastTargetDate.year ||
              currentDate.month > lastTargetDate.month ||
              currentDate.day > lastTargetDate.day + 1) {
            consecutiveDays = 0;
          }
          int record = max(target.value.record, consecutiveDays);

          target = Target(
            record: record,
            consecutiveDays: consecutiveDays,
            learnedWords: 0,
            newWords: 0,
            time: 0,
            currentDate: timeNow,
            targetWord: target.value.targetWord,
            listNewWords: [],
            listReviewedWords: [],
            listReviewedWordsTime: [],
            listNewWordsTime: [],
          ).obs;
          _storageService.setTarget(target.value.toJson().toString());
        }
      },
    );
  }

  RxList<Course> localCourses = RxList.empty();
  void getData() {
    AppConfig.isSpeakLearn = false;
    getDataTarget();
    getCurrentCourse();
    _getCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) async {
          await Future.delayed(const Duration(milliseconds: 1000));

          if (kDebugMode) {
            print('Gettttttttttttttttttttttttttt');
            print(val);
          }
          localCourses.value = val
              .map((course) => Course(
                  course.id ?? 0,
                  course.publicId ?? 0,
                  course.title ?? '',
                  '',
                  course.image ?? '',
                  course.totalWords ?? 0,
                  course.learnedWords ?? 0,
                  course.member ?? 0,
                  course.progress ?? 0,
                  course.point ?? 0))
              .toList();
        },
        onError: (e) {
          print(e);
        },
      ),
    );

    isLoading.value = true;
    _getAllCourseUsecase.execute(
      observer: Observer(
        onSubscribe: () {},
        onSuccess: (courses) async {
          await Future.delayed(const Duration(milliseconds: 1000));
          isLoading.value = false;
          if (courses.isEmpty) {
            isEnd = true;
          }
          listCourse.addAll(courses);

          for (var course in localCourses) {
            listCourse.removeWhere((element) => element.id == course.id);
          }
          refreshController.refreshCompleted();
        },
        onError: (e) {
          if (e is DioError) {
            if (e.response?.data != null) {
              BaseHelper.tokenError(e);
              try {
                _showToastMessage(e.response!.data['message'].toString());
              } catch (e) {
                _showToastMessage(e.toString());
              }
            } else {
              _showToastMessage(e.message ?? 'error');
            }
          }
          if (kDebugMode) {
            print(e.toString());
          }

          isLoading.value = false;
          refreshController.refreshCompleted();
        },
      ),
      input: GetAllCourseRequest(false, getCount, page),
    );
  }

  void toCourseDetail(int index) {
    N.toHomeCourseDetail(courseModel: listCourse[index]);
  }

  void _showToastMessage(String message) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      title: "ERROR",
      desc: message,
      descTextStyle: AppTextStyle.w600s17(ColorName.black000),
      btnOkText: 'Okay',
      btnOkOnPress: () {},
      onDismissCallback: (_) {},
    ).show();
  }

  void showCompleteTarget() {
    if ((target.value.newWords + target.value.learnedWords) >= target.value.targetWord) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        title: 'Hoàn thành',
        desc: 'Chúc mừng bạn đã hoàn thành mục tiêu hôm nay rồi',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {
          isShowComplete = true;
        },
      ).show();
    }
  }

  void learnDifficultWord() {
    if (allVocabularies.isNotEmpty) {
      if (curentCourse.value.totalWords > 0 && BaseHelper.totalWordDifficult(allVocabularies) > 0) {
        AppConfig.currentCourse = curentCourse.value;
        AppConfig.isSpeakLearn = false;
        N.toLearnDifficultWord(vocabularies: BaseHelper.allWordDifficult(allVocabularies));
      }
    }
  }

  void reviewLearnedWord() {
    if (allVocabularies.isNotEmpty) {
      if (curentCourse.value.totalWords > 0 && curentCourse.value.learnedWords > 0) {
        AppConfig.currentCourse = curentCourse.value;
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
      if (curentCourse.value.totalWords > 0 && curentCourse.value.learnedWords > 0) {
        AppConfig.currentCourse = curentCourse.value;
        AppConfig.isSpeakLearn = true;
        N.toLearningPage(
            vocabularies: BaseHelper.selectWordToLearn(
          allVocabularies,
          isReview: true,
        ));
      }
    }
  }

  void updateTarget(int numberTarget) {
    target.value.targetWord = numberTarget;
    target.refresh();
    _storageService.setTarget(target.value.toJson().toString());
  }

  RxBool isSearching = false.obs;
  void onSearch(String value) {
    isLoading.value = true;
    listCourse = RxList.empty();
    _getCourseWithPublicIdUsecase.execute(
      observer: Observer(
        onSubscribe: () {},
        onSuccess: (courses) async {
          await Future.delayed(const Duration(milliseconds: 1000));
          isLoading.value = false;
          isEnd = true;
          listCourse.addAll(courses);

          for (var course in localCourses) {
            listCourse.removeWhere((element) => element.id == course.id);
          }
        },
        onError: (e) {
          if (e is DioError) {
            if (e.response?.data != null) {
              BaseHelper.tokenError(e);
            } else {
              _showToastMessage(e.message ?? 'error');
            }
          }
          if (kDebugMode) {
            print(e.toString());
          }

          isLoading.value = false;
          refreshController.refreshCompleted();
        },
      ),
      input: value,
    );
  }
}
