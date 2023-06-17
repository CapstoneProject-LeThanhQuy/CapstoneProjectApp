import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImagePage extends BaseWidget<PreviewImageController> {
  const PreviewImagePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      body: Center(
        child: controller.imagePreview.url != null
            ? CachedNetworkImage(
                imageUrl: controller.imagePreview.url ?? 'error',
                imageBuilder: (context, imageProvider) => PhotoView(
                  imageProvider: imageProvider,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                ),
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => emptyImage(),
              )
            : controller.imagePreview.urls != null
                ? _listImage(context)
                : emptyImage(),
      ),
    );
  }

  Widget _listImage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 15),
            const Icon(
              CupertinoIcons.checkmark_seal_fill,
              color: ColorName.black000,
              size: 25,
            ),
            const SizedBox(width: 5),
            Text(
              'Nhấn vào hình ảnh muốn lựa chọn',
              style: AppTextStyle.w700s20(ColorName.black000),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: controller.imagePreview.urls!.length,
            itemBuilder: (context, index) {
              return CupertinoButton(
                onPressed: () {
                  controller.selectImage(index);
                },
                child: CachedNetworkImage(
                  width: width,
                  imageUrl: controller.imagePreview.urls?[index] ?? 'error',
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => const SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => emptyImage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget emptyImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.images.logoIcon.image(width: 150, height: 150, fit: BoxFit.cover),
        const SizedBox(height: 15),
        Text(
          'Không tìm thấy hình ảnh',
          style: AppTextStyle.w600s20(ColorName.black000),
        ),
        const SizedBox(height: 10),
        Text(
          'Hình ảnh mặc định này sẽ được hiển thị',
          style: AppTextStyle.w400s14(ColorName.redEb5),
        ),
      ],
    );
  }
}
