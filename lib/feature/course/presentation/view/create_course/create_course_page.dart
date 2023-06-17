import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/controller/create_course/create_course_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class CreateCoursePage extends BaseWidget<CreateCourseController> {
  const CreateCoursePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return GestureDetector(
      onTap: controller.hideKeyboard,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: BaseAppBar(
          title: const Text('Tạo mới khóa học'),
        ),
        backgroundColor: Colors.white,
        body: Obx(
          () => IgnorePointer(
            ignoring: controller.ignoringPointer.value,
            child: SizedBox(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
                        child: FormBuilder(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              CommonTextField(
                                formKey: controller.formKey,
                                type: FormFieldType.title,
                                textInputAction: TextInputAction.next,
                                controller: controller.titleTextEditingController,
                                onTap: controller.hideErrorMessage,
                                onChanged: (_) {
                                  controller.updateCreateButtonState();
                                },
                              ),
                              const SizedBox(height: 10),
                              CommonTextField(
                                formKey: controller.formKey,
                                height: 108,
                                maxLines: 10,
                                type: FormFieldType.memo,
                                textInputAction: TextInputAction.newline,
                                onTap: controller.hideErrorMessage,
                                onChanged: (_) {
                                  controller.updateCreateButtonState();
                                },
                                controller: controller.memoTextEditingController,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Độ khó:",
                                        style: AppTextStyle.w600s16(ColorName.black000),
                                      ),
                                      Text(
                                        "Số lần phải học qua của một từ vựng",
                                        style: AppTextStyle.w400s14(ColorName.black000),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Obx(
                                    () {
                                      return Expanded(
                                        child: DropdownSearch<String>(
                                          popupProps: const PopupProps.menu(
                                            showSelectedItems: true,
                                          ),
                                          items: controller.listProgress.value,
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
                                            controller.progress.value = value ?? '10';
                                          },
                                          selectedItem: "10",
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              CommonTextField(
                                formKey: controller.formKey,
                                type: FormFieldType.imageCourse,
                                textInputAction: TextInputAction.done,
                                onTap: controller.hideErrorMessage,
                                suffixIcon: const Icon(
                                  CupertinoIcons.camera_on_rectangle_fill,
                                  color: ColorName.primaryColor,
                                ),
                                onPressedSuffixIcon: () {
                                  controller.pickImage(context);
                                },
                                onChanged: (_) {
                                  controller.updateCreateButtonState();
                                },
                                controller: controller.imageTextEditingController,
                                onSubmitted: (p0) {},
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  Text(
                                    "Khóa học riêng tư:",
                                    style: AppTextStyle.w600s16(ColorName.black000),
                                  ),
                                  const SizedBox(width: 15),
                                  FlutterSwitch(
                                    width: 60.0,
                                    height: 30.0,
                                    valueFontSize: 12.0,
                                    toggleSize: 12.0,
                                    value: controller.isPrivate.value,
                                    borderRadius: 20.0,
                                    padding: 8.0,
                                    activeColor: ColorName.green459,
                                    inactiveColor: ColorName.grayC7c,
                                    activeText: '',
                                    inactiveText: '',
                                    showOnOff: true,
                                    onToggle: (val) {
                                      controller.isPrivate.value = val;
                                      controller.updateCreateButtonState();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Obx(
                                () {
                                  return AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: controller.isPrivate.value
                                        ? CommonTextField(
                                            formKey: controller.formKey,
                                            autofocus: true,
                                            type: FormFieldType.passwordCourse,
                                            textInputAction: TextInputAction.next,
                                            obscureText: controller.isShowPassword.value,
                                            suffixIcon: controller.isShowPassword.value
                                                ? Assets.images.showPassIcon.image(scale: 4)
                                                : Assets.images.hidePassIcon.image(scale: 4),
                                            onPressedSuffixIcon: controller.onTapShowPassword,
                                            onTap: controller.hideErrorMessage,
                                            onChanged: (_) {
                                              controller.updateCreateButtonState();
                                            },
                                            controller: controller.passwordTextEditingController,
                                          )
                                        : const SizedBox(),
                                  );
                                },
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => CommonBottomError(text: controller.errorMessage.value),
                  ),
                  Obx(
                    () => CommonBottomButton(
                      text: 'Tiếp tục',
                      onPressed: () {
                        controller.onTapCreate();
                      },
                      pressedOpacity: controller.isDisableButton.value ? 1 : 0.4,
                      fillColor: controller.isDisableButton.value ? ColorName.gray838 : ColorName.primaryColor,
                      state: controller.createState,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
