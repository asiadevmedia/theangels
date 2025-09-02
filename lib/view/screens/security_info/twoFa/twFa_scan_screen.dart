// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/rounded_button.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class TwoFaScanScreen extends StatelessWidget {
  const TwoFaScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.colorWhite,
        appBar: CustomAppBar(
          title: "2FA Authentication",
          isTitleCenter: true,
          elevation: 0.09,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Dimensions.space10,
                ),
                Text(
                  "Scan the QR code below using supported authenticator app (such as Google Authenticator, Authy, 1Password etc)",
                  style: regularDefault.copyWith(
                    color: MyColor.bodytextColor,
                    fontSize: Dimensions.fontMediumLarge - 1,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: Dimensions.space40,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: CustomSvgPicture(
                    image: MyIcon.qrCode,
                    height: 150,
                    color: MyColor.colorBlack,
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space40,
                ),
                Text(
                  "Can’t scan the QR Code? Enter this code into your authenticator app instead:",
                  style: regularDefault.copyWith(
                    color: MyColor.bodytextColor,
                    fontSize: Dimensions.fontMediumLarge - 1,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: Dimensions.space40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "dsf4sad5dgfvre5".toUpperCase(),
                    style: boldLarge.copyWith(
                      color: MyColor.bodytextColor,
                      fontSize: Dimensions.fontExtraLarge + 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Copy",
                      style: semiBoldDefault.copyWith(
                        color: MyColor.primaryColor,
                        fontSize: Dimensions.fontMediumLarge - 1,
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.space5,
                    ),
                    const CustomSvgPicture(image: MyIcon.copy)
                  ],
                ),
                const SizedBox(
                  height: Dimensions.space50,
                ),
                RoundedButton(
                  text: "Enter confirmation code",
                  press: () {
                    Get.toNamed(RouteHelper.twofaVerifyScreen);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
