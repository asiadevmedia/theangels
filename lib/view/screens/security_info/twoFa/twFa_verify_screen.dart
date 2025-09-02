// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/rounded_button.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';

class TwFaVerifyScreen extends StatelessWidget {
  const TwFaVerifyScreen({super.key});

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
                "Once the authenticator app generates a conformation code, enter it below",
                style: regularDefault.copyWith(
                  color: MyColor.bodytextColor,
                  fontSize: Dimensions.fontMediumLarge - 1,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: Dimensions.space30,
              ),
              CustomTextField(
                labelText: "Enter code",
                hintText: "Enter the confirmation code",
                needOutlineBorder: true,
                onChanged: (val) {},
              ),
              const SizedBox(
                height: Dimensions.space40,
              ),
              RoundedButton(
                text: "Continue",
                press: () {
                  Get.toNamed(RouteHelper.twofaSuccessScreen);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
