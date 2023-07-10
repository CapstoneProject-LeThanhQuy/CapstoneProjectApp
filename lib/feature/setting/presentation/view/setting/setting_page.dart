import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/setting/presentation/controller/setting/setting_controller.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SettingPage extends BaseWidget<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IgnorePointer(
          ignoring: controller.isLoading.value,
          child: SmartRefresher(
            enablePullDown: true,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            header: const WaterDropMaterialHeader(
              backgroundColor: ColorName.primaryColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    color: ColorName.grayF4f,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        controller.accountInfo.value.gender == null
                            ? Assets.images.userProfileIcon.image(height: 60, width: 60)
                            : controller.accountInfo.value.gender ?? true
                                ? Assets.images.manProfileIcon.image(height: 60, width: 60)
                                : Assets.images.womanProfileIcon.image(height: 60, width: 60),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.accountInfo.value.username ?? '',
                              style: AppTextStyle.w600s16(ColorName.black000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  settingItem(
                    title: controller.accountInfo.value.phoneNumber ?? controller.accountInfo.value.email ?? '',
                    leading: Assets.images.phoneIcon1.image(scale: 3),
                    onPressed: () {},
                  ),
                  settingItem(
                    title: "Đổi mật khẩu",
                    leading: Assets.images.keyIcon.image(scale: 3),
                    onPressed: () {
                      N.toForgotPasswordPage(title: 'Đổi mật khẩu');
                    },
                  ),
                  settingItem(
                    title: "Đăng xuất",
                    leading: Assets.images.logOutIcon.image(scale: 3),
                    onPressed: () {
                      controller.logoutEasyEnglish();
                    },
                  ),
                  Container(
                    color: ColorName.grayF4f,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                          width: Get.width,
                        ),
                        Text(
                          "Tổng quát",
                          style: AppTextStyle.w600s15(ColorName.black000),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  settingItem(
                    title: "Giới thiệu",
                    leading: Assets.images.introIcon.image(scale: 3),
                    onPressed: () {},
                  ),
                  settingItem(
                    title: "Cài đặt",
                    leading: Assets.images.settingIcon.image(scale: 3),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget settingItem({
    String? title,
    Widget? leading,
    required Function() onPressed,
    bool topBorder = false,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorName.whiteFff,
          border: Border(
            bottom: const BorderSide(width: 1, color: ColorName.grayBdb),
            top: topBorder ? const BorderSide(width: 1, color: ColorName.grayBdb) : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            leading ?? const SizedBox.shrink(),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title ?? "",
                style: AppTextStyle.w400s15(ColorName.black000),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right_outlined,
              color: ColorName.gray838,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
