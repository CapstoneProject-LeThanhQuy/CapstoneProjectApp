import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final emailOrPhoneTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();
  final loginState = BaseState();

  String get _phone => emailOrPhoneTextEditingController.text;
  String get _password => passwordTextEditingController.text;

  final isDisableButton = true.obs;
  final ignoringPointer = false.obs;
  final errorMessage = ''.obs;
  final isShowPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      emailOrPhoneTextEditingController.text = '0384933379';
      passwordTextEditingController.text = '12312312';
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
      N.toTabBar();
    } catch (e) {}
  }
}
