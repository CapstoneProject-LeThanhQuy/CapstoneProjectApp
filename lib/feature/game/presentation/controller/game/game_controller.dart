import 'package:easy_english/base/domain/usecases/get_all_vocabulary_usecase.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
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

  GameController(
    this._allVocabularyUsecase,
    this._storageService,
  );

  @override
  void onInit() {
    super.onInit();
    loadWords();
    loadMyWord();
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

      searchResult.refresh();
    }
  }

  void onShowVocabulary(String key) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) => _searchWordWidget(),
    );
  }

  Widget _searchWordWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      child: Text('hi'),
    );
  }

  void playVideoGame() {
    N.toGamePlay(vocabularies: []);
  }
}
