import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/common_search.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/widgets/widget.dart';
import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GamePage extends BaseWidget<GameController> {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.hideKeyboard();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: BaseAppBar(
            leadingWidth: controller.isSearching.value ? 0 : 300,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Từ vựng của tôi',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.w600s17(ColorName.whiteFff),
                  ),
                ],
              ),
            ),
            title: AnimatedSize(
              alignment: Alignment.centerLeft,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 400),
              child: controller.isSearching.value ? _searchWidget() : const SizedBox.shrink(),
            ),
            actions: [
              controller.isSearching.value
                  ? CupertinoButton(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.searchResult.value = [];
                        controller.searchResult.refresh();
                        controller.hideKeyboard();
                        controller.isSearching.value = false;
                      },
                      child: Text(
                        'Hủy',
                        style: AppTextStyle.w600s15(ColorName.whiteFaf),
                      ))
                  : CupertinoButton(
                      onPressed: () {
                        controller.searchResult.value = [];
                        controller.searchResult.refresh();
                        controller.isSearching.value = true;
                      },
                      child: const Icon(
                        CupertinoIcons.search,
                        color: ColorName.whiteFff,
                      ),
                    )
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
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
                      children: [
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
                                "Điểm: ${AppConfig.currenPoint.value}",
                                style: AppTextStyle.w700s16(ColorName.black000),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Thành tích cao nhất: ${AppConfig.bestScore.value}",
                                style: AppTextStyle.w700s16(ColorName.black000),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.transparent,
                          child: CommonButton(
                            height: 50,
                            onPressed: () {
                              controller.playVideoGame();
                            },
                            fillColor: ColorName.primaryColor,
                            child: Text(
                              'Bắt đầu trò chơi',
                              style: AppTextStyle.w700s18(ColorName.whiteFff),
                            ),
                          ),
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
                              Row(
                                children: [
                                  Text(
                                    "Từ vựng được tìm kiếm",
                                    style: AppTextStyle.w600s15(ColorName.black000),
                                    textAlign: TextAlign.start,
                                  ),
                                  const Spacer(),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      controller.removeWord();
                                    },
                                    child: const Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 25,
                                      color: ColorName.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        controller.vocabulariesSearch.isEmpty
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Không có từ vựng nào',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.w600s15(ColorName.black000),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 20, top: 20),
                                itemCount: controller.vocabulariesSearch.length,
                                itemBuilder: (context, index) {
                                  return CourseVocabularyItem(
                                    vocabulary: controller.vocabulariesSearch[index],
                                    onPressed: () {
                                      N.toVocabularyDetail(vocabulary: controller.vocabulariesSearch[index]);
                                    },
                                  );
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
                                "Từ vựng các khóa học",
                                style: AppTextStyle.w600s15(ColorName.black000),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        controller.vocabularies.isEmpty
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Không có từ vựng nào',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.w600s15(ColorName.black000),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 20, top: 20),
                                itemCount: controller.vocabularies.length,
                                itemBuilder: (context, index) {
                                  return CourseVocabularyItem(
                                    vocabulary: controller.vocabularies[index],
                                    onPressed: () {
                                      N.toVocabularyDetail(vocabulary: controller.vocabularies[index]);
                                    },
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isSearching.value)
                Positioned.fill(
                  child: Container(
                    color: ColorName.whiteFaf,
                    child: controller.searchResult.isEmpty
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Text(
                                  'Không có từ vựng nào',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.w600s15(ColorName.black000),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 25),
                            shrinkWrap: true,
                            itemCount: controller.searchResult.length,
                            itemBuilder: (context, index) {
                              return resultSearchItem(controller.searchResult[index]);
                            },
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
          ),
        ),
      ),
    );
  }

  Widget resultSearchItem(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: ColorName.black000,
          ),
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        onPressed: () {
          controller.hideKeyboard();
          controller.isSearching.value = false;
          controller.getVocabulary(word);
          showModalBottomSheet(
            context: Get.context!,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
            ),
            builder: (context) => _searchWordWidget(word, context),
          );
        },
        child: Text(
          word,
          style: AppTextStyle.w500s15(ColorName.black000),
        ),
      ),
    );
  }

  Widget _searchWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: SearchCommon(
        autofocus: true,
        onChange: (value) {
          controller.onSearchVocabulary(value);
        },
      ),
    );
  }

  Widget _searchWordWidget(String key, BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          GestureDetector(
            onTap: () {
              controller.hideKeyboard();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
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
                            'Thêm mới từ vựng',
                            style: AppTextStyle.w600s17(
                              ColorName.black000,
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
                          controller.addVocabulary();
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
      ),
    );
  }
}
