import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';

class ShowMoreText extends StatelessWidget {
  final String text;
  final Callback onTap;
  const ShowMoreText({super.key, required this.onTap, this.text = MyStrings.showMore});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text.tr,
        style: semiBoldDefault.copyWith(color: MyColor.getPrimaryColor(), decoration: TextDecoration.underline),
      ),
    );
  }
}
