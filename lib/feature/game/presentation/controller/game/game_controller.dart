import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/domain/usecases/get_all_vocabulary_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/get_vocabulary_from_url_request.dart';
import 'package:easy_english/feature/course/domain/usecases/get_image_with_key_usecase.dart';
import 'package:easy_english/feature/course/domain/usecases/get_vocabularies_from_url_usecase.dart';
import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class GameController extends BaseController {
  final GetAllVocabularyUsecase _allVocabularyUsecase;
  final StorageService _storageService;

  RxList<Vocabulary> vocabularies = RxList.empty();
  RxList<Vocabulary> vocabulariesSearch = RxList.empty();
  List<String> allEnglishWord = [];

  RxBool isLoading = false.obs;

  TextEditingController searchTextController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  final GetImageWithKeyUsecase _getImageWithKeyUsecase;
  final GetVocabulariesFromUrlUsecase _getVocabulariesFromUrlUsecase;

  GameController(
    this._allVocabularyUsecase,
    this._storageService,
    this._getImageWithKeyUsecase,
    this._getVocabulariesFromUrlUsecase,
  );

  @override
  void onInit() {
    super.onInit();
    loadWords();
    loadMyWord();
    _storageService.getMyBestScore().then((value) => AppConfig.bestScore.value = value);
  }

  void loadWords() {
    DefaultAssetBundle.of(Get.context!).loadString('assets/words_alpha.txt').then(
      (value) {
        allEnglishWord = value.toUpperCase().split('\n').toSet().toList();
      },
    );
  }

  void loadMyWord() {
    isLoading.value = true;
    _allVocabularyUsecase.execute(
      observer: Observer(
        onSuccess: (val) async {
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
                  vocabulary.wordType ?? '',
                  vocabulary.lastTimeLearning ?? '',
                ),
              )
              .toList();
          isLoading.value = false;
        },
        onError: (e) {
          print(e);
        },
      ),
    );
    loadSearchWord();
  }

  void loadSearchWord() {
    _storageService.getMyWord().then((value) async {
      List<Vocabulary> responseVocabulary = [];
      vocabulariesSearch.value = [];
      print("================================================================");
      print(value);
      print("================================================================");

      if (value.isNotEmpty) {
        for (var vocabulary in value) {
          responseVocabulary.add(Vocabulary.fromMap(jsonDecode(vocabulary)));
        }
        vocabulariesSearch.value = responseVocabulary;
        vocabulariesSearch.refresh();
      }
    });
  }

  RxBool isSearching = false.obs;
  RxList<String> searchResult = RxList.empty();

  void onSearchVocabulary(String key) {
    if (key.trim().isEmpty) {
      searchResult.value = [];
      searchResult.refresh();
      return;
    } else {
      searchResult.value =
          allEnglishWord.where((element) => element.toUpperCase().contains(key.toUpperCase())).toList();

      searchResult.sort((a, b) => a.length.compareTo(b.length));
      searchResult.refresh();
    }
  }

  void playVideoGame() {
    if (vocabularies.isNotEmpty) {
      N.toGamePlay(vocabularies: vocabularies);
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: "Không thể bắt đầu trò chơi",
        desc:
            "Tối thiểu phải có ít nhất 10 từ vựng để bắt đầu trò chơi\nTìm kiếm hoặc tham gia các khóa học để thu thập từ vựng và trở lại sau",
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {},
      ).show();
    }
  }

  RxString wordType = 'Noun'.obs;
  final englishTextEditingController = TextEditingController();
  final vietnameseTextEditingController = TextEditingController();
  final imageVocabularyTextEditingController = TextEditingController();
  RxBool isSheetLoading = false.obs;

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

  void getVocabulary(String word) {
    hideKeyboard();

    isSheetLoading.value = true;
    _getVocabulariesFromUrlUsecase.execute(
      observer: Observer(
        onSuccess: (vocabularies) {
          isSheetLoading.value = false;
          List<Vocabulary> listVocabulary = [];
          for (var item in vocabularies.words ?? []) {
            listVocabulary.add(
              Vocabulary(
                0,
                item[0],
                item[3],
                item[2],
                0,
                0,
                0,
                0,
                BaseHelper.mapWordType(item[1]),
                '0',
              ),
            );
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
          englishTextEditingController.text = listVocabulary.first.englishText;
          vietnameseTextEditingController.text = listVocabulary.first.vietnameseText;
          imageVocabularyTextEditingController.text = listVocabulary.first.image;
          wordType.value = listVocabulary.first.wordType;
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
        word,
        word,
        1,
        true,
      ),
    );
  }

  void setImageVocabulary(String url) {
    imageVocabularyTextEditingController.text = url;
  }

  void addVocabulary() {
    hideKeyboard();

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
      0,
      englishTextEditingController.text.trim(),
      vietnameseTextEditingController.text.trim(),
      imageVocabularyTextEditingController.text.trim(),
      0,
      0,
      0,
      0,
      wordType.value,
      '0',
    );

    if (!isDuplicate(
      newVocabulary.englishText,
      newVocabulary.vietnameseText,
      newVocabulary.image,
      vocabulariesSearch,
    )) {
      vocabulariesSearch.add(newVocabulary);
    }

    List<String> words = [];

    for (var vocabulary in vocabulariesSearch) {
      words.add(vocabulary.toJsonLocal().toString());
    }
    _storageService.setMyWord(words).then((value) {
      Get.back();
      loadSearchWord();
    });
  }

  bool isDuplicate(String english, String vietnam, String image, List<Vocabulary> listVocabulary) {
    for (var vocabulary in listVocabulary) {
      if (vocabulary.englishText == english && vocabulary.vietnameseText == vietnam && vocabulary.image == image) {
        return true;
      }
    }
    return false;
  }

  void removeWord() {
    _storageService.removeMyWord().then((value) => loadSearchWord());
  }
}
