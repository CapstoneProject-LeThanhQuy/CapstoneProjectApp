import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/data/local/model/course_level_local_model.dart';
import 'package:easy_english/base/data/local/model/course_local_model.dart';
import 'package:easy_english/base/data/local/model/vocabulary_local_model.dart';
import 'package:easy_english/base/domain/usecases/create_course_level_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_course_local_usecase.dart';
import 'package:easy_english/base/domain/usecases/create_vocabularies_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/follow_model.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/follow_course_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/rate_course_request.dart';
import 'package:easy_english/feature/course/domain/usecases/download_course_with_id_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/follow_course_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_all_follow_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/rate_course_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/feature/home/data/models/rank.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/simpletreeview/lib/flutter_simple_treeview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeCourseDetailController extends BaseController<CourseModel> {
  final FollowCourseUsecase _followCourseUsecase;
  final DownloadCourseWithIdUsecase _downloadCourseWithIdUsecase;
  final CreateCourseLocalUsecase _createCourseLocalUsecase;
  final CreateVocabulariesLocalUsecase _createVocabulariesLocalUsecase;
  final CreateCourseLevelLocalUsecase _createCourseLevelLocalUsecase;
  final GetAllFollowUsecase _getAllFollowUsecase;
  final RateCourseUsecase _rateCourseUsecase;

  HomeCourseDetailController(
    this._followCourseUsecase,
    this._downloadCourseWithIdUsecase,
    this._createCourseLocalUsecase,
    this._createVocabulariesLocalUsecase,
    this._createCourseLevelLocalUsecase,
    this._getAllFollowUsecase,
    this._rateCourseUsecase,
  );

  final formKey = GlobalKey<FormBuilderState>();

  TextEditingController commentTextEditingController = TextEditingController();
  Rx<CourseModel> course = CourseModel().obs;
  bool isPrivateCourse = false;
  RxBool isLoading = false.obs;

  List<CourseLevel> listCourseLevelData = [];

  RxList<CourseLevel> listCourseLevelView = RxList.empty();

  RxBool isSearching = false.obs;

  final treeController = TreeController();

  ScrollController scrollController = ScrollController();

  RxBool isFollow = false.obs;

  RxList<Rank> listRank = RxList.empty();
  RxList<Follow> listRate = RxList.empty();
  RxDouble rate = 0.0.obs;

  RxBool viewFull = false.obs;

  final refreshController = RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    loadData();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 200));
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    super.onInit();
    input;
    if (input.id != null) {
      loadData();
    } else {
      Get.back();
    }
  }

  void loadData() {
    List<CourseLevel> courseLevels = [];
    List<Vocabulary> courseVocabularies = [];

    _downloadCourseWithIdUsecase.execute(
      observer: Observer(
        onSubscribe: () {
          isLoading.value = true;
        },
        onSuccess: (response) async {
          isFollow.value = response.isFollow ?? false;
          course.value = CourseModel.fromMap(response.course);
          courseLevels = (response.courseLevels ?? []).map(
            (level) {
              return CourseLevel.fromMap(level);
            },
          ).toList();

          courseVocabularies = (response.courseVocabularies ?? []).map(
            (vocabulary) {
              return Vocabulary.fromMap(vocabulary);
            },
          ).toList();
          for (var level in courseLevels) {
            level.vocabularies = courseVocabularies.where((vocabulary) => vocabulary.levelId == level.id).toList();
          }

          listCourseLevelData = courseLevels;

          if (course.value.password != null) {
            if ((course.value.password ?? '').isNotEmpty) {
              isPrivateCourse = true;
            }
          }
          isLoading.value = false;
          mappingData(null);
          refreshController.refreshCompleted();
        },
        onError: (e) {
          if (e is DioError) {
            BaseHelper.tokenError(e);
            if (e.response?.data != null) {
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
        },
      ),
      input: '${input.id}',
    );

    _getAllFollowUsecase.execute(
      observer: Observer(
        onSubscribe: () {
          isLoading.value = true;
        },
        onSuccess: (response) async {
          setRankAndRate(response);
        },
        onError: (e) {
          if (e is DioError) {
            BaseHelper.tokenError(e);
            if (e.response?.data != null) {
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
        },
      ),
      input: '${input.id}',
    );
  }

  void setRankAndRate(List<Follow> listFollow) {
    if (listFollow.isEmpty) {
      return;
    }
    listFollow.sort((a, b) => b.rating.compareTo(a.rating));
    listRate.value = listFollow.where((element) => element.rating != 0).toList();
    listRate.refresh();
    var total = 0;
    for (var follow in listRate) {
      total = total + follow.rating;
    }
    if (listRate.isEmpty) {
      rate.value = 0;
    } else {
      rate.value = total / listRate.length;
    }

    listFollow.sort((a, b) => b.point.compareTo(a.point));
    listRank.value = listFollow
        .map(
          (e) => Rank(
            point: e.point,
            username: e.userName,
            dificult: e.difficultWords,
            learned: e.learnedWords,
          ),
        )
        .toList();
    listRank.refresh();
  }

  void onSearch(String key) {
    if (key.isEmpty) {
      treeController.collapseAll();
    } else {
      treeController.expandAll();
    }
    mappingData(key);
    scrolltoBottom();
  }

  void scrolltoBottom() {
    Future.delayed(const Duration(milliseconds: 150)).then(
      (value) => {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
      },
    );
  }

  mappingData(String? searchText) {
    List<CourseLevel> filterData = [];
    if (searchText == null || searchText.isEmpty) {
      listCourseLevelView.value = listCourseLevelData;
      return;
    }

    for (var courseLevel in listCourseLevelData) {
      CourseLevel newCourseLevel = CourseLevel.copy(courseLevel);

      if (courseLevel.vocabularies != null) {
        newCourseLevel.vocabularies = courseLevel.vocabularies!
            .where((element) =>
                element.englishText.toLowerCase().contains((searchText).toLowerCase()) ||
                element.vietnameseText.toLowerCase().contains((searchText).toLowerCase()))
            .toList();
      }
      if (newCourseLevel.vocabularies != null) {
        if (newCourseLevel.vocabularies!.isNotEmpty) {
          filterData.add(newCourseLevel);
        }
      }
    }

    listCourseLevelView.value = filterData;
  }

  void _showToastMessage(String message, {Function()? onCompleted}) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      title: "ERROR",
      desc: message,
      descTextStyle: AppTextStyle.w600s17(ColorName.black000),
      btnOkText: 'Okay',
      btnOkOnPress: () {},
      onDismissCallback: (_) {
        if (onCompleted != null) {
          onCompleted.call();
        }
      },
    ).show();
  }

  void joinCourse() {
    _followCourseUsecase.execute(
      observer: Observer(
        onSubscribe: () {
          isLoading.value = true;
        },
        onSuccess: (response) async {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.success,
            title: "Hoàn thành",
            desc: 'Tham gia khóa học thành công',
            descTextStyle: AppTextStyle.w600s17(ColorName.black000),
            btnOkText: 'Okay',
            btnOkOnPress: () {},
            onDismissCallback: (_) {
              loadData();
              Get.find<CourseController>().onRefresh();
              isLoading.value = false;
            },
          ).show();
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
        },
      ),
      input: FollowCourseRequest(course.value.id, ''),
    );
  }

  int sumtotalVocabulary() {
    int count = 0;
    for (var level in listCourseLevelData) {
      for (var _ in level.vocabularies ?? []) {
        count += 1;
      }
    }

    return count;
  }

  void downloadCourse() async {
    int count = 0;
    isLoading.value = true;
    _createCourseLocalUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          for (var level in listCourseLevelData) {
            _createCourseLevelLocalUsecase.execute(
              observer: Observer(
                onSuccess: (val) {
                  for (var vcabulary in level.vocabularies ?? <Vocabulary>[]) {
                    _createVocabulariesLocalUsecase.execute(
                      observer: Observer(
                        onSuccess: (val) {
                          count += 1;
                          if (count == sumtotalVocabulary()) {
                            isLoading.value = false;
                            if (Get.isRegistered<CourseController>()) {
                              Get.find<CourseController>().onRefresh();
                            }
                            Get.find<HomeController>().onRefresh();
                            Get.back();
                            AwesomeDialog(
                              context: Get.context!,
                              dialogType: DialogType.success,
                              title: "Hoàn thành",
                              desc: 'Tải xuống khóa học thành công bắt đầu học thôi nào',
                              descTextStyle: AppTextStyle.w600s17(ColorName.black000),
                              btnOkText: 'Okay',
                              btnOkOnPress: () {},
                              onDismissCallback: (_) {
                                Get.back();
                              },
                            ).show();
                          }
                        },
                        onError: (e) {
                          isLoading.value = false;
                          _showToastMessage('Tải xuống khóa học thất bại');
                          return;
                        },
                      ),
                      input: [
                        VocabularyLocal(
                          id: vcabulary.id,
                          englishText: vcabulary.englishText,
                          vietnameseText: vcabulary.vietnameseText,
                          image: vcabulary.image,
                          progress: vcabulary.progress,
                          difficult: vcabulary.difficult,
                          courseId: vcabulary.courseId,
                          levelId: vcabulary.levelId,
                          wordType: vcabulary.wordType,
                          lastTimeLearning: '0',
                        ),
                      ],
                    );
                  }
                },
                onError: (e) {
                  isLoading.value = false;
                  _showToastMessage('Tải xuống khóa học thất bại');
                  return;
                },
              ),
              input: CourseLevelLocal(
                id: level.id,
                level: level.level,
                title: level.title,
                learnedWords: level.learnedWords,
                totalWords: level.totalWords,
                courseId: level.courseId,
              ),
            );
          }
        },
        onError: (e) {
          isLoading.value = false;
          _showToastMessage('Tải xuống khóa học thất bại');
          return;
        },
      ),
      input: CourseLocal(
        id: course.value.id ?? 0,
        publicId: int.parse(course.value.publicId ?? '0'),
        title: course.value.title ?? '',
        image: course.value.image ?? '',
        learnedWords: 0,
        totalWords: course.value.totalWords ?? 0,
        progress: course.value.progress ?? 0,
        member: course.value.member ?? 0,
        point: 0,
      ),
    );
  }

  RxString currentRate = '5. Rất hài lòng'.obs;
  void rateCourse() {
    String comment = commentTextEditingController.text.trim();
    int currentRateNumber = int.parse(currentRate.replaceAll(RegExp(r'[^0-9]'), ''));
    if (comment.isEmpty) {
      comment = currentRate.value;
    }

    Get.back();
    isLoading.value = true;
    _rateCourseUsecase.execute(
      observer: Observer(
        onSuccess: (val) {
          loadData();
        },
        onError: (e) {
          isLoading.value = false;
          print(e);
          _showToastMessage('Đánh giá thất bại\nTham gia khóa học mới có thể đánh giá');
          return;
        },
      ),
      input: RateCourseRequest(course.value.id, currentRateNumber, comment),
    );
  }
}
