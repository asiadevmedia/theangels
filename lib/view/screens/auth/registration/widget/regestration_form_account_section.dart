import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/auth/auth/registration_controller.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';
import 'package:viserpay/view/screens/auth/registration/widget/country_bottom_sheet.dart';

import '../../../../../environment.dart';

class RegistrationFormAccountSection extends StatefulWidget {
  const RegistrationFormAccountSection({super.key});

  @override
  State<RegistrationFormAccountSection> createState() => _RegistrationFormAccountSectionState();
}

class _RegistrationFormAccountSectionState extends State<RegistrationFormAccountSection> {
  bool isNumberBlank = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
        child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CustomTextField(
                  radius: 10,
                  shadowBox: true,
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
                const SizedBox(height: Dimensions.space15),
                CustomTextField(
                  radius: 10,
                  shadowBox: true,
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
                const SizedBox(height: Dimensions.space15),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: isNumberBlank ? MyColor.colorRed : MyColor.getTextFieldDisableBorder(), width: .5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: MyUtils.getShadow2(blurRadius: 10),
                    color: MyColor.colorWhite,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space2),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          CountryBottomSheet.bottomSheet(context, controller);
                        },
                        child: Container(
                          // padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: MyColor.transparentColor,
                            borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyImageWidget(
                                imageUrl: UrlContainer.countryFlagImageLink.replaceAll("{countryCode}", (controller.selectedCountryData.countryCode ?? Environment.defaultCountryCode).toString().toLowerCase()),
                                height: Dimensions.space25,
                                width: Dimensions.space40 + 2,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: Dimensions.space10),
                                child: Text(
                                  "+${controller.selectedCountryData.dialCode ?? Environment.defaultPhoneCode}",
                                  style: regularMediumLarge,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: Dimensions.space10, bottom: 0),
                          child: TextFormField(
                            controller: controller.mobileController,
                            focusNode: controller.mobileFocusNode,
                            // onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(controller.passwordFocusNode),
                            onChanged: (value) {
                              controller.mobileController.text.isNotEmpty ? isNumberBlank = false : null;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(Dimensions.space15),
                                child: SvgPicture.asset(
                                  MyIcon.phoneSVG,
                                ),
                              ),
                              hintText: "000-000",
                              border: InputBorder.none, // Remove border
                              filled: false, // Remove fill
                              contentPadding: const EdgeInsetsDirectional.only(top: 8.5, start: 0, end: 15, bottom: 2),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.space5),
                isNumberBlank
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(MyStrings.enterYourPhoneNumber, style: regularSmall.copyWith(color: MyColor.colorRed)),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: Dimensions.space25),
                GradientRoundedButton(
                  cornerRadius: Dimensions.mediumRadius,
                  textColor: MyColor.getPrimaryButtonTextColor(),
                  text: MyStrings.continue_.tr,
                  press: () {
                    if (formKey.currentState!.validate() && controller.countryName!.isNotEmpty && isNumberBlank == false) {
                      controller.changeIndex(controller.currentStep + 1);
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space35),
              ],
            )),
      );
    });
  }
}
