import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/domain/usecases/update_course_local_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_vocabulary_from_url_request.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/update_course_request.dart';
import 'package:easy_english/feature/course/domain/usecases/download_course_with_id_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_image_with_key_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_vocabularies_from_url_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/update_course_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/simpletreeview/lib/flutter_simple_treeview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateVocabularyController extends BaseController<CourseModel> {
  GetImageWithKeyUsecase _getImageWithKeyUsecase;
  GetVocabulariesFromUrlUsecase _getVocabulariesFromUrlUsecase;
  UpdateCourseUsecase _updateCourseUsecase;
  DownloadCourseWithIdUsecase _downloadCourseWithIdUsecase;

  CreateVocabularyController(
    this._getImageWithKeyUsecase,
    this._getVocabulariesFromUrlUsecase,
    this._updateCourseUsecase,
    this._downloadCourseWithIdUsecase,
  );

  CourseModel? course;
  final ignoringPointer = false.obs;
  final isShowPassword = true.obs;

  final titleTextEditingController = TextEditingController();
  final memoTextEditingController = TextEditingController();
  final imageTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isSheetLoading = false.obs;

  final formKey = GlobalKey<FormBuilderState>();
  final saveState = BaseState();

  RxBool isSearching = false.obs;

  ScrollController scrollController = ScrollController();

  String get _title => titleTextEditingController.text;
  String get _memo => memoTextEditingController.text;
  String get _password => passwordTextEditingController.text;

  final RxList<String> listProgress = <String>[
    '5',
    '10',
    '20',
    '30',
    '50',
    '100',
  ].obs;
  Rx<String> progress = '10'.obs;

  RxBool isPrivate = false.obs;

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    course = input;
    if (course != null) {
      loadData();
    } else {
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

  void loadData() {
    List<CourseLevel> courseLevels = [];
    List<Vocabulary> courseVocabularies = [];
    if (course?.id != null) {
      _downloadCourseWithIdUsecase.execute(
        observer: Observer(
          onSubscribe: () {
            isLoading.value = true;
            ignoringPointer.value = true;
          },
          onSuccess: (response) async {
            course = CourseModel.fromMap(response.course);
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
            listCourseLevelDataInitial = courseLevels;

            titleTextEditingController.text = course?.title ?? '';
            memoTextEditingController.text = course?.description ?? '';
            imageTextEditingController.text = course?.image ?? '';

            if (course?.password != null) {
              if (course!.password!.isNotEmpty) {
                isPrivate.value = true;
                passwordTextEditingController.text = '------';
              }
            }

            progress.value = '${course?.progress ?? 10}';

            sortListCourseLevel();
            onSearch(" ");
            onSearch("");
            ignoringPointer.value = false;
            isLoading.value = false;
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
            ignoringPointer.value = false;
            isLoading.value = false;
          },
        ),
        input: '${course?.id}',
      );
    } else {
      _showToastMessage('Truy cập máy chủ thất bại, thử lại sau giây lát');
    }
  }

  void onTapShowPassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  Rx<XFile> imageCourse = XFile('').obs;
  Future<void> pickImage(BuildContext context) async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      context: context,
      builder: ((context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorName.grayC7c,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  imageCourse.value =
                      await _picker.pickImage(source: ImageSource.camera, imageQuality: 50) ?? XFile('');
                  back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Text(
                    'Chụp ảnh',
                    style: AppTextStyle.w600s15(ColorName.black000),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorName.grayC7c,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  imageCourse.value =
                      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50) ?? XFile('');
                  back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Text(
                    'Chọn ảnh từ thư viện',
                    style: AppTextStyle.w600s15(ColorName.black000),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorName.grayC7c,
                ),
              ),
            ],
          )),
    );
  }

  final treeController = TreeController();

  List<CourseLevel> listCourseLevelDataInitial = [];

  List<CourseLevel> listCourseLevelData = [];

  RxList<CourseLevel> listCourseLevelView = RxList.empty();

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

  void onSearch(String key) {
    if (key.isEmpty) {
      treeController.collapseAll();
    } else {
      treeController.expandAll();
    }
    mappingData(key);
    scrolltoBottom();
  }

  void onSearchLevel(int id) {
    treeController.expandAll();
    if (id == -1) {
      listCourseLevelView.value = listCourseLevelData;
    } else {
      CourseLevel? courseLevel = listCourseLevelData.firstWhereOrNull((element) => element.id == id);
      listCourseLevelView.value = courseLevel != null ? [courseLevel] : [];
      scrolltoBottom();
    }
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

  final titleCourseLevelTextEditingController = TextEditingController();
  List<String> listCourseLevelDifficult = [];
  RxString difflcultLevel = ''.obs;
  RxString defaultDifflcultLevel = ''.obs;

  void genListCourseLevelDifficult(bool isAddCourse, {CourseLevel? courseLevel}) {
    if (listCourseLevelData.isEmpty) {
      defaultDifflcultLevel.value = "Level 1";
      difflcultLevel.value = "Level 1";
      listCourseLevelDifficult = ["Level 1"];
      return;
    }
    if (isAddCourse) {
      defaultDifflcultLevel.value = "Level ${listCourseLevelData.last.level + 1}";
      difflcultLevel.value = "Level ${listCourseLevelData.last.level + 1}";
    } else {
      defaultDifflcultLevel.value = "Level ${courseLevel?.level ?? 0}";
      difflcultLevel.value = "Level ${courseLevel?.level ?? 0}";
    }

    listCourseLevelDifficult = [];
    int count = listCourseLevelData.first.level;
    for (var element in listCourseLevelData) {
      if (count != element.level - 1) {
        listCourseLevelDifficult.add('Level ${element.level}');
        count = element.level - 1;
      }
      listCourseLevelDifficult.add('Level ${element.level}\n[${element.title}]');
    }
    listCourseLevelDifficult.add('Level ${count + 2}');
  }

  void addCourseLevel() {
    try {
      hideKeyboard();
      if (titleCourseLevelTextEditingController.text.trim().isEmpty ||
          titleCourseLevelTextEditingController.text.trim().length > 80) {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          title: 'WARNING',
          desc: 'Không được bỏ trống hoặc nhập quá 80 tiêu đề',
          descTextStyle: AppTextStyle.w600s17(ColorName.black000),
          btnOkText: 'Okay',
          btnOkOnPress: () {},
          onDismissCallback: (_) {},
        ).show();
        return;
      }

      int level = int.parse(difflcultLevel.replaceAll(RegExp(r'[^0-9]'), ''));

      CourseLevel newCourseLevel = CourseLevel(
        maxID(),
        level,
        titleCourseLevelTextEditingController.text.trim(),
        course?.id ?? -1,
        0,
        0,
        typeUpdate: TypeUpdate.isNew,
      );

      listCourseLevelData.add(newCourseLevel);
      sortListCourseLevel();
      onSearch(' ');
      onSearch('');
      Get.back();
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: 'ERROR',
        desc: 'Tạo mới thất bại',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {
          Get.back();
        },
      ).show();
      return;
    }
  }

  Color genColorTree(TypeUpdate? updateType) {
    switch (updateType) {
      case TypeUpdate.isNew:
        return ColorName.blue007.withOpacity(0.2);
      case TypeUpdate.isUpdate:
        return ColorName.green27b.withOpacity(0.3);
      case TypeUpdate.isDelete:
        return ColorName.redEb5.withOpacity(0.4);
      default:
        return ColorName.grayD9d.withOpacity(0.6);
    }
  }

  void deleteCourseLevel(CourseLevel courseLevel) {
    if (courseLevel.typeUpdate == TypeUpdate.isNew) {
      listCourseLevelData.remove(courseLevel);
      onSearch(' ');
      onSearch('');

      return;
    }
    listCourseLevelData = listCourseLevelData.map(
      (level) {
        if (level.id == courseLevel.id) {
          level.typeUpdate = TypeUpdate.isDelete;
          List<Vocabulary> vocabularies = [];
          for (var vocabulary in courseLevel.vocabularies ?? <Vocabulary>[]) {
            if (vocabulary.typeUpdate != TypeUpdate.isNew) {
              vocabulary.typeUpdate = TypeUpdate.isDelete;
              vocabularies.add(vocabulary);
            }
          }
          level.vocabularies = vocabularies;
        }
        return level;
      },
    ).toList();

    mappingData(null);
  }

  void rollBackCourseLevel(CourseLevel courseLevel) {
    CourseLevel initCourseLevel = listCourseLevelDataInitial.firstWhere((level) => level.id == courseLevel.id);
    listCourseLevelData = listCourseLevelData.map(
      (level) {
        if (level.id == courseLevel.id) {
          level = CourseLevel.copy(initCourseLevel);
          level.vocabularies = [];
          level.vocabularies = List<Vocabulary>.from(initCourseLevel.vocabularies ?? []);
          level.totalWords = initCourseLevel.totalWords;
          level.typeUpdate = null;

          for (var vocabulary in courseLevel.vocabularies ?? <Vocabulary>[]) {
            vocabulary.typeUpdate = null;
          }
        }
        return level;
      },
    ).toList();
    sortListCourseLevel();
    mappingData(null);
  }

  void updateCourseLevel(CourseLevel? courseLevel) {
    try {
      hideKeyboard();
      if (titleCourseLevelTextEditingController.text.trim().isEmpty ||
          titleCourseLevelTextEditingController.text.trim().length > 80) {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          title: 'WARNING',
          desc: 'Không được bỏ trống hoặc nhập quá 80 tiêu đề',
          descTextStyle: AppTextStyle.w600s17(ColorName.black000),
          btnOkText: 'Okay',
          btnOkOnPress: () {},
          onDismissCallback: (_) {},
        ).show();
        return;
      }

      int level = int.parse(difflcultLevel.replaceAll(RegExp(r'[^0-9]'), ''));
      CourseLevel newCourseLevel = CourseLevel(
        courseLevel?.id ?? -1,
        level,
        titleCourseLevelTextEditingController.text.trim(),
        courseLevel?.courseId ?? -1,
        courseLevel?.totalWords ?? 0,
        courseLevel?.learnedWords ?? 0,
        typeUpdate: TypeUpdate.isNew,
        vocabularies: courseLevel?.vocabularies,
      );

      CourseLevel? initCourseLevel =
          listCourseLevelDataInitial.firstWhereOrNull((level) => level.id == newCourseLevel.id);

      listCourseLevelData = listCourseLevelData.map(
        (level) {
          if (level.id == courseLevel?.id) {
            if (level.typeUpdate != TypeUpdate.isNew) {
              newCourseLevel.typeUpdate = TypeUpdate.isUpdate;
            }
            if (initCourseLevel != null) {
              if (initCourseLevel.level == newCourseLevel.level &&
                  initCourseLevel.title.trim() == newCourseLevel.title.trim()) {
                newCourseLevel.typeUpdate = initCourseLevel.typeUpdate;
              }
            }
            return newCourseLevel;
          }
          return level;
        },
      ).toList();
      sortListCourseLevel();
      mappingData(null);
      Get.back();
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: 'ERROR',
        desc: 'Chỉnh sửa thất bại',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {
          Get.back();
        },
      ).show();
      return;
    }
  }

  void sortListCourseLevel() {
    listCourseLevelData.sort(
      (levelLeft, levelRight) => levelLeft.level.compareTo(levelRight.level) == 0
          ? levelLeft.id.compareTo(levelRight.id)
          : levelLeft.level.compareTo(levelRight.level),
    );
  }

  int maxID() {
    int maxID = 0;
    for (var courseLevel in listCourseLevelData) {
      if (maxID < courseLevel.id) {
        maxID = courseLevel.id;
      }
    }

    return maxID + 1;
  }

  final englishTextEditingController = TextEditingController();
  final vietnameseTextEditingController = TextEditingController();
  final imageVocabularyTextEditingController = TextEditingController();
  final urlOrDocVocabularyTextEditingController = TextEditingController();

  RxBool isAutoCreate = false.obs;

  void addVocabulary(CourseLevel? courseLevel) {
    hideKeyboard();
    if (isAutoCreate.value) {
      if (courseLevel == null) {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          title: 'WARNING',
          desc: 'Không được bỏ trống các mục',
          descTextStyle: AppTextStyle.w600s17(ColorName.black000),
          btnOkText: 'Okay',
          btnOkOnPress: () {},
          onDismissCallback: (_) {},
        ).show();
        return;
      }
      genVocabularies(courseLevel);
    } else {
      if (englishTextEditingController.text.trim().isEmpty ||
          vietnameseTextEditingController.text.trim().isEmpty ||
          imageVocabularyTextEditingController.text.trim().isEmpty) {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          title: 'WARNING',
          desc: 'Không được bỏ trống các mục',
          descTextStyle: AppTextStyle.w600s17(ColorName.black000),
          btnOkText: 'Okay',
          btnOkOnPress: () {},
          onDismissCallback: (_) {},
        ).show();
        return;
      }

      Vocabulary newVocabulary = Vocabulary(
        maxVocabularyID(),
        englishTextEditingController.text.trim(),
        vietnameseTextEditingController.text.trim(),
        imageVocabularyTextEditingController.text.trim(),
        0,
        0,
        courseLevel?.courseId ?? 0,
        courseLevel?.id ?? 0,
        wordType.value,
        '0',
        typeUpdate: TypeUpdate.isNew,
      );

      listCourseLevelData = listCourseLevelData.map(
        (level) {
          if (courseLevel?.id == level.id) {
            List<Vocabulary> listVocabulary = (level.vocabularies ?? <Vocabulary>[]);
            listVocabulary.add(newVocabulary);
            level.vocabularies = listVocabulary;

            level.totalWords = countTotalWordCourseLevel(level);
            if (level.typeUpdate != TypeUpdate.isNew) {
              level.typeUpdate = TypeUpdate.isUpdate;
            }
          }
          return level;
        },
      ).toList();
      onSearch(newVocabulary.englishText);
      Get.back();
    }
  }

  int maxVocabularyID() {
    int maxID = 0;
    for (var courseLevel in listCourseLevelData) {
      for (var vocabulary in courseLevel.vocabularies ?? []) {
        if (maxID < vocabulary.id) {
          maxID = vocabulary.id;
        }
      }
    }
    return maxID + 1;
  }

  void updateVocabulary(CourseLevel? courseLevel, Vocabulary? vocabulary) {
    if (englishTextEditingController.text.trim().isEmpty ||
        vietnameseTextEditingController.text.trim().isEmpty ||
        imageVocabularyTextEditingController.text.trim().isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'WARNING',
        desc: 'Không được bỏ trống các mục',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {},
      ).show();
      return;
    }

    Vocabulary newVocabulary = Vocabulary(
      vocabulary?.id ?? 0,
      englishTextEditingController.text.trim(),
      vietnameseTextEditingController.text.trim(),
      imageVocabularyTextEditingController.text.trim(),
      0,
      0,
      vocabulary?.courseId ?? 0,
      vocabulary?.levelId ?? 0,
      wordType.value,
      '0',
      typeUpdate: vocabulary?.typeUpdate == TypeUpdate.isNew ? TypeUpdate.isNew : TypeUpdate.isUpdate,
    );
    Vocabulary? initVocabulary = (listCourseLevelDataInitial
                .firstWhereOrNull(
                  (level) => level.id == courseLevel?.id,
                )
                ?.vocabularies ??
            [])
        .firstWhereOrNull(
      (element) => element.id == vocabulary?.id,
    );
    if (initVocabulary != null) {
      if (initVocabulary.englishText == newVocabulary.englishText &&
          initVocabulary.vietnameseText == newVocabulary.vietnameseText &&
          initVocabulary.image == newVocabulary.image &&
          initVocabulary.wordType == newVocabulary.wordType) {
        newVocabulary = initVocabulary;
      }
    }

    listCourseLevelData = listCourseLevelData.map(
      (level) {
        if (courseLevel?.id == level.id) {
          level.vocabularies = level.vocabularies?.map((item) {
            if (item.id == vocabulary?.id) {
              item = newVocabulary;
            }
            return item;
          }).toList();
        }
        return level;
      },
    ).toList();
    mappingData(null);
    Get.back();
  }

  void deleteVocabulary(CourseLevel courseLevel, Vocabulary vocabulary) {
    CourseLevel initCourseLevel = listCourseLevelDataInitial.firstWhere((level) => level.id == courseLevel.id);
    if (vocabulary.typeUpdate == TypeUpdate.isNew) {
      listCourseLevelData = listCourseLevelData.map(
        (level) {
          if (courseLevel.id == level.id) {
            level.vocabularies?.remove(vocabulary);
            level.totalWords = countTotalWordCourseLevel(level);
            if (level.typeUpdate != TypeUpdate.isNew) {
              level.typeUpdate = TypeUpdate.isUpdate;
            }
            if (initCourseLevel.level == level.level &&
                level.totalWords == initCourseLevel.totalWords &&
                level.title == initCourseLevel.title) {
              level.typeUpdate = initCourseLevel.typeUpdate;
            }
          }
          return level;
        },
      ).toList();
      onSearchLevel(courseLevel.id);
      scrolltoBottom();
      return;
    }

    listCourseLevelData = listCourseLevelData.map(
      (level) {
        if (level.id == courseLevel.id) {
          level.vocabularies = level.vocabularies?.map(
            (item) {
              if (item.id == vocabulary.id) {
                item.typeUpdate = TypeUpdate.isDelete;
              }
              return item;
            },
          ).toList();
          level.totalWords = countTotalWordCourseLevel(level);
          level.typeUpdate = TypeUpdate.isUpdate;
        }
        return level;
      },
    ).toList();

    mappingData(null);
  }

  void rollBackVocabulary(CourseLevel courseLevel, Vocabulary vocabulary) {
    CourseLevel initCourseLevel = listCourseLevelDataInitial.firstWhere(
      (level) => level.id == courseLevel.id,
    );
    Vocabulary initVocabulary = initCourseLevel.vocabularies!.firstWhere(
      (element) => element.id == vocabulary.id,
    );
    listCourseLevelData = listCourseLevelData.map(
      (level) {
        if (level.id == courseLevel.id) {
          level.vocabularies = level.vocabularies?.map(
            (item) {
              if (item.id == vocabulary.id) {
                item = initVocabulary;
                item.typeUpdate = null;
              }
              return item;
            },
          ).toList();
          level.totalWords = countTotalWordCourseLevel(level);
          if (level.title == initCourseLevel.title &&
              level.level == initCourseLevel.level &&
              level.totalWords == initCourseLevel.totalWords) {
            level.typeUpdate = null;
          }
        }
        return level;
      },
    ).toList();
    sortListCourseLevel();
    mappingData(null);
  }

  void previewImage(ImagePreviewitem previewImageItem) {
    hideKeyboard();
    N.toPreviewImage(previewImageItem: previewImageItem);
  }

  void findImage() {
    hideKeyboard();
    String key = '';

    if (englishTextEditingController.text.trim().isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'WARNING',
        desc: 'Bạn cần nhập vào từ vựng để tìm kiếm',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {},
      ).show();
      return;
    }

    key = englishTextEditingController.text.trim();

    print(key);

    isSheetLoading.value = true;
    _getImageWithKeyUsecase.execute(
      observer: Observer(
        onSuccess: (ulrs) {
          for (var element in ulrs) {
            print(element.trim());
          }
          isSheetLoading.value = false;
          N.toPreviewImage(previewImageItem: ImagePreviewitem(urls: ulrs));
        },
        onError: (e) {
          if (e is DioError) {
            BaseHelper.tokenError(e);
          }
          print(e);
          isSheetLoading.value = false;
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.error,
            title: 'ERROR',
            desc: 'Không thể tìm kiếm hình ảnh',
            descTextStyle: AppTextStyle.w600s17(ColorName.black000),
            btnOkText: 'Okay',
            btnOkOnPress: () {},
            onDismissCallback: (_) {},
          ).show();
        },
      ),
      input: key,
    );
  }

  void setImageVocabulary(String url) {
    imageVocabularyTextEditingController.text = url;
  }

  RxString wordType = 'Noun'.obs;

  RxString maxWord = '5'.obs;

  RxBool isExactSearch = false.obs;

  bool checkDuplicate(int courseId, String englishText) {
    return (listCourseLevelData
                    .firstWhereOrNull(
                      (level) => level.id == courseId,
                    )
                    ?.vocabularies ??
                [])
            .firstWhereOrNull(
          (element) => element.englishText == englishText,
        ) ==
        null;
  }

  void genVocabularies(CourseLevel courseLevel) {
    String keyWord = urlOrDocVocabularyTextEditingController.text.trim();
    if (keyWord.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'WARNING',
        desc: 'Bạn cần nhập vào đường dẫn hoặc đoạn văn để tìm kiếm',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {},
      ).show();
      return;
    }

    bool isValidURL = Uri.parse(keyWord).isAbsolute;

    isSheetLoading.value = true;
    int maxId = maxVocabularyID();
    _getVocabulariesFromUrlUsecase.execute(
      observer: Observer(
        onSuccess: (vocabularies) {
          isSheetLoading.value = false;
          List<Vocabulary> listVocabulary = [];
          for (var item in vocabularies.words ?? []) {
            if (checkDuplicate(courseLevel.courseId, item[0])) {
              listVocabulary.add(
                Vocabulary(
                  maxId,
                  item[0],
                  item[3],
                  item[2],
                  0,
                  0,
                  courseLevel.courseId,
                  courseLevel.id,
                  BaseHelper.mapWordType(item[1]),
                  '0',
                  typeUpdate: TypeUpdate.isNew,
                ),
              );
              maxId += 1;
            }
          }
          if (listVocabulary.isEmpty) {
            AwesomeDialog(
              context: Get.context!,
              dialogType: DialogType.info,
              title: 'Thông báo',
              desc: 'Không tìm thấy từ vựng nào',
              descTextStyle: AppTextStyle.w600s17(ColorName.black000),
              btnOkText: 'Okay',
              btnOkOnPress: () {},
              onDismissCallback: (_) {},
            ).show();
            return;
          }
          listCourseLevelData = listCourseLevelData.map(
            (level) {
              if (level.id == courseLevel.id) {
                List<Vocabulary> listVocabularyClone = (level.vocabularies ?? <Vocabulary>[]);
                listVocabularyClone.addAll(listVocabulary);
                level.vocabularies = listVocabularyClone;
                level.totalWords = countTotalWordCourseLevel(level);
                if (level.typeUpdate != TypeUpdate.isNew) {
                  level.typeUpdate = TypeUpdate.isUpdate;
                }
              }
              return level;
            },
          ).toList();
          onSearchLevel(courseLevel.id);
          Get.back();
        },
        onError: (e) {
          if (e is DioError) {
            BaseHelper.tokenError(e);
          }
          print(e);
          isSheetLoading.value = false;
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.error,
            title: 'ERROR',
            desc: 'Không thể tìm kiếm từ vựng',
            descTextStyle: AppTextStyle.w600s17(ColorName.black000),
            btnOkText: 'Okay',
            btnOkOnPress: () {},
            onDismissCallback: (_) {},
          ).show();
        },
      ),
      input: GetVocabularyFromUrlRequest(
        keyWord,
        isValidURL ? "None" : keyWord,
        int.parse(maxWord.value),
        isExactSearch.value,
      ),
    );
  }

  void showWarning() {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.warning,
      title: 'Cảnh báo',
      desc: 'Quá trình tìm kiếm từ vựng có thể sẽ mất rất nhiều thời gian',
      descTextStyle: AppTextStyle.w600s17(ColorName.black000),
      btnOkText: 'Okay',
      btnOkOnPress: () {},
      onDismissCallback: (_) {},
    ).show();
  }

  void saveCourse() {
    try {
      final fbs = formKey.formBuilderState!;
      final titleField = FormFieldType.title.field(fbs);
      final memoField = FormFieldType.memo.field(fbs);
      final passwordField =
          isPrivate.value ? FormFieldType.passwordCourse.field(fbs) : FormFieldType.imageCourse.field(fbs);

      if (isPrivate.value) {
        [
          titleField,
          memoField,
          passwordField,
        ].validateFormFields();
      } else {
        [
          titleField,
          memoField,
        ].validateFormFields();
      }

      //
      List<Vocabulary> vocabulariesAdd = getListVocabularyWithTypeUpdate(TypeUpdate.isNew);
      List<Vocabulary> vocabulariesUpdate = getListVocabularyWithTypeUpdate(TypeUpdate.isUpdate);
      List<Vocabulary> vocabulariesDelete = getListVocabularyWithTypeUpdate(TypeUpdate.isDelete);

      List<CourseLevel> listCourseLevelAdd =
          listCourseLevelData.where((level) => level.typeUpdate == TypeUpdate.isNew).toList();
      List<CourseLevel> listCourseLevelUpdate =
          listCourseLevelData.where((level) => level.typeUpdate == TypeUpdate.isUpdate).toList();
      List<CourseLevel> listCourseLevelDelete =
          listCourseLevelData.where((level) => level.typeUpdate == TypeUpdate.isDelete).toList();

      course?.title = titleTextEditingController.text.trim();
      course?.image = imageTextEditingController.text.trim();
      course?.description = memoTextEditingController.text.trim();
      course?.progress = int.parse(progress.value);
      if (isPrivate.value) {
        course?.password = passwordTextEditingController.text.trim();
      } else {
        course?.password = '';
      }
      course?.totalWords = countTotalWords();

      var updateCourseRequest = UpdateCourseRequest(
        course: course,
        listCourseLevelAdd: listCourseLevelAdd,
        listCourseLevelUpdate: listCourseLevelUpdate,
        listCourseLevelDelete: listCourseLevelDelete,
        vocabulariesAdd: vocabulariesAdd,
        vocabulariesUpdate: vocabulariesUpdate,
        vocabulariesDelete: vocabulariesDelete,
      );

      _updateCourseUsecase.execute(
        observer: Observer(
          onSubscribe: () {
            isLoading.value = true;
            ignoringPointer.value = true;
          },
          onSuccess: (response) async {
            if (response) {
              AwesomeDialog(
                context: Get.context!,
                dialogType: DialogType.success,
                title: "SUCCESS",
                desc: "Cập nhật khóa học thành công",
                descTextStyle: AppTextStyle.w600s17(ColorName.black000),
                btnOkText: 'Okay',
                btnOkOnPress: () {},
                onDismissCallback: (_) {
                  loadData();
                  Get.find<CourseController>().onRefresh();
                },
              ).show();
            } else {
              _showToastMessage('Lỗi hệ thống');
            }
            ignoringPointer.value = false;
            isLoading.value = false;
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
            ignoringPointer.value = false;
            isLoading.value = false;
          },
        ),
        input: updateCourseRequest,
      );
    } catch (e) {
      print(e);
    }
  }

  List<Vocabulary> getListVocabularyWithTypeUpdate(TypeUpdate typeUpdate) {
    List<Vocabulary> result = [];
    for (var level in listCourseLevelData) {
      if (TypeUpdate.isDelete != typeUpdate || TypeUpdate.isDelete != level.typeUpdate) {
        result.addAll(level.vocabularies?.where((vocabulary) => vocabulary.typeUpdate == typeUpdate) ?? []);
      }
    }
    return result;
  }

  int countTotalWordCourseLevel(CourseLevel courseLevel) {
    return (courseLevel.vocabularies?.where((vocabulary) => vocabulary.typeUpdate != TypeUpdate.isDelete) ?? []).length;
  }

  int countTotalWords() {
    int result = 0;
    for (var level in listCourseLevelData) {
      if (TypeUpdate.isDelete != level.typeUpdate) {
        result +=
            (level.vocabularies?.where((vocabulary) => vocabulary.typeUpdate != TypeUpdate.isDelete) ?? []).length;
      }
    }
    return result;
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
}
