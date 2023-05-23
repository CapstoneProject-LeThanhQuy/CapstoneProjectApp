import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

typedef MyFormFieldState = FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;

enum FormFieldType {
  name,
  emailOrPhone,
  phone,
  password,
  confirmPassword,
  memo,
  loginEmailOrPhone,
  loginPassword,
}

extension FormFieldTypeExtension on FormFieldType {
  String get labelText {
    switch (this) {
      case FormFieldType.phone:
        return 'Số điện thoại';
      case FormFieldType.loginEmailOrPhone:
        return 'Số điện thoại hoặc email';
      case FormFieldType.loginPassword:
        return 'Mật khẩu';
      case FormFieldType.memo:
        return '';
      default:
        return '';
    }
  }

  String get hintText {
    switch (this) {
      case FormFieldType.name:
        return 'Họ và tên';
      case FormFieldType.emailOrPhone:
        return 'Your email or phone number';
      case FormFieldType.password:
        return 'Your password';
      case FormFieldType.confirmPassword:
        return 'Confirm Password';
      case FormFieldType.phone:
        return '0123456789';
      case FormFieldType.loginEmailOrPhone:
        return '0123456789 hoặc sample@gmail.com';
      case FormFieldType.loginPassword:
        return 'Mật khẩu';
      default:
        return '';
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.memo:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  MyFormFieldState field(FormBuilderState formBuilderState) {
    final field = formBuilderState.fields[name];
    if (field == null) {
      throw Exception('Cannot detect state of form key');
    }
    return field;
  }

  FormFieldValidator<String?>? validator() {
    List<FormFieldValidator<String?>> validators = [];
    switch (this) {
      case FormFieldType.loginEmailOrPhone:
        validators = [
          FormBuilderValidators.required(errorText: 'Không được để trống số điện thoại hoặc email'),
          FormBuilderValidators.maxLength(35, errorText: 'Số điện thoại hoặc email tối đa 35 ký tự'),
          FormBuilderValidators.compose(
            [
              (val) {
                final validNumber = RegExp(r'^[+|0]{1}[0-9]{9,11}$');
                final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                return validNumber.hasMatch(val.toString().trim()) || emailValid.hasMatch(val.toString().trim())
                    ? null
                    : "Vui lòng nhập vào số điện thoại hoặc email của bạn";
              },
            ],
          ),
        ];
        break;
      case FormFieldType.emailOrPhone:
        validators = [
          FormBuilderValidators.required(errorText: 'Không được để trống nội dung'),
          FormBuilderValidators.maxLength(35, errorText: 'Số điện thoại hoặc email tối đa 35 ký tự'),
          FormBuilderValidators.compose(
            [
              (val) {
                final validNumber = RegExp(r'^[+|0]{1}[0-9]{9,11}$');
                final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                return validNumber.hasMatch(val.toString().trim()) || emailValid.hasMatch(val.toString().trim())
                    ? null
                    : "Vui lòng nhập vào số điện thoại hoặc email của bạn";
              },
            ],
          ),
        ];
        break;
      case FormFieldType.name:
        validators = [
          FormBuilderValidators.required(errorText: 'Không được để trống họ và tên của bạn'),
          FormBuilderValidators.maxLength(25, errorText: 'Họ và tên tối đa 25 ký tự'),
        ];
        break;
      case FormFieldType.phone:
        validators = [
          FormBuilderValidators.required(errorText: 'Không được để trống số điện thoại'),
          // FormBuilderValidators.integer(errorText: 'Số điện thoại bao gồm các chữ số'),
          FormBuilderValidators.maxLength(15, errorText: 'Số điện thoại tối đa 12 chữ số'),
        ];
        break;
      case FormFieldType.loginPassword:
      case FormFieldType.password:
      case FormFieldType.confirmPassword:
        validators = [
          FormBuilderValidators.required(errorText: 'Không được để trống mật khẩu'),
          FormBuilderValidators.minLength(8, errorText: 'Mật khẩu bao gồm tối thiểu 8 ký tự chữ và số'),
        ];
        break;
      case FormFieldType.memo:
        validators = [FormBuilderValidators.maxLength(1000, errorText: 'Vượt quá giói hạn số từ')];
        break;
      default:
        return null;
    }
    return FormBuilderValidators.compose(validators);
  }
}

extension FormKeyExtension on GlobalKey<FormBuilderState> {
  FormBuilderState? get formBuilderState {
    return currentState;
  }
}

extension ListFormFieldState on List<MyFormFieldState> {
  void validateFormFields() {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = map((e) => e.validate()).reduce((v, e) => v && e);
    if (!isValid) {
      final errorMessage = map(
        (e) => e.errorText == null ? null : '${e.errorText}',
      ).whereType<String>().toList().join('\n');
      throw Exception(errorMessage);
    }
  }
}
