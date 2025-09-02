import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  final Color textColor;
  const AppBarTitle({super.key, required this.text, this.textColor = MyColor.primaryTextColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      style: regularLarge.copyWith(color: textColor, fontWeight: FontWeight.w500),
    );
  }
}
