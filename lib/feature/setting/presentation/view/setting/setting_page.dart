import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/setting/presentation/controller/setting/setting_controller.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class SettingPage extends BaseWidget<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                'SettingPage',
                style: AppTextStyle.w800s33(ColorName.primaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              color: Colors.transparent,
              child: CommonButton(
                height: 50,
                onPressed: () {
                  controller.logoutEasyEnglish();
                },
                fillColor: ColorName.primaryColor,
                child: Text(
                  'Đăng xuất',
                  style: AppTextStyle.w700s18(ColorName.whiteFff),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
