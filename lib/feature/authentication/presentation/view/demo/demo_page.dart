import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../../base/presentation/base_app_bar.dart';
import '../../controller/demo/demo_controller.dart';

class DemoPage extends GetWidget<DemoController> {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: BaseAppBar(
          title: const Text('Demo Page'),
          centerTitle: true,
          leading: null,
        ),
        body: Column(
          children: [
            FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CommonTextField(
                    formKey: controller.formKey,
                    type: FormFieldType.memo,
                    controller: controller.memoTextEditingController,
                    onTap: null,
                    onChanged: (_) {},
                  ),
                  CommonTextField(
                    formKey: controller.formKey,
                    type: FormFieldType.phone,
                    controller: controller.phomeTextEditingController,
                    onTap: null,
                    onChanged: (_) {},
                  ),
                  CommonTextField(
                    formKey: controller.formKey,
                    type: FormFieldType.password,
                    controller: controller.passwordTextEditingController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    onTap: null,
                    onChanged: (_) {},
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: controller.onTap,
                    child: const Text('API'),
                  ),
                  Obx(() => Text(controller.textApi.value)),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: controller.onTapTextToSpeech,
                    child: const Text('Text To Speech'),
                  ),
                  Obx(() => Text(controller.textApi.value)),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: controller.onTapTextToSpeechStop,
                    child: const Text('Text To Speech Stop'),
                  ),
                  Obx(() => Text(controller.textApi.value)),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: controller.onTapSpeechToText,
                    child: const Text('Speech To Text'),
                  ),
                  Obx(() => Text(controller.textApi.value)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
