import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/home/presentation/controller/vocabulary_detail/vocabulary_detail_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VocabularyDetailPage extends BaseWidget<VocabularyDetailController> {
  const VocabularyDetailPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      body: Container(
        color: ColorName.whiteFff,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.speechText();
                      },
                      child: const Icon(
                        CupertinoIcons.speaker_3_fill,
                        color: ColorName.primaryColor,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                controller.vocabulary?.englishText ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.w600s30(ColorName.primaryColor),
              ),
              const SizedBox(height: 25),
              (controller.vocabulary?.image ?? '').isNotEmpty
                  ? CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: controller.vocabulary?.image ?? '',
                      fit: BoxFit.cover,
                      maxHeightDiskCache: 300,
                      placeholder: (context, url) => const SizedBox(
                        height: 120,
                        width: 120,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                    )
                  : Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
              const SizedBox(height: 55),
              const Divider(
                height: 1,
                color: ColorName.primaryColor,
                thickness: 1,
              ),
              const SizedBox(height: 25),
              Text(
                'NGHĨA',
                textAlign: TextAlign.center,
                style: AppTextStyle.w500s12(ColorName.gray838),
              ),
              const SizedBox(height: 5),
              Text(
                controller.vocabulary?.vietnameseText ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.w700s20(ColorName.gray4f4),
              ),
              Text(
                '[${controller.vocabulary?.wordType}]',
                textAlign: TextAlign.center,
                style: AppTextStyle.w700s20(ColorName.green27b),
              ),
              const SizedBox(height: 55),
            ],
          ),
        ),
      ),
    );
  }
}
