import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/auth/forget_password/reset_password_controller.dart';
import 'package:viserpay/data/repo/auth/login_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';
import 'package:viserpay/view/components/text/default_text.dart';
import 'package:viserpay/view/components/will_pop_widget.dart';
import 'package:viserpay/view/screens/auth/registration/widget/validation_widget.dart';

import '../../../../components/app-bar/custom_appbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    final controller = Get.put(ResetPasswordController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.email = Get.arguments[0];
      controller.code = Get.arguments[1];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.forgotPasswordScreen,
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(isWhite: true),
        appBar: CustomAppBar(title: MyStrings.resetYourPin, fromAuth: true, bgColor: MyColor.getAppBarColor()),
        body: GetBuilder<ResetPasswordController>(
          builder: (controller) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: Dimensions.screenPaddingHV,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.space30),
                  /* HeaderText(text: MyStrings.resetYourPin.tr),
                  const SizedBox(height: Dimensions.space5),*/
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width * .15),
                    child: DefaultText(
                      text: MyStrings.resetPassContent.tr,
                      textStyle: regularDefault.copyWith(color: MyColor.getTextColor().withOpacity(0.8)),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: Dimensions.space40),
                  Focus(
                    onFocusChange: (hasFocus) {
                      controller.changePasswordFocus(hasFocus);
                    },
                    child: CustomPinField(
                        animatedLabel: true,
                        needOutlineBorder: true,
                        focusNode: controller.passwordFocusNode,
                        nextFocus: controller.confirmPasswordFocusNode,
                        labelText: MyStrings.createNewPin,
                        hintText: "*****",
                        isShowSuffixIcon: true,
                        isPassword: true,
                        textInputType: TextInputType.phone,
                        controller: controller.passController,
                        radius: Dimensions.mediumRadius,
                        validator: (value) {
                          return controller.validatePassword(value);
                        },
                        onChanged: (value) {
                          return;
                        }),
                  ),
                  Visibility(
                      visible: controller.hasPasswordFocus && controller.checkPasswordStrength,
                      child: ValidationWidget(
                        list: controller.passwordValidationRules,
                        fromReset: true,
                      )),
                  const SizedBox(height: Dimensions.space25),
                  CustomPinField(
                    animatedLabel: true,
                    needOutlineBorder: true,
                    inputAction: TextInputAction.done,
                    textInputType: TextInputType.phone,
                    isPassword: true,
                    labelText: MyStrings.confirmPin.tr,
                    hintText: "*****",
                    isShowSuffixIcon: true,
                    controller: controller.confirmPassController,
                    radius: Dimensions.mediumRadius,
                    onChanged: (value) {
                      return;
                    },
                    validator: (value) {
                      if (controller.passController.text.toLowerCase() != controller.confirmPassController.text.toLowerCase()) {
                        return MyStrings.kMatchPassError.tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space35),
                  GradientRoundedButton(
                    showLoadingIcon: controller.submitLoading,
                    text: MyStrings.submit.tr,
                    press: () {
                      if (formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
