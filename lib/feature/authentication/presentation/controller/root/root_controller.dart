import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/authentication/domain/usecases/get_account_info.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../../../../utils/config/app_navigation.dart';

class RootController extends BaseController {
  final StorageService _storageService;
  final GetAccountInfoUsecase _getCustomeInfoUsecase;

  RootController(
    this._storageService,
    this._getCustomeInfoUsecase,
  );

  int countTryAgain = 0;

  @override
  void onInit() {
    super.onInit();
    LocalStorage();
    Future.delayed(const Duration(seconds: 1)).whenComplete(() async {
      FlutterNativeSplash.remove();
    });
    appStart();
  }

  void appStart() {
    if (countTryAgain == 10) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: 'ERROR',
        desc: 'Không thể kết nối tới máy chủ',
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {
          if (AppConfig.tokenInfo.accessToken != null) {
            N.toTabBar();
          } else {
            N.toLandingPage();
          }
        },
      ).show();

      return;
    }
    countTryAgain += 1;
    _storageService.getToken().then((value) async {
      TokenModel token = TokenModel();

      if (value.isNotEmpty) {
        token = TokenModel.fromJson(jsonDecode(value));
        if (kDebugMode) {
          print(token.toJson());
        }
        AppConfig.tokenInfo = token;
        _getCustomeInfoUsecase.execute(
          observer: Observer(
            onSuccess: (account) async {
              AppConfig.accountInfo = account;
              if (kDebugMode) {
                print(account.toJson());
              }
              N.toTabBar();
            },
            onError: (err) async {
              if (err is DioError) {
                if (kDebugMode) {
                  print(err.response!.data['message'].toString());
                  print(err);
                }
                if (err.response!.statusCode == 401) {
                  AwesomeDialog(
                    context: Get.context!,
                    dialogType: DialogType.error,
                    title: "Không thể xác thực",
                    desc: "Phiên đăng nhập của bạn đã hết hạn, đăng nhập lại để tiếp tục sử dụng",
                    descTextStyle: AppTextStyle.w600s17(ColorName.black000),
                    btnOkText: 'Okay',
                    btnOkOnPress: () {},
                    onDismissCallback: (_) {
                      _storageService.removeToken();
                      AppConfig.accountInfo = AccountModel();
                      N.toLandingPage();
                      N.toLoginPage();
                    },
                  ).show();
                } else {
                  appStart();
                }
              } else {
                appStart();
              }
            },
          ),
        );
      } else {
        N.toLandingPage();
      }
    });
  }
}
