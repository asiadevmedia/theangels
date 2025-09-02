import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';

class ContactRequestWidget extends StatelessWidget {
  const ContactRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: Dimensions.space50),
        // Center(child: Text(" to get your contact list here")),
        Center(
          child: RichText(
            text: TextSpan(
              text: MyStrings.contactPermissonTitle.tr,
              children: [
                TextSpan(
                  text: MyStrings.appSettings.tr,
                  style: boldDefault.copyWith(color: MyColor.pendingColor, decoration: TextDecoration.underline, decorationColor: MyColor.pendingColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      openAppSettings();
                    },
                ),
                TextSpan(text: " ${MyStrings.contactPermissonSubText.tr}", style: regularDefault.copyWith())
              ],
              style: regularDefault.copyWith(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
