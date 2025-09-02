import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';

class TitleCard extends StatelessWidget {
  final Widget widget;

  final String title;
  final TextStyle? titleStyle;
  final bool? onlyTop;
  final bool onlyBottom;
  const TitleCard({super.key, required this.title, required this.widget, this.titleStyle, this.onlyTop = false, this.onlyBottom = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: MyColor.borderColor,
          width: 0.6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.space10),
            child: Text(
              title.tr,
              style: titleStyle ?? boldDefault,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CustomDivider(
            space: Dimensions.space10,
            onlyTop: onlyTop,
            onlybottom: onlyBottom,
          ),
          widget,
        ],
      ),
    );
  }
}
