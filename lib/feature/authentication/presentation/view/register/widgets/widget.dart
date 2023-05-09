import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/authentication/presentation/controller/register/register_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

part 'widget.g.dart';

@swidget
Widget messageItem({
  required Message message,
  bool isEnglishText = true,
  bool isShowProfile = true,
  int gender = 0,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: message.isErrorMessage
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isShowProfile ? Assets.images.logoIcon.image(height: 50, width: 50) : const SizedBox(width: 50),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                margin: EdgeInsets.only(bottom: isShowProfile ? 30 : 10, left: 10),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: ColorName.redE58,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                    bottomLeft: isShowProfile ? const Radius.circular(0) : const Radius.circular(10),
                  ),
                ),
                child: isEnglishText
                    ? IgnorePointer(
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              message.englishText,
                              speed: const Duration(milliseconds: 60),
                              textStyle: AppTextStyle.w500s14(ColorName.black000),
                            )
                          ],
                        ),
                      )
                    : Text(
                        message.vietnamText,
                        style: AppTextStyle.w500s14(ColorName.black000),
                      ),
              ),
            ],
          )
        : message.isBotMessage
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isShowProfile ? Assets.images.logoIcon.image(height: 50, width: 50) : const SizedBox(width: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    margin: EdgeInsets.only(bottom: isShowProfile ? 30 : 10, left: 10),
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: ColorName.grayD9d,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomRight: const Radius.circular(10),
                        bottomLeft: isShowProfile ? const Radius.circular(0) : const Radius.circular(10),
                      ),
                    ),
                    child: isEnglishText
                        ? IgnorePointer(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  message.englishText,
                                  speed: const Duration(milliseconds: 60),
                                  textStyle: AppTextStyle.w500s14(ColorName.black000),
                                )
                              ],
                            ),
                          )
                        : Text(
                            message.vietnamText,
                            style: AppTextStyle.w500s14(ColorName.black000),
                          ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    margin: EdgeInsets.only(bottom: isShowProfile ? 30 : 15, right: 10),
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: const BoxDecoration(
                      color: ColorName.grayD2d,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: isEnglishText
                        ? IgnorePointer(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  message.englishText,
                                  speed: const Duration(milliseconds: 60),
                                  textAlign: TextAlign.end,
                                  textStyle: AppTextStyle.w500s14(ColorName.black000),
                                )
                              ],
                            ),
                          )
                        : Text(
                            message.vietnamText,
                            style: AppTextStyle.w500s14(ColorName.black000),
                          ),
                  ),
                  gender == 0
                      ? Assets.images.userProfileIcon.image(height: 50, width: 50)
                      : gender == 1
                          ? Assets.images.manProfileIcon.image(height: 50, width: 50)
                          : Assets.images.womanProfileIcon.image(height: 50, width: 50),
                ],
              ),
  );
}
