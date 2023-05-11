import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/authentication/presentation/controller/landing/landing_controller.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';

class LandingPage extends BaseWidget<LandingController> {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.whiteFff,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 125,
            ),
            Center(
              child: Assets.images.logoIcon.image(width: 80, height: 80),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Easy English',
              style: AppTextStyle.w800s33(ColorName.primaryColor, letterSpacing: 0.38),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Want to make new friends?\nLearn English easily. Why not?',
              style: AppTextStyle.w600s13(ColorName.primaryColor, letterSpacing: 0.38),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CommonButton(
              height: 50,
              onPressed: controller.toRegiter,
              fillColor: ColorName.primaryColor,
              child: Text(
                'Bắt đầu',
                style: AppTextStyle.w700s18(ColorName.whiteFff),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CupertinoButton(
              onPressed: () {
                controller.toLogin();
              },
              padding: EdgeInsets.zero,
              child: Text('Tôi đã có tài khoản', style: AppTextStyle.w700s16(ColorName.primaryColor)),
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
