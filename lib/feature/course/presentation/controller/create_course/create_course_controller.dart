import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/providers/remote/request/create_course_request.dart';
import 'package:easy_english/feature/course/domain/usecases/create_course_usecase.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class CreateCourseController extends BaseController {
  final CreateCourseUsecase _createCourseUsecase;

  CreateCourseController(this._createCourseUsecase);

  final titleTextEditingController = TextEditingController();
  final memoTextEditingController = TextEditingController();
  final imageTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  final formKey = GlobalKey<FormBuilderState>();
  final createState = BaseState();

  String get _title => titleTextEditingController.text;
  String get _memo => memoTextEditingController.text;
  String get _password => passwordTextEditingController.text;

  final isDisableButton = true.obs;
  final ignoringPointer = false.obs;
  final errorMessage = ''.obs;
  final isShowPassword = true.obs;

  final RxList<String> listProgress = <String>[
    '5',
    '10',
    '20',
    '30',
    '50',
    '100',
  ].obs;
  Rx<String> progress = '10'.obs;

  RxBool isPrivate = false.obs;

  final _picker = ImagePicker();

  void onTapShowPassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  void hideErrorMessage() {
    errorMessage.value = '';
  }

  void updateCreateButtonState() {
    isDisableButton.value = _title.isEmpty || _memo.isEmpty || (_password.isEmpty && isPrivate.value);
  }

  void _showToastMessage(String message) {
    createState.onError(message);
    ignoringPointer.value = false;
    errorMessage.value = message;
  }

  Rx<XFile> imageCourse = XFile('').obs;
  Future<void> pickImage(BuildContext context) async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      context: context,
      builder: ((context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorName.grayC7c,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  imageCourse.value =
                      await _picker.pickImage(source: ImageSource.camera, imageQuality: 50) ?? XFile('');
                  back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Text(
                    'Chụp ảnh',
                    style: AppTextStyle.w600s15(ColorName.black000),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorName.grayC7c,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  imageCourse.value =
                      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50) ?? XFile('');
                  back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Text(
                    'Chọn ảnh từ thư viện',
                    style: AppTextStyle.w600s15(ColorName.black000),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorName.grayC7c,
                ),
              ),
            ],
          )),
    );
  }

  void onTapCreate() {
    try {
      final fbs = formKey.formBuilderState!;
      final titleField = FormFieldType.title.field(fbs);
      final memoField = FormFieldType.memo.field(fbs);
      final passwordField =
          isPrivate.value ? FormFieldType.passwordCourse.field(fbs) : FormFieldType.imageCourse.field(fbs);

      if (isPrivate.value) {
        [
          titleField,
          memoField,
          passwordField,
        ].validateFormFields();
      } else {
        [
          titleField,
          memoField,
        ].validateFormFields();
      }

      _createCourseUsecase.execute(
        observer: Observer(
          onSubscribe: () {
            createState.onLoading();
            ignoringPointer.value = true;
            hideErrorMessage();
          },
          onSuccess: (course) async {
            print(course.toJsonView());
            if (course.id != null) {
              AwesomeDialog(
                context: Get.context!,
                dialogType: DialogType.success,
                title: "SUCCESS",
                desc: "Tạo mới khóa học thành công",
                descTextStyle: AppTextStyle.w600s17(ColorName.black000),
                btnOkText: 'Okay',
                btnOkOnPress: () {},
                onDismissCallback: (_) {
                  N.toCreateVocabulary(courseModel: course);
                },
              ).show();
            } else {
              _showToastMessage('Lỗi hệ thống');
            }
            ignoringPointer.value = false;
            createState.onSuccess();
          },
          onError: (e) {
            if (e is DioError) {
              if (e.response?.data != null) {
                try {
                  _showToastMessage(e.response!.data['message'].toString());
                } catch (e) {
                  _showToastMessage(e.toString());
                }
              } else {
                _showToastMessage(e.message ?? 'error');
              }
            }
            if (kDebugMode) {
              print(e.toString());
            }
            ignoringPointer.value = false;
            createState.onSuccess();
          },
        ),
        input: CreateCourseRequest(
          titleTextEditingController.text.trim(),
          memoTextEditingController.text.trim(),
          imageTextEditingController.text,
          int.parse(progress.value),
          passwordTextEditingController.text,
        ),
      );
    } catch (e) {
      isDisableButton.value = true;
    }
  }
}
