import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class RegisterController extends BaseController {
  List<Message> messages = [
    Message('Xin chào, chào mừng đến với Easy English', 'Hi, Welcome to Easy English', true, false),
    Message('Hãy đến và thử ngôn ngữ tiếng Anh cho một cuộc sống tuyệt vời',
        'Come and try the English language for an excellent life', true, false),
    Message(
        'Đầu tiên, chúng tôi có một vài câu hỏi dành cho bạn', 'First, We have a few questions for you', true, false),
    Message('Bạn đã sẵn sàng để trả lời chứ?', 'Are you ready to answer?', true, false),
    Message('Tên của bạn là gì?', 'What your name?', true, false),
    Message(
      'Bạn có thể cung cấp số điện thoại hoặc email của bạn chứ?',
      'Can you provide your phone number or email?',
      true,
      false,
    ),
    Message(
      'Chúng tôi đã gửi cho bạn một mã OTP, vui lòng xác nhận mã để tiếp tục',
      'We have sent you an OTP, please confirm the code to continue',
      true,
      false,
    ),
    Message(
      'Vui lòng nhập mật khẩu cho lần đăng nhập tiếp theo bao gồm tối thiểu 8 ký tự chữ và số',
      'Please enter a password for the next login consisting of at least 8 alphanumeric characters',
      true,
      false,
    ),
    Message('Vui lòng xác nhận mật khẩu của bạn', 'Please confirm your password', true, false),
    Message(
      'Cảm ơn bạn đã trả lời các câu hỏi của tôi, vui lòng đợi trong giây lát tôi sẽ đăng ký cho bạn một tài khoản Easy English!!!',
      'Thank you for answering my questions, please wait a moment I will sign you up for an Easy English account!!!',
      true,
      false,
    ),
    Message(
      'Chúc mừng bạn! Bạn đã hoàn thành quá trình đăng ký, bây giờ bạn có thể tham gia các khóa học từ vựng trên ứng dụng',
      'Congratulations! You have completed the registration process, you can now join the vocabulary courses on the app.',
      true,
      false,
    ),
    Message(
      'Chào mừng đến với Easy English!!!!!',
      'Welcome to Easy English!!!!!',
      true,
      false,
    ),
  ];

  RxList<Message> listMessages = RxList.empty();
  int currentIndex = 0;
  RxBool isEnglishText = true.obs;

  CommonTextToSpeech commonTextToSpeech = CommonTextToSpeech();
  String name = '';
  RxInt gender = 0.obs;
  String emailOrPhone = '';
  String password = '';
  String confirmPassword = '';
  bool isSpeaking = true;
  String otpPin = '123456';

  final formKey = GlobalKey<FormBuilderState>();
  final nameTextEditingController = TextEditingController();
  final emailOrPhoneTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initMessage();
  }

  @override
  void onClose() {
    super.onClose();
    commonTextToSpeech.stop();
  }

  @override
  void onPaused() {
    super.onPaused();
    commonTextToSpeech.stop();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 1,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeInOut,
    );
  }

  void initMessage() async {
    await Future.delayed(const Duration(milliseconds: 600));
    newMessage(
      messages[currentIndex],
      completed: () async {
        currentIndex += 1;
        firstBotMessages();
      },
    );
  }

  void firstBotMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    newMessage(
      messages[currentIndex],
      completed: () {
        if (currentIndex <= 2) {
          currentIndex += 1;
          firstBotMessages();
        } else {
          showMessage();
          isSpeaking = false;
        }
      },
    );
  }

  void newMessage(Message message, {Function? completed}) {
    listMessages.add(message);
    scrollToBottom();
    if (message.isCanSpeech) {
      isSpeaking = true;
      commonTextToSpeech.speech(message.englishText, completed: completed);
    } else {
      completed!();
    }
  }

  void speechText(int index) {
    if (!isSpeaking) {
      if (index == listMessages.length - 1 && listMessages[index].isBotMessage) {
        showMessage();
      }
      if (listMessages[index].isCanSpeech) {
        commonTextToSpeech.speech(listMessages[index].englishText);
      }
    }
  }

  bool checkShowProfile(List<Message> messages, int index) {
    if (messages.length <= index + 1) {
      return true;
    }
    return messages[index].isBotMessage != messages[index + 1].isBotMessage;
  }

  Widget addShadow(Widget child, {bool isCenter = true}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: isCenter ? const Offset(0, 0) : const Offset(10, -5),
            blurRadius: 10.0,
            color: ColorName.black333.withOpacity(0.7),
          ),
        ],
      ),
      child: child,
    );
  }

  void showMessage() {
    switch (currentIndex) {
      case 3:
        showMessageConfirm();
        break;
      case 4:
        showMessageName();
        break;
      case 5:
        showMessageGender();
        break;
      case 6:
        showMessagePhoneOrEmail();
        break;
      case 7:
        showMessageOTP();
        break;
      case 8:
        showMessagePassword();
        break;
      case 9:
        showMessageConfirmPassword();
        break;
      case 10:
        registerLoading();
        break;
      case 11:
        finishRegiter();
        break;
      case 12:
        goToHomePage();
        break;
      default:
        Get.back();
    }
  }

  void nextBotMessage() async {
    await Future.delayed(const Duration(milliseconds: 600));
    newMessage(
      messages[currentIndex],
      completed: () {
        isSpeaking = false;
        showMessage();
      },
    );
  }

  void showMessageConfirm() {
    BaseHelper.showCustomDialog(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addShadow(
              Text(
                isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                textAlign: TextAlign.center,
                style: AppTextStyle.w800s20(ColorName.whiteFff),
              ),
            ),
            Column(
              children: [
                CommonButton(
                  height: 50,
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  fillColor: ColorName.whiteFff,
                  child: Text(
                    isEnglishText.value
                        ? "I'm sorry, but I'm not ready right now"
                        : 'Tôi xin lỗi, nhưng tôi chưa sẵn sàng ngay bây giờ',
                    style: AppTextStyle.w600s13(ColorName.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                CommonButton(
                  height: 50,
                  onPressed: () {
                    Get.back();
                    currentIndex += 1;
                    newMessage(
                      Message(
                        "Được rồi, tôi sẵn sàng trả lời các câu hỏi. Hãy bắt đầu!",
                        "Okay, I'm ready to answer questions.\nLet's start!",
                        false,
                        false,
                      ),
                      completed: () {
                        nextBotMessage();
                      },
                    );
                  },
                  fillColor: ColorName.primaryColor,
                  child: Text(
                    isEnglishText.value
                        ? "Okay, I'm ready to answer questions. Let's start!"
                        : 'Được rồi, tôi đã sẵn sàng trả lời các câu hỏi. Hãy bắt đầu!',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.w600s13(ColorName.whiteFff),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showMessageName() {
    RxBool isShowSubmitButton = false.obs;
    nameTextEditingController.text = '';
    BaseHelper.showCustomDialog(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.back(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                addShadow(
                  Text(
                    isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.w800s20(ColorName.whiteFff),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      addShadow(
                        FormBuilder(
                          key: formKey,
                          child: CommonTextField(
                            autofocus: true,
                            formKey: formKey,
                            type: FormFieldType.name,
                            controller: nameTextEditingController,
                            textInputAction: TextInputAction.done,
                            onTap: null,
                            onChanged: (value) {
                              if ((value ?? '').isNotEmpty) {
                                name = value!;
                                isShowSubmitButton.value = true;
                              } else {
                                isShowSubmitButton.value = false;
                              }
                            },
                            onSubmitted: (value) {
                              submitName();
                            },
                          ),
                        ),
                        isCenter: false,
                      ),
                      const SizedBox(height: 5),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: isShowSubmitButton.value
                            ? Row(
                                children: [
                                  const Spacer(),
                                  addShadow(
                                    CommonButton(
                                      width: 150,
                                      height: 40,
                                      onPressed: () {
                                        submitName();
                                      },
                                      fillColor: ColorName.primaryColor,
                                      child: Text(
                                        isEnglishText.value ? "Next" : 'Tiếp tục',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.w600s13(ColorName.whiteFff),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitName() {
    try {
      final fbs = formKey.formBuilderState!;
      final phoneField = FormFieldType.name.field(fbs);
      [
        phoneField,
      ].validateFormFields();

      Get.back();
      currentIndex += 1;
      newMessage(
        Message(
          "Tên của tồi là $name",
          "My name is $name",
          false,
          false,
        ),
        completed: () {
          messages.insert(
            currentIndex,
            Message('Xin chào $name, Giơi tinh của bạn la gi?', 'Hi $name, What’s your gender?', true, false),
          );
          nextBotMessage();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showMessageGender() {
    BaseHelper.showCustomDialog(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addShadow(
              Text(
                isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                textAlign: TextAlign.center,
                style: AppTextStyle.w800s20(ColorName.whiteFff),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CommonButton(
                    height: 50,
                    onPressed: () {
                      submitGender(2);
                    },
                    fillColor: ColorName.whiteFff,
                    child: Text(
                      isEnglishText.value ? "Female" : 'Nữ',
                      style: AppTextStyle.w600s13(ColorName.primaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: CommonButton(
                    height: 50,
                    onPressed: () {
                      submitGender(1);
                    },
                    fillColor: ColorName.primaryColor,
                    child: Text(
                      isEnglishText.value ? "Male" : 'Nam',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.w600s13(ColorName.whiteFff),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void submitGender(int value) {
    Get.back();
    gender.value = value;
    currentIndex += 1;
    newMessage(
      Message(
        "Tôi là ${value == 1 ? 'Nam giới' : 'Nữ giới'}",
        "I am ${value == 1 ? 'Male' : 'Female'}",
        false,
        false,
      ),
      completed: () {
        nextBotMessage();
      },
    );
  }

  void showMessagePhoneOrEmail() {
    RxBool isShowSubmitButton = false.obs;
    emailOrPhoneTextEditingController.text = '';
    BaseHelper.showCustomDialog(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.back(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                addShadow(
                  Text(
                    isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.w800s20(ColorName.whiteFff),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      addShadow(
                        FormBuilder(
                          key: formKey,
                          child: CommonTextField(
                            autofocus: true,
                            formKey: formKey,
                            type: FormFieldType.emailOrPhone,
                            controller: emailOrPhoneTextEditingController,
                            textInputAction: TextInputAction.done,
                            onTap: null,
                            onChanged: (value) {
                              if ((value ?? '').isNotEmpty) {
                                isShowSubmitButton.value = true;
                              } else {
                                isShowSubmitButton.value = false;
                              }
                            },
                            onSubmitted: (value) {
                              submitEmailOrPhone();
                            },
                          ),
                        ),
                        isCenter: false,
                      ),
                      const SizedBox(height: 5),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: isShowSubmitButton.value
                            ? Row(
                                children: [
                                  const Spacer(),
                                  addShadow(
                                    CommonButton(
                                      width: 150,
                                      height: 40,
                                      onPressed: () {
                                        submitEmailOrPhone();
                                      },
                                      fillColor: ColorName.primaryColor,
                                      child: Text(
                                        isEnglishText.value ? "Next" : 'Tiếp tục',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.w600s13(ColorName.whiteFff),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitEmailOrPhone() {
    try {
      final fbs = formKey.formBuilderState!;
      final emailOrPhoneField = FormFieldType.emailOrPhone.field(fbs);
      [
        emailOrPhoneField,
      ].validateFormFields();
      emailOrPhone = emailOrPhoneTextEditingController.text;
      //TODO sendOTP
      Get.back();
      currentIndex += 1;
      newMessage(
        Message(emailOrPhone, emailOrPhone, false, false, isCanSpeech: false),
        completed: () {
          nextBotMessage();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showMessageOTP() {
    BaseHelper.showCustomDialog(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.back(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                addShadow(
                  Text(
                    isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.w800s20(ColorName.whiteFff),
                  ),
                ),
                OTPTextField(
                  length: 6,
                  fieldWidth: Get.width / 8,
                  width: Get.width,
                  style: AppTextStyle.w600s15(ColorName.primaryColor),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  otpFieldStyle: OtpFieldStyle(
                    borderColor: ColorName.primaryColor,
                    backgroundColor: ColorName.whiteFaf,
                  ),
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    if (pin != otpPin) {
                      // TODO
                    } else {
                      Get.back();
                      currentIndex += 1;
                      newMessage(
                        Message(otpPin, otpPin, false, false, isCanSpeech: false),
                        completed: () {
                          nextBotMessage();
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessagePassword() {
    RxBool isShowSubmitButton = false.obs;
    passwordTextEditingController.text = '';
    BaseHelper.showCustomDialog(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.back(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                addShadow(
                  Text(
                    isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.w800s20(ColorName.whiteFff),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      addShadow(
                        FormBuilder(
                          key: formKey,
                          child: CommonTextField(
                            autofocus: true,
                            formKey: formKey,
                            type: FormFieldType.password,
                            controller: passwordTextEditingController,
                            textInputAction: TextInputAction.done,
                            onTap: null,
                            onChanged: (value) {
                              if ((value ?? '').isNotEmpty) {
                                isShowSubmitButton.value = true;
                              } else {
                                isShowSubmitButton.value = false;
                              }
                            },
                            onSubmitted: (value) {
                              submitPassword();
                            },
                          ),
                        ),
                        isCenter: false,
                      ),
                      const SizedBox(height: 5),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: isShowSubmitButton.value
                            ? Row(
                                children: [
                                  const Spacer(),
                                  addShadow(
                                    CommonButton(
                                      width: 150,
                                      height: 40,
                                      onPressed: () {
                                        submitPassword();
                                      },
                                      fillColor: ColorName.primaryColor,
                                      child: Text(
                                        isEnglishText.value ? "Next" : 'Tiếp tục',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.w600s13(ColorName.whiteFff),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateStringPassword(int count) {
    String result = "";
    for (int i = 0; i < count; i++) {
      result += "*";
    }
    return result;
  }

  void submitPassword() {
    try {
      final fbs = formKey.formBuilderState!;
      final passwordField = FormFieldType.password.field(fbs);
      [
        passwordField,
      ].validateFormFields();
      password = passwordTextEditingController.text;
      Get.back();
      currentIndex += 1;
      newMessage(
        Message(
          generateStringPassword(password.length),
          generateStringPassword(password.length),
          false,
          false,
          isCanSpeech: false,
        ),
        completed: () {
          nextBotMessage();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showMessageConfirmPassword() {
    RxBool isShowSubmitButton = false.obs;
    confirmPasswordTextEditingController.text = '';
    BaseHelper.showCustomDialog(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.back(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                addShadow(
                  Text(
                    isEnglishText.value ? messages[currentIndex].englishText : messages[currentIndex].vietnamText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.w800s20(ColorName.whiteFff),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      addShadow(
                        FormBuilder(
                          key: formKey,
                          child: CommonTextField(
                            autofocus: true,
                            formKey: formKey,
                            type: FormFieldType.confirmPassword,
                            controller: confirmPasswordTextEditingController,
                            textInputAction: TextInputAction.done,
                            onTap: null,
                            onChanged: (value) {
                              if ((value ?? '').isNotEmpty) {
                                isShowSubmitButton.value = true;
                              } else {
                                isShowSubmitButton.value = false;
                              }
                            },
                            onSubmitted: (value) {
                              submitConfirmPassword();
                            },
                          ),
                        ),
                        isCenter: false,
                      ),
                      const SizedBox(height: 5),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: isShowSubmitButton.value
                            ? Row(
                                children: [
                                  const Spacer(),
                                  addShadow(
                                    CommonButton(
                                      width: 150,
                                      height: 40,
                                      onPressed: () {
                                        submitConfirmPassword();
                                      },
                                      fillColor: ColorName.primaryColor,
                                      child: Text(
                                        isEnglishText.value ? "Next" : 'Tiếp tục',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.w600s13(ColorName.whiteFff),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitConfirmPassword() {
    try {
      final fbs = formKey.formBuilderState!;
      final confirmPasswordField = FormFieldType.confirmPassword.field(fbs);
      [
        confirmPasswordField,
      ].validateFormFields();
      confirmPassword = confirmPasswordTextEditingController.text;
      if (confirmPassword != password) {
        // TODO
        Get.back();
        return;
      }
      Get.back();
      currentIndex += 1;
      newMessage(
        Message(
          generateStringPassword(confirmPassword.length),
          generateStringPassword(confirmPassword.length),
          false,
          false,
          isCanSpeech: false,
        ),
        completed: () {
          nextBotMessage();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  RxBool isLoading = false.obs;
  void registerLoading() async {
    isLoading.value = true;
    //TODO register
    await Future.delayed(const Duration(seconds: 5));
    isLoading.value = false;
    currentIndex += 1;
    nextBotMessage();
  }

  void finishRegiter() {
    currentIndex += 1;
    nextBotMessage();
  }

  void goToHomePage() {
    BaseHelper.showCustomDialog(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Get.back();
          N.toTabBar();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TODO
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Message {
  String englishText;
  String vietnamText;
  bool isBotMessage;
  bool isErrorMessage;
  bool isCanSpeech;

  Message(
    this.vietnamText,
    this.englishText,
    this.isBotMessage,
    this.isErrorMessage, {
    this.isCanSpeech = true,
  });
}
