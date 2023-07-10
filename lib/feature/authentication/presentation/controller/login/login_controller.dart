import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/login_request.dart';
import 'package:easy_english/feature/authentication/domain/usecases/get_account_info.dart';
import 'package:easy_english/feature/authentication/domain/usecases/login_usecase.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final emailOrPhoneTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final GetAccountInfoUsecase _getCustomeInfoUsecase;
  final formKey = GlobalKey<FormBuilderState>();
  final loginState = BaseState();

  String get _phone => emailOrPhoneTextEditingController.text;
  String get _password => passwordTextEditingController.text;

  final isDisableButton = true.obs;
  final ignoringPointer = false.obs;
  final errorMessage = ''.obs;
  final isShowPassword = true.obs;

  LoginController(
    this._loginUsecase,
    this._storageService,
    this._getCustomeInfoUsecase,
  );

  final LoginUsecase _loginUsecase;
  final StorageService _storageService;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      emailOrPhoneTextEditingController.text = '0384933379';
      passwordTextEditingController.text = '123123';
    }
  }

  @override
  void onClose() {
    emailOrPhoneTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.onClose();
  }

  void onTapShowPassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  void hideErrorMessage() {
    errorMessage.value = '';
  }

  void updateLoginButtonState() {
    isDisableButton.value = _phone.isEmpty || _password.isEmpty;
  }

  void onTapLogin() {
    try {
      final fbs = formKey.formBuilderState!;
      final emailOrPhoneField = FormFieldType.loginEmailOrPhone.field(fbs);
      final passwordField = FormFieldType.loginPassword.field(fbs);
      [
        emailOrPhoneField,
        passwordField,
      ].validateFormFields();

      _loginUsecase.execute(
        observer: Observer(
          onSubscribe: () {
            loginState.onLoading();
            ignoringPointer.value = true;
            hideErrorMessage();
          },
          onSuccess: (token) async {
            AppConfig.tokenInfo = token;
            if (kDebugMode) {
              print(token.accessToken);
            }
            _storageService.setToken(token.toJson().toString());
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
                    AwesomeDialog(
                      context: Get.context!,
                      dialogType: DialogType.error,
                      title: "Không thể xác thực",
                      desc: "Lỗi xác thực vui lòng thực hiện đăng nhập lại",
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
                  }
                },
              ),
            );
          },
          onError: (e) {
            if (e is DioError) {
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
            loginState.onSuccess();
          },
        ),
        input: LoginRequest(
          _password.trim(),
          phoneNumber: isEmail(_phone) ? null : _phone.trim(),
          email: isEmail(_phone) ? _phone.trim() : null,
        ),
      );
    } catch (e) {
      isDisableButton.value = true;
    }
  }

  bool isEmail(String input) {
    final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailValid.hasMatch(input.toString().trim());
  }

  void _showToastMessage(String message) {
    loginState.onError(message);
    ignoringPointer.value = false;
    errorMessage.value = message;
  }
}
