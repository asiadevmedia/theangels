import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:viserpay/core/utils/my_animation.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';

class NoDataWidget extends StatelessWidget {
  final double margin;
  final bool isAlignmentCenter;
  final String? noDataText;
  const NoDataWidget({super.key, this.isAlignmentCenter = true, this.margin = 4, this.noDataText});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isAlignmentCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Lottie.asset(MyAnimation.noData, height: 150, width: 150, repeat: false),
          SizedBox(height: margin),
          Text(
            noDataText ?? MyStrings.noDataFound.tr,
            style: regularLarge.copyWith(color: MyColor.getTextColor()),
          )
        ],
      ),
    );
  }
}
