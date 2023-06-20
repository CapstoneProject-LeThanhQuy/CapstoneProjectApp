import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/common_search.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/widgets/widget.dart';
import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
                              "Từ vựng được tìm kiếm",
                              style: AppTextStyle.w600s15(ColorName.black000),
                              textAlign: TextAlign.start,
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
          controller.onShowVocabulary(word);
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
}
