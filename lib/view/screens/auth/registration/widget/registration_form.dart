// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/controller/auth/auth/registration_controller.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';
import 'package:viserpay/view/screens/auth/registration/widget/country_bottom_sheet.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool isNumberBlank = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      builder: (controller) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                radius: 10,
                shadowBox: false,
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.username.tr,
                hintText: MyStrings.enterYourUsername.tr,
                controller: controller.userNameController,
                focusNode: controller.userNameFocusNode,
                textInputType: TextInputType.text,
                nextFocus: controller.emailFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return MyStrings.enterYourUsername.tr;
                  } else if (value.length < 6) {
                    return MyStrings.kShortUserNameError.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              const SizedBox(height: Dimensions.space20),
              CustomTextField(
                radius: 10,
                shadowBox: false,
                needOutlineBorder: true,
                animatedLabel: true,
                labelText: MyStrings.email.tr,
                hintText: MyStrings.enterYourEmail.tr,
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                textInputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourEmail.tr;
                  } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
                    return MyStrings.invalidEmailMsg.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              const SizedBox(height: Dimensions.space20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: isNumberBlank ? MyColor.colorRed : MyColor.getTextFieldDisableBorder(), width: .5),
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: MyUtils.getShadow2(blurRadius: 10),
                  color: MyColor.colorWhite,
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: 0),
                child: TextFormField(
                  controller: controller.mobileController,
                  focusNode: controller.mobileFocusNode,
                  onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(controller.passwordFocusNode),
                  onChanged: (value) {
                    controller.mobileController.text.isNotEmpty ? isNumberBlank = false : null;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    prefixIcon: InkWell(
                      onTap: () {
                        CountryBottomSheet.bottomSheet(context, controller);
                      },
                      child: FittedBox(
                        child: Container(
                          // width: 105,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: MyColor.transparentColor,
                            borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyImageWidget(
                                imageUrl: UrlContainer.countryFlagImageLink.replaceAll("{countryCode}", controller.selectedCountryData.countryCode.toString().toLowerCase()),
                                height: Dimensions.space25,
                                width: Dimensions.space40 + 2,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: Dimensions.space5, end: Dimensions.space5),
                                child: Text(
                                  "+${controller.dialCode.tr}",
                                  style: regularMediumLarge,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      child: SvgPicture.asset(
                        MyIcon.phoneSVG,
                      ),
                    ),
                    hintText: "000-000",
                    border: InputBorder.none, // Remove border
                    filled: false, // Remove fill
                    contentPadding: const EdgeInsetsDirectional.only(top: 8.5, start: 0, end: 15, bottom: 0),
                    hintStyle: regularMediumLarge.copyWith(color: MyColor.hintTextColor),
                  ),
                  keyboardType: TextInputType.phone, // Set keyboard type to phone
                  style: regularMediumLarge,
                  cursorColor: MyColor.primaryColor, // Set cursor color to red
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        isNumberBlank = true;
                      });
                      return;
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              isNumberBlank ? const SizedBox(height: Dimensions.space5) : const SizedBox.shrink(),
              isNumberBlank
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(MyStrings.enterYourPhoneNumber, style: regularSmall.copyWith(color: MyColor.colorRed)),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: Dimensions.space20),
              Focus(
                  onFocusChange: (hasFocus) {
                    controller.changePasswordFocus(hasFocus);
                  },
                  child: CustomPinField(
                    radius: 10,
                    shadowBox: false,
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
                    onChanged: (value) {
                      if (controller.checkPasswordStrength) {
                        controller.updateValidationList(value);
                      }
                    },
                    validator: (value) {
                      return controller.validatePassword(value ?? '');
                    },
                  )),
              const SizedBox(height: Dimensions.space20),
              CustomPinField(
                radius: 10,
                shadowBox: false,
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
              const SizedBox(height: Dimensions.space25),
              Visibility(
                  visible: controller.needAgree,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                          activeColor: MyColor.primaryColor,
                          checkColor: MyColor.colorWhite,
                          value: controller.agreeTC,
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(width: 1.0, color: controller.agreeTC ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                          ),
                          onChanged: (bool? value) {
                            controller.updateAgreeTC();
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.space8),
                      Row(
                        children: [
                          Text(MyStrings.iAgreeWith.tr, style: regularDefault.copyWith(color: MyColor.getTextColor())),
                          const SizedBox(width: Dimensions.space3),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.privacyScreen);
                            },
                            child: Text(MyStrings.policies.tr.toLowerCase(), style: regularDefault.copyWith(color: MyColor.getPrimaryColor(), decoration: TextDecoration.underline, decorationColor: MyColor.getPrimaryColor())),
                          ),
                          const SizedBox(width: Dimensions.space3),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: Dimensions.space30),
              GradientRoundedButton(
                  showLoadingIcon: controller.submitLoading,
                  text: MyStrings.signUpNow.tr,
                  press: () {
                    if (formKey.currentState!.validate()) {
                      controller.signUpUser();
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
