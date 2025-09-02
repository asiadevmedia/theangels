// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';

import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class DrawerItem extends StatelessWidget {
  String svgIcon, name;
  Color? iconColor;
  TextStyle? titleStyle;
  VoidCallback ontap;
  DrawerItem({super.key, required this.svgIcon, required this.name, required this.ontap, this.iconColor, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          CustomSvgPicture(
            image: svgIcon,
            color: iconColor ?? MyColor.colorBlack,
            height: 24,
          ),
          const SizedBox(
            width: Dimensions.space8,
          ),
          Text(
            name.tr,
            style: titleStyle ?? regularDefault.copyWith(fontSize: Dimensions.fontLarge),
          ),
        ],
      ),
    );
  }
}
