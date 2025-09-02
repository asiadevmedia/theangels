import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/auth/auth/registration_controller.dart';

import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';

class RegistrationPinWidget extends StatefulWidget {
  const RegistrationPinWidget({super.key});

  @override
  State<RegistrationPinWidget> createState() => _RegistrationPinWidgetState();
}

class _RegistrationPinWidgetState extends State<RegistrationPinWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
        builder: (controller) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Focus(
                        onFocusChange: (hasFocus) {
                          // controller.changePasswordFocus(hasFocus);
                        },
                        child: CustomPinField(
                          radius: 10,
                          shadowBox: true,
                          needOutlineBorder: true,
                          animatedLabel: true,
                          isShowSuffixIcon: true,
                          isPassword: true,
                          labelText: MyStrings.enterYourPIN.tr,
                          controller: controller.passwordController,
                          focusNode: controller.passwordFocusNode,
                          nextFocus: controller.confirmPasswordFocusNode,
                          hintText: MyStrings.enterYourPassword_.tr,
                          textInputType: TextInputType.phone,
                          onChanged: (value) {},
                          validator: (value) {
                            return controller.validatePassword(value ?? '');
                          },
                        )),
                    const SizedBox(height: Dimensions.space15),
                    CustomPinField(
                      radius: 10,
                      shadowBox: true,
                      needOutlineBorder: true,
                      animatedLabel: true,
                      labelText: MyStrings.confirmYourPassword.tr,
                      hintText: MyStrings.confirmYourPassword.tr,
                      controller: controller.cPasswordController,
                      focusNode: controller.confirmPasswordFocusNode,
                      inputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                      isShowSuffixIcon: true,
                      isPassword: true,
                      onChanged: (value) {},
                      validator: (value) {
                        if (controller.passwordController.text.toLowerCase() != controller.cPasswordController.text.toLowerCase()) {
                          return MyStrings.kMatchPassError.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: Dimensions.space50),
                    GradientRoundedButton(
                        textColor: MyColor.getPrimaryButtonTextColor(),
                        text: MyStrings.continue_.tr,
                        press: () {
                          if (formKey.currentState!.validate()) {
                            controller.changeIndex(controller.currentStep + 1);
                          }
                        }),
                  ],
                ),
              ),
            ));
  }
}
