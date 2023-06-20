import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/home/data/models/target.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'widget.g.dart';

@swidget
Widget targetItem({required Target target, required Function() onPressed}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: ColorName.whiteFaf,
      boxShadow: [
        BoxShadow(
          color: ColorName.black333.withOpacity(0.45),
          blurRadius: 15.0,
          offset: const Offset(5, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: ColorName.orangeDdb.withOpacity(0.2),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onPressed.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: ColorName.black000),
                      ),
                      child: Text(
                        'Chỉnh sửa mục tiêu',
                        style: AppTextStyle.w500s13(ColorName.primaryColor, letterSpacing: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: ColorName.orangeDdb.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            value: (target.learnedWords + target.newWords) / target.targetWord,
                            color: ColorName.primaryColor.withOpacity(0.8),
                            semanticsLabel: 'Linear progress indicator',
                          ),
                        ),
                        Center(
                          child: Text(
                            '${target.consecutiveDays}',
                            style: AppTextStyle.w700s16(ColorName.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày liên tục',
                        style: AppTextStyle.w700s17(ColorName.primaryColor),
                      ),
                      Text(
                        'Kỷ lục học dài nhất: ${target.record} ngày',
                        style: AppTextStyle.w500s14(ColorName.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            color: ColorName.orangeDdb.withOpacity(0.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
                child: Text(
                  'Hôm nay tính tới thời điển hiện tại',
                  style: AppTextStyle.w500s14(ColorName.primaryColor),
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Text(
                        '${target.learnedWords}\ntừ đã ôn tập',
                        style: AppTextStyle.w500s14(ColorName.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const VerticalDivider(
                      color: ColorName.primaryColor,
                      thickness: 2,
                    ),
                    Flexible(
                      child: Text(
                        '${target.newWords}\ntừ mới',
                        style: AppTextStyle.w500s14(ColorName.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const VerticalDivider(
                      color: ColorName.primaryColor,
                      thickness: 2,
                    ),
                    Flexible(
                      child: Text(
                        '${target.time}\nphút đã học',
                        style: AppTextStyle.w500s14(ColorName.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ),
  );
}
