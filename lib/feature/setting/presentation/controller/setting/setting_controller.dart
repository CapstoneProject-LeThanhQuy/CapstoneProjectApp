import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:get/get.dart';

class SettingController extends BaseController {
  final StorageService _storageService;
  SettingController(this._storageService);

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
}
