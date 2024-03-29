import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../utils/config/app_text_style.dart';
import '../../../utils/gen/assets.gen.dart';
import '../../../utils/gen/colors.gen.dart';

part 'common.g.dart';

@swidget
Widget commonBackButton({void Function()? onPressed}) {
  return CupertinoButton(
    onPressed: () {
      if (onPressed != null) {
        onPressed.call();
      } else {
        Get.back();
      }
    },
    child: Row(
      children: [
        Assets.images.backIcon.image(width: 8, color: ColorName.whiteFff),
        const SizedBox(width: 10),
        Text(
          'Quay lại',
          style: AppTextStyle.w500s13(ColorName.whiteFff),
        ),
      ],
    ),
  );
}

@swidget
Widget commonCloseButton({void Function()? onPressed}) {
  return CupertinoButton(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 6),
    onPressed: () {
      if (onPressed != null) {
        onPressed.call();
      } else {
        Get.back();
      }
    },
    child: Assets.images.closeIcon.image(width: 30),
  );
}

@swidget
Widget loadingWidget({Color? color}) {
  return Center(
    child: SpinKitChasingDots(color: color ?? ColorName.primaryColor),
  );
}

// Error dialog
@swidget
Widget errorDialog({
  Widget? title,
  Widget? content,
  void Function()? onPressed,
}) {
  return CupertinoAlertDialog(
    title: title,
    content: content,
    actions: [
      TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed.call();
          }
        },
        child: const Text('OK'),
      ),
    ],
  );
}

@swidget
Widget commonTextField(
  BuildContext textFieldContext, {
  GlobalKey<FormBuilderState>? formKey,
  required FormFieldType type,
  bool obscureText = false,
  bool isEnable = true,
  int? maxLines = 1,
  int? maxLength,
  bool autofocus = false,
  TextAlign textAlign = TextAlign.start,
  String? initialValue,
  TextEditingController? controller,
  TextInputAction? textInputAction = TextInputAction.next,
  void Function()? onTap,
  void Function(String?)? onChanged,
  void Function(String?)? onSubmitted,
  Widget? suffixIcon,
  void Function()? onPressedSuffixIcon,
  double height = 72,
  Color? fillColor,
  TextStyle? textStyle,
}) {
  final ctl = controller ?? TextEditingController();
  return Theme(
    data: Theme.of(textFieldContext).copyWith(
      primaryColor: ColorName.redFf3,
    ),
    child: SizedBox(
      height: height,
      child: Focus(
        child: Builder(
          builder: (BuildContext context) {
            final FocusNode focusNode = Focus.of(context);
            final bool hasFocus = focusNode.hasFocus;
            return FormBuilderTextField(
              textAlign: textAlign,
              maxLength: maxLength,
              autofocus: autofocus,
              scrollPadding: const EdgeInsets.all(36.0),
              maxLines: maxLines,
              initialValue: initialValue,
              name: type.name,
              style: textStyle ?? AppTextStyle.w400s13(ColorName.black333),
              keyboardType: type.keyboardType,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: textInputAction,
              obscureText: obscureText,
              cursorColor: ColorName.primaryColor,
              cursorWidth: 1.5,
              controller: ctl,
              enabled: isEnable,
              decoration: InputDecoration(
                counterText: "",
                errorMaxLines: 2,
                isDense: true,
                labelText: type.labelText,
                labelStyle: AppTextStyle.w700s14(ColorName.primaryColor),
                alignLabelWithHint: true,
                filled: true,
                fillColor: fillColor ?? (hasFocus ? ColorName.whiteFff : ColorName.grayF8f),
                hintText: type.hintText,
                hintStyle: AppTextStyle.w400s13(ColorName.grayC7c),
                errorStyle: AppTextStyle.w400s13(ColorName.redFf3, height: 1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorName.gray838, width: 0.7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorName.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorName.redFf3, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorName.redFf3, width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorName.gray838, width: 0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: suffixIcon == null
                    ? null
                    : CupertinoButton(
                        minSize: 0,
                        padding: const EdgeInsets.only(right: 8),
                        onPressed: onPressedSuffixIcon,
                        child: suffixIcon,
                      ),
              ),
              validator: type.validator(),
              onTap: formKey?.formBuilderState == null || type.validator() == null
                  ? null
                  : () {
                      final text = ctl.text;
                      final field = type.field(formKey!.formBuilderState!);
                      if (type.validator() != null) {
                        field.validate();
                        field.reset();
                        ctl.value = ctl.value.copyWith(
                          text: text,
                          selection: TextSelection.collapsed(offset: text.length),
                        );
                      }
                      onTap?.call();
                    },
              onChanged: formKey?.formBuilderState == null || type.validator() == null
                  ? null
                  : (v) {
                      final text = ctl.text;
                      final field = type.field(formKey!.formBuilderState!);
                      if (type.validator() != null && field.hasError) {
                        field.validate();
                        field.reset();
                        ctl.value = ctl.value.copyWith(
                          text: text,
                          selection: TextSelection.collapsed(offset: text.length),
                        );
                      }
                      onChanged?.call(v);
                    },
              onSubmitted: onSubmitted ??
                  (_) {
                    FocusScope.of(context).nextFocus();
                  },
            );
          },
        ),
      ),
    ),
  );
}

@swidget
Widget commonDropDown({
  required String title,
  String? value,
  void Function()? onPressed,
  double height = 50,
}) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    child: Container(
      margin: const EdgeInsets.only(bottom: 22),
      height: height,
      decoration: BoxDecoration(
        color: value != null ? ColorName.whiteFff : ColorName.grayF8f,
        border: Border.all(color: ColorName.gray838, width: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 13),
          Text(
            value ?? title,
            style: AppTextStyle.w400s11(value != null ? ColorName.black000 : ColorName.gray838),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: ColorName.black000),
          const SizedBox(width: 13),
        ],
      ),
    ),
  );
}

@swidget
Widget commonButton({
  required Widget child,
  double? width,
  double height = 44,
  Function()? onPressed,
  Color fillColor = ColorName.primaryColor,
  Color? borderColor,
  double borderWidth = 1,
  BorderRadiusGeometry? borderRadius,
  BaseState? state,
  Color indicatorColor = Colors.white,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: fillColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            side: BorderSide(
              width: borderWidth,
              color: borderColor ?? fillColor,
            ),
          ),
        ),
        child: state != null
            ? state.widget(
                onLoading: Center(
                  child: CupertinoActivityIndicator(color: indicatorColor),
                ),
                onEmpty: child,
              )
            : child,
      ),
    ),
  );
}

@swidget
Widget commonBottomError({required String text}) {
  return text.isEmpty
      ? const SizedBox.shrink()
      : Container(
          padding: const EdgeInsets.all(11),
          color: ColorName.redFf3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info,
                color: Colors.white,
                size: 13,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyle.w500s11(ColorName.whiteFff),
                ),
              ),
            ],
          ),
        );
}

@swidget
Widget commonBottomButton({
  required String text,
  Color fillColor = ColorName.primaryColor,
  double pressedOpacity = 0.4,
  Function()? onPressed,
  BaseState? state,
}) {
  final textWidget = Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      text,
      style: AppTextStyle.w700s16(ColorName.whiteFff),
    ),
  );
  return SizedBox(
    height: 80,
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      pressedOpacity: pressedOpacity,
      child: Container(
        alignment: Alignment.center,
        color: fillColor,
        child: state != null
            ? state.widget(
                onEmpty: textWidget,
                onLoading: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: CupertinoActivityIndicator(color: Colors.white),
                  ),
                ),
              )
            : textWidget,
      ),
    ),
  );
}
