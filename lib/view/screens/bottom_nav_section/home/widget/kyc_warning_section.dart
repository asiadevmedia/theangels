import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';

import '../../../../../core/route/route.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/style.dart';

class KYCWarningSection extends StatelessWidget {
  const KYCWarningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Visibility(
        visible: !controller.isKycVerified && !controller.isLoading,
        child: InkWell(
          splashColor: MyColor.primaryColor.withOpacity(0.2),
          onTap: () {
            Get.toNamed(RouteHelper.kycScreen);
            // if (controller.isKycPending == false) {
            // } else {
            //   Get.toNamed(RouteHelper.kycScreen);
            // }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              left: Dimensions.space15,
              right: Dimensions.space15,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.space10,
              vertical: Dimensions.space8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
              color: MyColor.redCancelTextColor.withOpacity(.1),
              border: Border.all(color: MyColor.redCancelTextColor, width: .5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.isKycPending ? MyStrings.kycUnderReviewMsg.tr : MyStrings.kycVerificationRequired.tr,
                      style: semiBoldDefault.copyWith(color: MyColor.redCancelTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.space5),
                Text(
                  controller.isKycPending ? MyStrings.kycPendingMsg.tr : MyStrings.kycVerificationMsg.tr,
                  style: regularDefault.copyWith(fontSize: Dimensions.fontExtraSmall, color: MyColor.redCancelTextColor),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
