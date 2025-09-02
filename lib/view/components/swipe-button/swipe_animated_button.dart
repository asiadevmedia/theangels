// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/swipe-button/packages/swipeable_button_view.dart';

class SwipeAnimatedButton extends StatefulWidget {
  Function onFinish;
  Function onWaiting;

  SwipeAnimatedButton({super.key, required this.onFinish, required this.onWaiting});

  @override
  State<SwipeAnimatedButton> createState() => _SwipeAnimatedButtonState();
}

class _SwipeAnimatedButtonState extends State<SwipeAnimatedButton> {
  bool isWating = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.space8),
      child: Center(
        child: SwipeableButtonView(
          onFinish: () {
            setState(() {
              isWating = false;
            });
            widget.onFinish();
          },
          onWaitingProcess: () {
            setState(() {
              isWating = true;
            });
            widget.onWaiting();
          },
          buttontextstyle: regularDefault.copyWith(
            color: MyColor.primaryColor.withOpacity(0.7),
          ),
          indicatorColor: const AlwaysStoppedAnimation<Color>(MyColor.colorWhite),
          disableColor: MyColor.primaryColor,
          activeColor: isWating ? MyColor.primaryColor : MyColor.primaryColor.withOpacity(0.2),
          buttonColor: MyColor.primaryColor,
          buttonWidget: Container(
            padding: const EdgeInsets.all(Dimensions.space5),
            child: const CustomSvgPicture(image: MyImages.arrowRight, color: MyColor.colorWhite),
          ),
          buttonText: MyStrings.swipeRightToConfirm.tr,
          isTextAnimated: false,
          animatedTextColor: [
            MyColor.primaryColor,
            MyColor.primaryColor.withOpacity(0.6),
            MyColor.primaryColor.withOpacity(0.5),
            MyColor.primaryColor.withOpacity(0.4),
          ],
        ),
      ),
    );
  }
}
