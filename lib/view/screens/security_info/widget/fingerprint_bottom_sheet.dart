import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/auth/biometric/biometric_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';

class FingerPrintBottomsheet extends StatelessWidget {
  const FingerPrintBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BioMetricController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetBar(),
          const SizedBox(height: Dimensions.space10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MyStrings.setupYourFingerPrint.tr,
                style: title.copyWith(fontSize: Dimensions.fontExtraLarge),
              ),
              const BottomSheetCloseButton()
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Text(MyStrings.fingerPrintSubtitleMsg.tr, style: regularDefault.copyWith()),
          const SizedBox(height: Dimensions.space15),
          CustomPinField(
            animatedLabel: false,
            needOutlineBorder: true,
            labelText: "",
            hintText: MyStrings.enterYourPINCode.tr,
            controller: controller.passwordController,
            onChanged: (value) {},
            isShowSuffixIcon: true,
            isPassword: true,
            textInputType: TextInputType.phone,
            inputAction: TextInputAction.go,
            onSubmit: () {},
            validator: (value) {
              if (value!.isEmpty) {
                return MyStrings.fieldErrorMsg.tr;
              } else {
                return null;
              }
            },
            radius: Dimensions.mediumRadius,
          ),
          const SizedBox(height: Dimensions.space50),
          GradientRoundedButton(
            showLoadingIcon: controller.isBioloading,
            text: MyStrings.enablefingerPrint,
            press: () {
              if (controller.passwordController.text.isNotEmpty && MyUtils().validatePinCode(controller.passwordController.toString()) && controller.isDisable == false) {
                controller.enableFingerPrint();
              }
            },
          ),
          const SizedBox(height: 25),
          Text(
            controller.isPermantlyLocked
                ? MyStrings.permantlyLockedPleaselockyourPhoneandTryagain.tr
                : controller.isDisable
                    ? "${MyStrings.pleaseTryagainAfter.tr}${controller.countdownSeconds}s  ${MyStrings.later.tr}"
                    : '',
            style: regularDefault.copyWith(color: MyColor.redCancelTextColor),
            textAlign: TextAlign.center,
          ),
          controller.isDisable ? const SizedBox.shrink() : const SizedBox(height: 15),
        ],
      );
    });
  }
}
