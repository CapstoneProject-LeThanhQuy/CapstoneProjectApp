import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/common_search.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/presentation/controller/create_vocabulary/create_vocabulary_controller.dart';
import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/simpletreeview/lib/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:photo_view/photo_view.dart';

class CreateVocabularyPage extends BaseWidget<CreateVocabularyController> {
  const CreateVocabularyPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.hideKeyboard();
        controller.isSearching.value = false;
      },
      child: Obx(() {
        return Stack(
          children: [
            Positioned.fill(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: BaseAppBar(
                  title: const Text('Chỉnh sửa khóa học'),
                  actions: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      onPressed: () {
                        controller.saveCourse();
                      },
                      child: Center(
                        child: Text(
                          'Lưu',
                          style: AppTextStyle.w600s15(ColorName.whiteFaf),
                        ),
                      ),
                    )
                  ],
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
                              physics: const ClampingScrollPhysics(),
                              controller: controller.scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
                                child: FormBuilder(
                                  key: controller.formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Khóa học:',
                                            style: AppTextStyle.w600s20(ColorName.black000),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            controller.course?.publicId ?? '',
                                            style: AppTextStyle.w600s17(ColorName.green27b),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 25),
                                      CommonTextField(
                                        formKey: controller.formKey,
                                        type: FormFieldType.title,
                                        textInputAction: TextInputAction.next,
                                        controller: controller.titleTextEditingController,
                                      ),
                                      const SizedBox(height: 10),
                                      CommonTextField(
                                        formKey: controller.formKey,
                                        height: 108,
                                        maxLines: 10,
                                        type: FormFieldType.memo,
                                        textInputAction: TextInputAction.newline,
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
                                                  selectedItem: controller.progress.value,
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
                                        suffixIcon: const Icon(
                                          CupertinoIcons.camera_on_rectangle_fill,
                                          color: ColorName.primaryColor,
                                        ),
                                        onPressedSuffixIcon: () {
                                          controller.pickImage(context);
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
                                                    type: FormFieldType.passwordCourse,
                                                    textInputAction: TextInputAction.next,
                                                    obscureText: controller.isShowPassword.value,
                                                    suffixIcon: controller.isShowPassword.value
                                                        ? Assets.images.showPassIcon.image(scale: 4)
                                                        : Assets.images.hidePassIcon.image(scale: 4),
                                                    onPressedSuffixIcon: controller.onTapShowPassword,
                                                    controller: controller.passwordTextEditingController,
                                                  )
                                                : const SizedBox(),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 25),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Từ vựng',
                                            style: AppTextStyle.w600s20(ColorName.black000),
                                          ),
                                          const Spacer(),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              controller.onSearch(' ');
                                              controller.onSearch('');
                                              controller.scrolltoBottom();
                                            },
                                            child: const Icon(
                                              CupertinoIcons.arrow_2_circlepath_circle_fill,
                                              size: 30,
                                              color: ColorName.primaryColor,
                                            ),
                                          ),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              if (!controller.isSearching.value) {
                                                controller.onSearch('');
                                                controller.scrolltoBottom();
                                                controller.isSearching.value = true;
                                              }
                                            },
                                            child: const Icon(
                                              CupertinoIcons.search_circle_fill,
                                              size: 30,
                                              color: ColorName.primaryColor,
                                            ),
                                          ),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              controller.titleCourseLevelTextEditingController.text = '';
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ),
                                                builder: (context) => _addCourseLevel(context),
                                              );
                                            },
                                            child: const Icon(
                                              CupertinoIcons.add_circled_solid,
                                              size: 30,
                                              color: ColorName.primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Obx(
                                        () => _buildSimpleTreeView(context),
                                      ),
                                      const SizedBox(height: 35),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () {
                              return controller.isSearching.value
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      width: double.infinity,
                                      child: SearchCommon(
                                        autofocus: true,
                                        onChange: (value) {
                                          controller.onSearch(value);
                                        },
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
        );
      }),
    );
  }

  Widget _buildSimpleTreeView(BuildContext context) {
    return TreeView(
      treeController: controller.treeController,
      indent: 10,
      nodes: controller.listCourseLevelView.map(
        (courseLevel) {
          return TreeNode(
            color: controller.genColorTree(courseLevel.typeUpdate),
            content: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (courseLevel.typeUpdate != TypeUpdate.isDelete) {
                  controller.titleCourseLevelTextEditingController.text = courseLevel.title;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    builder: (context) => _addCourseLevel(
                      context,
                      isAddCourse: false,
                      courseLevel: courseLevel,
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            courseLevel.title,
                            maxLines: 10,
                            overflow: TextOverflow.visible,
                            style: AppTextStyle.w700s18(ColorName.black000),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.book_solid,
                                size: 18,
                                color: ColorName.primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${courseLevel.totalWords}',
                                style: AppTextStyle.w500s16(ColorName.gray4f4),
                              ),
                              const SizedBox(width: 15),
                              const Icon(
                                CupertinoIcons.drop_fill,
                                size: 18,
                                color: ColorName.primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${courseLevel.level}',
                                style: AppTextStyle.w500s16(ColorName.gray4f4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (courseLevel.typeUpdate == TypeUpdate.isDelete || courseLevel.typeUpdate == TypeUpdate.isUpdate)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.rollBackCourseLevel(courseLevel);
                        },
                        child: const Icon(
                          CupertinoIcons.return_icon,
                          size: 25,
                          color: ColorName.primaryColor,
                        ),
                      ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.deleteCourseLevel(courseLevel);
                      },
                      child: const Icon(
                        CupertinoIcons.delete_solid,
                        size: 25,
                        color: ColorName.primaryColor,
                      ),
                    ),
                    if (courseLevel.typeUpdate != TypeUpdate.isDelete)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.isExactSearch.value = false;
                          controller.maxWord.value = '5';
                          controller.wordType.value = 'Noun';
                          controller.urlOrDocVocabularyTextEditingController.text = '';
                          controller.englishTextEditingController.text = '';
                          controller.vietnameseTextEditingController.text = '';
                          controller.imageVocabularyTextEditingController.text = '';
                          controller.isAutoCreate.value = false;
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            builder: (context) => _addVocabulary(
                              context,
                              isAddVocabulary: true,
                              courseLevel: courseLevel,
                            ),
                          );
                        },
                        child: const Icon(
                          CupertinoIcons.add_circled_solid,
                          size: 25,
                          color: ColorName.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            children: courseLevel.vocabularies?.map(
              (vocabulary) {
                return TreeNode(
                  color: controller.genColorTree(vocabulary.typeUpdate),
                  content: _buildItem(vocabulary, courseLevel, context),
                );
              },
            ).toList(),
          );
        },
      ).toList(),
    );
  }

  Widget _buildItem(Vocabulary vocabulary, CourseLevel courseLevel, BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(15),
      onPressed: () {
        if (vocabulary.typeUpdate != TypeUpdate.isDelete) {
          controller.wordType.value = vocabulary.wordType;
          controller.englishTextEditingController.text = vocabulary.englishText;
          controller.vietnameseTextEditingController.text = vocabulary.vietnameseText;
          controller.imageVocabularyTextEditingController.text = vocabulary.image;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            builder: (context) => _addVocabulary(
              context,
              isAddVocabulary: false,
              courseLevel: courseLevel,
              vocabulary: vocabulary,
            ),
          );
        }
      },
      child: Row(
        children: [
          vocabulary.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: vocabulary.image,
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Assets.images.logoIcon.image(width: 75, height: 75, fit: BoxFit.cover),
                )
              : Assets.images.logoIcon.image(width: 75, height: 75, fit: BoxFit.cover),
          const SizedBox(width: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocabulary.englishText,
                  style: AppTextStyle.w700s18(ColorName.black000),
                ),
                Text(
                  '[${vocabulary.wordType}]',
                  style: AppTextStyle.w700s18(ColorName.green27b),
                ),
                Text(
                  vocabulary.vietnameseText,
                  style: AppTextStyle.w500s16(ColorName.gray838),
                ),
              ],
            ),
          ),
          const Spacer(),
          if ((vocabulary.typeUpdate == TypeUpdate.isDelete || vocabulary.typeUpdate == TypeUpdate.isUpdate) &&
              courseLevel.typeUpdate != TypeUpdate.isDelete)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                controller.rollBackVocabulary(courseLevel, vocabulary);
              },
              child: const Icon(
                CupertinoIcons.return_icon,
                size: 25,
                color: ColorName.primaryColor,
              ),
            ),
          if (courseLevel.typeUpdate != TypeUpdate.isDelete)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                controller.deleteVocabulary(courseLevel, vocabulary);
              },
              child: const Icon(
                CupertinoIcons.delete_solid,
                size: 25,
                color: ColorName.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _addCourseLevel(
    BuildContext context, {
    bool isAddCourse = true,
    CourseLevel? courseLevel,
  }) {
    controller.genListCourseLevelDifficult(isAddCourse, courseLevel: courseLevel);
    return GestureDetector(
      onTap: () {
        controller.hideKeyboard();
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 15),
                child: Text(
                  isAddCourse ? 'Thêm mới danh mục' : 'Chỉnh sửa danh mục',
                  style: AppTextStyle.w600s17(
                    ColorName.black000,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              CommonTextField(
                type: FormFieldType.title,
                textInputAction: TextInputAction.done,
                controller: controller.titleCourseLevelTextEditingController,
              ),
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Độ khó:",
                        style: AppTextStyle.w600s16(ColorName.black000),
                      ),
                      Text(
                        "Mức độ so với các danh mục khác",
                        style: AppTextStyle.w400s14(ColorName.black000),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (item) {
                          return item.contains('[');
                        },
                      ),
                      items: controller.listCourseLevelDifficult,
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
                          controller.difflcultLevel.value = value;
                        }
                      },
                      selectedItem: controller.defaultDifflcultLevel.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
                color: Colors.transparent,
                child: CommonButton(
                  height: 50,
                  onPressed: () {
                    if (isAddCourse) {
                      controller.addCourseLevel();
                    } else {
                      controller.updateCourseLevel(courseLevel);
                    }
                  },
                  fillColor: ColorName.primaryColor,
                  child: Text(
                    'Hoàn thành',
                    style: AppTextStyle.w700s18(ColorName.whiteFff),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addVocabulary(
    BuildContext context, {
    bool isAddVocabulary = true,
    CourseLevel? courseLevel,
    Vocabulary? vocabulary,
  }) {
    if (!isAddVocabulary) {
      controller.isAutoCreate.value = false;
    }
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        if (isAddVocabulary)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                "Tạo từ vựng tự động",
                                style: AppTextStyle.w600s16(ColorName.black000),
                              ),
                              const SizedBox(width: 15),
                              FlutterSwitch(
                                width: 60.0,
                                height: 30.0,
                                valueFontSize: 12.0,
                                toggleSize: 12.0,
                                value: controller.isAutoCreate.value,
                                borderRadius: 20.0,
                                padding: 8.0,
                                activeColor: ColorName.green459,
                                inactiveColor: ColorName.grayC7c,
                                activeText: '',
                                inactiveText: '',
                                showOnOff: true,
                                onToggle: (val) {
                                  controller.hideKeyboard();
                                  controller.isAutoCreate.value = val;
                                },
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        if (!controller.isAutoCreate.value)
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
                                        isAddVocabulary ? 'Thêm mới từ vựng' : 'Chỉnh sửa từ vựng',
                                        style: AppTextStyle.w600s17(
                                          ColorName.black000,
                                        ),
                                      ),
                                      Text(
                                        courseLevel?.title ?? '',
                                        style: AppTextStyle.w700s18(
                                          ColorName.green459,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                CommonTextField(
                                  type: FormFieldType.englishText,
                                  textInputAction: TextInputAction.next,
                                  controller: controller.englishTextEditingController,
                                ),
                                CommonTextField(
                                  type: FormFieldType.vietnameseText,
                                  textInputAction: TextInputAction.next,
                                  controller: controller.vietnameseTextEditingController,
                                ),
                                CommonTextField(
                                  formKey: controller.formKey,
                                  type: FormFieldType.imageVocabulary,
                                  textInputAction: TextInputAction.done,
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerRight,
                                        onPressed: () {
                                          controller.findImage();
                                        },
                                        child: const Icon(
                                          Icons.image_search,
                                          color: ColorName.primaryColor,
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerRight,
                                        onPressed: () {
                                          controller.previewImage(
                                            ImagePreviewitem(url: controller.imageVocabularyTextEditingController.text),
                                          );
                                        },
                                        child: const Icon(
                                          CupertinoIcons.arrow_up_left_arrow_down_right,
                                          color: ColorName.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                  controller: controller.imageVocabularyTextEditingController,
                                  onSubmitted: (p0) {},
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Từ loại:",
                                      style: AppTextStyle.w600s16(ColorName.black000),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        popupProps: const PopupProps.menu(
                                          showSelectedItems: true,
                                        ),
                                        items: AppConfig.listTypeWord,
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
                                            controller.wordType.value = value;
                                          }
                                        },
                                        selectedItem: controller.wordType.value,
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
                                      if (isAddVocabulary) {
                                        controller.addVocabulary(courseLevel);
                                      } else {
                                        controller.updateVocabulary(courseLevel, vocabulary);
                                      }
                                    },
                                    fillColor: ColorName.primaryColor,
                                    child: Text(
                                      'Hoàn thành',
                                      style: AppTextStyle.w700s18(ColorName.whiteFff),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.isAutoCreate.value)
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
                                        isAddVocabulary ? 'Thêm mới từ vựng' : 'Chỉnh sửa từ vựng',
                                        style: AppTextStyle.w600s17(
                                          ColorName.black000,
                                        ),
                                      ),
                                      Text(
                                        courseLevel?.title ?? '',
                                        style: AppTextStyle.w700s18(
                                          ColorName.green459,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                CommonTextField(
                                  formKey: controller.formKey,
                                  height: 108,
                                  maxLines: 10,
                                  type: FormFieldType.addAutoVocabulary,
                                  textInputAction: TextInputAction.newline,
                                  controller: controller.urlOrDocVocabularyTextEditingController,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "Số lượng từ tối đa muốn tìm kiếm:",
                                      style: AppTextStyle.w600s16(ColorName.black000),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        popupProps: const PopupProps.menu(
                                          showSelectedItems: true,
                                        ),
                                        items: AppConfig.listMaxWords,
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
                                            if (value == '50' || value == '100') {
                                              controller.showWarning();
                                            }
                                            controller.maxWord.value = value;
                                          }
                                        },
                                        selectedItem: controller.maxWord.value,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Tìm kiếm nâng cao",
                                      style: AppTextStyle.w600s16(ColorName.black000),
                                    ),
                                    const SizedBox(width: 15),
                                    FlutterSwitch(
                                      width: 60.0,
                                      height: 30.0,
                                      valueFontSize: 12.0,
                                      toggleSize: 12.0,
                                      value: controller.isExactSearch.value,
                                      borderRadius: 20.0,
                                      padding: 8.0,
                                      activeColor: ColorName.green459,
                                      inactiveColor: ColorName.grayC7c,
                                      activeText: '',
                                      inactiveText: '',
                                      showOnOff: true,
                                      onToggle: (val) {
                                        controller.hideKeyboard();
                                        if (val) {
                                          controller.showWarning();
                                        }
                                        controller.isExactSearch.value = val;
                                      },
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
                                  color: Colors.transparent,
                                  child: CommonButton(
                                    height: 50,
                                    onPressed: () {
                                      if (isAddVocabulary) {
                                        controller.addVocabulary(courseLevel);
                                      }
                                    },
                                    fillColor: ColorName.primaryColor,
                                    child: Text(
                                      'Hoàn thành',
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
