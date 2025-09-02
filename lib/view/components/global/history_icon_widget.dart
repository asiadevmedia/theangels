// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class HistoryWidget extends StatelessWidget {
  String routeName;
  HistoryWidget({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColor.primaryColor.withOpacity(.1),
        ),
        child: const CustomSvgPicture(
          image: MyIcon.history,
          height: 15,
          width: 15,
        ),
      ),
    );
  }
}
