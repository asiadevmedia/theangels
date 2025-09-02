import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/menu/my_menu_controller.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_danger_button.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';

class DisableAccountScreen extends StatelessWidget {
  const DisableAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(title: MyStrings.accountDelete, isTitleCenter: true),
      body: GetBuilder<MyMenuController>(builder: (controller) {
        return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: Dimensions.defaultPaddingHV,
            child: 1 == 0
                ? Column(
                    children: [
                      const SizedBox(height: Dimensions.space25),
                      Image.asset(MyImages.userdeleteImage, width: 120, height: 120, fit: BoxFit.cover),
                      const SizedBox(height: Dimensions.space25),
                      Text(
                        MyStrings.deleteYourAccount.tr,
                        style: mediumDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontOverLarge + 1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Dimensions.space25),
                      Text(
                        MyStrings.deleteBottomSheetSubtitle.tr,
                        style: regularDefault.copyWith(color: MyColor.colorGrey.withOpacity(0.8), fontSize: Dimensions.fontOverLarge + 1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        animatedLabel: false,
                        needOutlineBorder: true,
                        labelText: MyStrings.pin.tr,
                        controller: controller.passwordController,
                        focusNode: controller.passwordFocusNode,
                        onChanged: (value) {},
                        isShowSuffixIcon: true,
                        isPassword: true,
                        textInputType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyStrings.fieldErrorMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: Dimensions.space40),
                      Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: BoxDecoration(
                          color: MyColor.delteBtnColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            MyStrings.deleteAccount.tr,
                            style: mediumDefault.copyWith(color: MyColor.delteBtnTextColor, fontSize: Dimensions.fontExtraLarge + 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space10),
                      Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: BoxDecoration(
                          color: MyColor.colorGrey2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            MyStrings.cancel.tr,
                            style: mediumDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontExtraLarge + 1),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: context.height / 6),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              blurStyle: BlurStyle.outer,
                              color: MyColor.colorGrey.withOpacity(0.3),
                              offset: const Offset(1, 3),
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${MyStrings.deleteAccount.tr} ?",
                                    style: boldMediumLarge.copyWith(
                                      color: MyColor.colorRed,
                                    ),
                                  )
                                ],
                                text: MyStrings.areYouSureWantToDeleteAccount.tr,
                                style: regularMediumLarge,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Dimensions.space10),
                            const Text(MyStrings.enterYourPassword_, style: regularDefault),
                            const SizedBox(height: 2),
                            Text(
                              MyStrings.afterDeleteYouCanBack.tr,
                              style: mediumSmall.copyWith(color: MyColor.colorGrey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              animatedLabel: true,
                              needOutlineBorder: true,
                              labelText: MyStrings.pin.tr,
                              controller: controller.passwordController,
                              focusNode: controller.passwordFocusNode,
                              onChanged: (value) {},
                              isShowSuffixIcon: true,
                              isPassword: true,
                              textInputType: TextInputType.text,
                              inputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return MyStrings.fieldErrorMsg.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: Dimensions.space50),
                            GradientRoundedDangerButton(
                              showLoadingIcon: controller.removeLoading,
                              text: MyStrings.deleteAccount.tr,
                              press: () {},
                            ),
                            const SizedBox(height: Dimensions.space20),
                          ],
                        ),
                      ),
                    ],
                  ));
      }),
    );
  }
}
