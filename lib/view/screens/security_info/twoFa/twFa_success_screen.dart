// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class TwoFaSuccessScreen extends StatelessWidget {
  const TwoFaSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      body: Padding(
        padding: Dimensions.defaultPaddingHV,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomSvgPicture(
                    image: MyIcon.successCircle,
                    height: 200,
                    color: MyColor.colorGreen,
                  ),
                  Text(
                    "2FA Enable",
                    style: boldLarge.copyWith(fontSize: 24),
                  ),
                  const Text(
                    "We’ll ask for a code anytime you want to \nwithdraw funds in the future",
                    style: regularDefault,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.bottomNavBar);
                },
                child: Text(
                  "Tap anywhere to continue",
                  style: boldLarge.copyWith(color: MyColor.primaryColor, fontSize: Dimensions.fontExtraLarge + 1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
