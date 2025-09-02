// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/auth/forget_password/forget_password_controller.dart';
import 'package:viserpay/data/model/country_model/country_model.dart';
import 'package:viserpay/data/repo/auth/login_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/text/default_text.dart';
import 'package:viserpay/view/components/text/header_text.dart';
import 'package:viserpay/view/screens/auth/registration/widget/country_bottom_sheet.dart';

import '../../../../../environment.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Countries> countries = [];
  bool isNumberBlank = false;

  @override
  void initState() {
    countries = Get.arguments != null ? Get.arguments : [];

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    final controller = Get.put(ForgetPasswordController(loginRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        MyUtils.allScreen();
      });
      if (countries.isNotEmpty) {
        controller.setCountryData(countries);
      } else {
        controller.getCountryData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: MyColor.colorWhite, statusBarIconBrightness: Brightness.light, systemNavigationBarColor: MyColor.screenBgColor, systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(isWhite: true),
          appBar: CustomAppBar(
            fromAuth: true,
            isShowBackBtn: true,
            title: MyStrings.forgetPassword.tr,
            bgColor: MyColor.getAppBarColor(),
          ),
          body: GetBuilder<ForgetPasswordController>(
            builder: (controller) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: Dimensions.screenPaddingHV,
              child: controller.countryLoading
                  ? const CustomLoader(
                      isFullScreen: true,
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.space30),
                          HeaderText(text: MyStrings.recoverAccount.tr),
                          const SizedBox(height: 15),
                          DefaultText(text: MyStrings.forgetPasswordSubText.tr, textStyle: regularDefault.copyWith(color: MyColor.getTextColor().withOpacity(0.8))),
                          const SizedBox(height: Dimensions.space40),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: isNumberBlank ? MyColor.colorRed : MyColor.getTextFieldDisableBorder(), width: .5),
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: MyUtils.getShadow2(blurRadius: 10),
                              color: MyColor.colorWhite,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: 0),
                            child: TextFormField(
                              controller: controller.phoneController,
                              focusNode: controller.phoneFocusNode,
                              //onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(controller.passwordFocusNode),
                              onChanged: (value) {
                                controller.phoneController.text.isNotEmpty ? isNumberBlank = false : null;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 30,
                                ),
                                prefixIcon: InkWell(
                                  onTap: () {
                                    CountryBottomSheet.forgotCountrybottomSheet(context, controller);
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
                                              "+${controller.selectedCountryData.dialCode ?? Environment.defaultPhoneCode}",
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
                          isNumberBlank ? Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(MyStrings.enterYourPhoneNumber.tr, style: regularSmall.copyWith(color: MyColor.colorRed))) : const SizedBox.shrink(),
                          const SizedBox(height: Dimensions.space25),
                          GradientRoundedButton(
                            showLoadingIcon: controller.submitLoading,
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                controller.submitForgetPassCode();
                              }
                            },
                            text: MyStrings.submit.tr,
                          ),
                          const SizedBox(height: Dimensions.space40)
                        ],
                      ),
                    ),
            ),
          )),
    );
  }
}
