import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/home/data/models/target.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SettingController extends BaseController {
  final StorageService _storageService;

  final refreshController = RefreshController(initialRefresh: false);
  Rx<AccountModel> accountInfo = Rx<AccountModel>(AccountModel());
  var isLoading = false.obs;

  SettingController(this._storageService);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    accountInfo.value = AppConfig.accountInfo;
    accountInfo.refresh();
    refreshController.refreshCompleted();
  }

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    loadData();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 200));
    refreshController.loadComplete();
  }

  void logoutEasyEnglish() {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.question,
      title: 'Đăng xuất',
      desc: 'Bạn chắc chắn muốn đăng xuất khỏi \nEasy English?',
      descTextStyle: AppTextStyle.w600s17(ColorName.black000),
      btnOkText: 'Đăng xuất',
      btnCancelText: 'Huỷ',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _storageService.removeToken();
        AppConfig.accountInfo = AccountModel();
        AppConfig.tokenInfo = TokenModel();
        N.toLandingPage();
      },
      onDismissCallback: (_) {},
    ).show();
  }

  RxBool isSheetLoading = false.obs;
  RxString gender = 'Nam'.obs;
  List<String> listGenerator = ['Nam', 'Nữ'];

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  void updateProfile() async {
    isSheetLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSheetLoading.value = false;
    AppConfig.accountInfo.username = nameTextEditingController.text;
    AppConfig.accountInfo.gender = gender.value == 'Nam' ? true : false;
    loadData();
  }

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

  void updateTarget(int numberTarget) {
    Get.find<HomeController>().updateTarget(numberTarget);
    target.value.targetWord = numberTarget;
  }
}
