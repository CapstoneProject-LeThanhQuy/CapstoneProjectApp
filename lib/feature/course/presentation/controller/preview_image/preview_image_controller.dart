import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/controller/create_vocabulary/create_vocabulary_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PreviewImageController extends BaseController<ImagePreviewitem> {
  ImagePreviewitem imagePreview = ImagePreviewitem();

  @override
  void onInit() {
    super.onInit();
    imagePreview = input;
  }

  @override
  void onClose() async {
    super.onClose();
    await CachedNetworkImage.evictFromCache(imagePreview.url ?? '');
    for (var element in imagePreview.urls ?? []) {
      await CachedNetworkImage.evictFromCache(element ?? '');
    }
  }

  void selectImage(int index) {
    var createVocabularyController = Get.find<CreateVocabularyController>();
    createVocabularyController.setImageVocabulary(imagePreview.urls?[index] ?? '');
    Get.back();
  }
}

class ImagePreviewitem {
  String? url;
  XFile? file;
  List<String>? urls;

  ImagePreviewitem({this.url, this.file, this.urls});
}
