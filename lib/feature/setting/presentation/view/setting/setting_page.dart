import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/setting/presentation/controller/setting/setting_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
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
      resizeToAvoidBottomInset: true,
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
                    onPressed: () {
                      controller.emailTextEditingController.text =
                          AppConfig.accountInfo.email ?? AppConfig.accountInfo.phoneNumber ?? '';
                      controller.nameTextEditingController.text = AppConfig.accountInfo.username ?? '';
                      controller.gender.value = AppConfig.accountInfo.gender ?? 1 == 1 ? 'Nam' : 'Nữ';
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        builder: (context) => _updateProfile(
                          context,
                        ),
                      );
                    },
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
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'Easy English',
                                style: AppTextStyle.w700s22(ColorName.black000),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Người hướng dẫn:\nPGS.TS NGUYỄN THANH BÌNH',
                                style: AppTextStyle.w700s18(ColorName.black000),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Sinh viên thực hiện:\nLÊ THANH QUÝ',
                                style: AppTextStyle.w700s18(ColorName.black000),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Số thẻ sinh viên:\n102190186',
                                style: AppTextStyle.w700s18(ColorName.black000),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Lớp:\n19TCLC_DT4',
                                style: AppTextStyle.w700s18(ColorName.black000),
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  settingItem(
                    title: "Cài đặt",
                    leading: Assets.images.settingIcon.image(scale: 3),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        builder: (context) => _setTarget(context),
                      );
                    },
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

  Widget _setTarget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorName.whiteFff,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.only(top: 25, bottom: 55),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Mục tiêu hằng ngày của bạn',
            style: AppTextStyle.w800s20(ColorName.primaryColor),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 10,
                onPressed: () {
                  controller.updateTarget(10);
                },
                numberTarget: 10,
              ),
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 20,
                onPressed: () {
                  controller.updateTarget(20);
                },
                numberTarget: 20,
              ),
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 30,
                onPressed: () {
                  controller.updateTarget(30);
                },
                numberTarget: 30,
              ),
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 50,
                onPressed: () {
                  controller.updateTarget(50);
                },
                numberTarget: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget updateTargetItem({
    Function()? onPressed,
    bool isDisabled = false,
    required int numberTarget,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onPressed != null && !isDisabled) {
          onPressed.call();
        }
      },
      child: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: isDisabled ? ColorName.blue005.withOpacity(0.5) : ColorName.blue80b.withOpacity(0.9),
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
              color: ColorName.blue005.withOpacity(0.5),
              spreadRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            numberTarget.toString(),
            style: AppTextStyle.w800s20(ColorName.primaryColor),
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

  Widget _updateProfile(BuildContext context) {
    return Obx(
      () {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                controller.hideKeyboard();
              },
              child: Container(
                color: Colors.transparent,
                child: Obx(
                  () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chỉnh sửa thông tin cá nhân',
                                      style: AppTextStyle.w600s17(
                                        ColorName.black000,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              CommonTextField(
                                type: FormFieldType.emailOrPhone,
                                textInputAction: TextInputAction.next,
                                controller: controller.emailTextEditingController,
                                isEnable: false,
                              ),
                              CommonTextField(
                                type: FormFieldType.name,
                                textInputAction: TextInputAction.next,
                                controller: controller.nameTextEditingController,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Giới tính:",
                                    style: AppTextStyle.w600s16(ColorName.black000),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: DropdownSearch<String>(
                                      popupProps: const PopupProps.menu(
                                        showSelectedItems: true,
                                      ),
                                      items: controller.listGenerator,
                                      dropdownDecoratorProps: DropDownDecoratorProps(
                                        baseStyle: AppTextStyle.w600s15(ColorName.black000),
                                        dropdownSearchDecoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(15),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: ColorName.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.gender.value = value;
                                        }
                                      },
                                      selectedItem: controller.gender.value,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
                                color: Colors.transparent,
                                child: CommonButton(
                                  height: 50,
                                  onPressed: () {
                                    controller.updateProfile();
                                  },
                                  fillColor: ColorName.primaryColor,
                                  child: Text(
                                    'Cập nhật',
                                    style: AppTextStyle.w700s18(ColorName.whiteFff),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (controller.isSheetLoading.value)
              Positioned.fill(
                child: Container(
                  color: ColorName.black000.withOpacity(0.6),
                  child: const LoadingWidget(
                    color: ColorName.whiteFff,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
