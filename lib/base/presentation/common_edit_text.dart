import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/services.dart';

class CommonEditText extends StatelessWidget {
  final String hintText;
  final Color hintTextColor;
  final Color borderColor;
  final Icon? prefixIcon;
  final IconButton? prefixIconButton;
  final Widget? suffixIcon;
  final TextInputType inputType;
  final bool obscureText;
  final Function(String)? onChange;
  final Function()? onTap;
  final Function()? onSaved;
  final bool isEnableEdit;
  final List<TextInputFormatter>? formatters;
  final TextEditingController? controller;
  final bool? readOnly;
  final bool expands;
  final int maxlines;
  final String? errorText;
  final bool autofocus;

  const CommonEditText(
      {super.key,
      required this.hintText,
      this.hintTextColor = ColorName.grayBdb,
      this.borderColor = ColorName.primaryColor,
      this.prefixIcon,
      this.prefixIconButton,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.suffixIcon,
      this.onChange,
      this.onTap,
      this.onSaved,
      this.isEnableEdit = true,
      this.formatters,
      this.controller,
      this.readOnly,
      this.expands = false,
      this.maxlines = 1,
      this.autofocus = false,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          autofocus: autofocus,
          readOnly: readOnly ?? false,
          enabled: isEnableEdit,
          onChanged: onChange,
          onTap: onTap,
          obscureText: obscureText,
          controller: controller,
          keyboardType: inputType,
          maxLines: maxlines,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
          inputFormatters: formatters,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            filled: true,
            fillColor: ColorName.whiteFff,
            prefixIcon: prefixIconButton ?? prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: hintText,
          ),
        ),
        Visibility(
          visible: errorText != null,
          child: Text(
            errorText ?? "",
            style: const TextStyle(color: ColorName.redEb5, fontSize: 13, fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}
