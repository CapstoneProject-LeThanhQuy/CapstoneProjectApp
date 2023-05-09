import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/authentication/presentation/controller/register/register_controller.dart';
import 'package:easy_english/feature/authentication/presentation/view/register/widgets/widget.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';

class RegisterPage extends BaseWidget<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        title: const Text('Easy English'),
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlutterSwitch(
                          width: 110.0,
                          valueFontSize: 11.0,
                          toggleSize: 15.0,
                          value: controller.isEnglishText.value,
                          borderRadius: 20.0,
                          padding: 8.0,
                          showOnOff: true,
                          inactiveText: 'Tiếng Anh',
                          activeText: 'Vietnamese',
                          inactiveColor: ColorName.grayD9d,
                          inactiveTextColor: ColorName.black000,
                          activeTextColor: ColorName.whiteFff,
                          activeColor: ColorName.primaryColor,
                          onToggle: (val) {
                            controller.isEnglishText.value = !controller.isEnglishText.value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(bottom: 150),
                      itemCount: controller.listMessages.length,
                      itemBuilder: (context, index) {
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            controller.speechText(index);
                          },
                          child: MessageItem(
                            message: controller.listMessages[index],
                            isEnglishText: controller.isEnglishText.value,
                            isShowProfile: controller.checkShowProfile(
                              controller.listMessages,
                              index,
                            ),
                            gender: controller.gender.value,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: ColorName.black000.withOpacity(0.6),
                  child: const LoadingWidget(
                    color: ColorName.whiteFff,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
