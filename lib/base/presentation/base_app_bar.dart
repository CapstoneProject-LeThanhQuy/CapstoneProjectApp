import 'package:flutter/material.dart';

import '../../utils/config/app_text_style.dart';
import '../../utils/gen/colors.gen.dart';
import 'widgets/common.dart';

class BaseAppBar extends AppBar {
  BaseAppBar({
    ShapeBorder? shape,
    Color? backgroundColor = ColorName.primaryColor,
    Color? foregroundColor = ColorName.black000,
    Color? shadowColor = Colors.black26,
    Widget? title,
    double? titleSpacing,
    List<Widget>? actions,
    Widget? leading = const CommonBackButton(),
    double? elevation = 3,
    bool centerTitle = true,
    PreferredSizeWidget? bottom,
    Key? key,
  }) : super(
          key: key,
          shape: shape,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          centerTitle: centerTitle,
          title: title,
          titleSpacing: titleSpacing,
          titleTextStyle: AppTextStyle.w500s14(ColorName.whiteFff),
          elevation: elevation,
          leading: leading,
          actions: actions,
          leadingWidth: 100,
          shadowColor: shadowColor,
          bottom: bottom,
        );
}
