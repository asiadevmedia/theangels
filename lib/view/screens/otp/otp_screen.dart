import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/repo/opt_repo/opt_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/screens/otp/widget/otp_timer.dart';

import '../../../data/controller/otp_controller/otp_controller.dart';

class OtpScreen extends StatefulWidget {
  final String actionId;
  final String nextRoute;
  final String otpType;

  const OtpScreen({
    super.key,
    required this.actionId,
    required this.nextRoute,
    required this.otpType,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String methodName = "";
  @override
  void initState() {
    methodName = Get.arguments != null ? Get.arguments[3] : "";
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(OtpRepo(apiClient: Get.find()));
    final controller = Get.put(OtpController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.nextRoute = widget.nextRoute;
      controller.actionId = widget.actionId;
      controller.updateOtp(widget.otpType.toLowerCase());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: MyColor.colorWhite),
      child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          appBar: CustomAppBar(fromAuth: false, title: MyStrings.otpVerification, isShowBackBtn: true, bgColor: MyColor.getAppBarColor()),
          body: GetBuilder<OtpController>(
            builder: (controller) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(vertical: Dimensions.space30, horizontal: Dimensions.space20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyStrings.enterYourOTPTitle.tr, style: regularMediumLarge.copyWith(color: MyColor.colorBlack, fontWeight: FontWeight.w600)),
                        Text("${MyStrings.sendToYour.tr} ${methodName.toLowerCase() == "sms" ? "Phone" : methodName}", style: regularMediumLarge.copyWith(color: MyColor.colorBlack, fontWeight: FontWeight.w600)),
                        const SizedBox(height: Dimensions.space50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                            length: 6,
                            textStyle: boldLarge.copyWith(color: MyColor.getTextColor()),
                            obscuringCharacter: '*',
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderWidth: 0.5,
                              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                              inactiveColor: MyColor.getTextFieldDisableBorder().withOpacity(0.5),
                              inactiveFillColor: MyColor.borderColor.withOpacity(.07),
                              activeFillColor: MyColor.colorWhite,
                              activeColor: MyColor.primaryColor.withOpacity(0.7),
                              selectedFillColor: MyColor.colorWhite,
                              selectedColor: MyColor.getPrimaryColor(),
                              fieldHeight: 40,
                              fieldWidth: 40,
                            ),
                            animationCurve: Curves.easeInCirc,
                            cursorColor: MyColor.getTextColor(),
                            animationDuration: const Duration(milliseconds: 0),
                            enableActiveFill: true,
                            keyboardType: TextInputType.number,
                            beforeTextPaste: (text) {
                              return true;
                            },
                            onChanged: (value) {
                              controller.currentText = value;
                              if (value.length == 6) {
                                // controller.verifyEmail(value);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (controller.isOtpExpired) {
                                  controller.sendCodeAgain();
                                }
                              },
                              child: Text(
                                controller.resendLoading
                                    ? MyStrings.resending.tr
                                    : controller.isOtpExpired
                                        ? MyStrings.codeResend.tr
                                        : MyStrings.codeResendIn.tr,
                                style: heading.copyWith(
                                  color: controller.isOtpExpired ? MyColor.getPrimaryColor() : MyColor.getTextColor(),
                                ),
                              ),
                            ),
                            controller.resendLoading
                                ? Container(
                                    margin: const EdgeInsets.only(left: Dimensions.space7),
                                    height: 16,
                                    width: 16,
                                    child: const CircularProgressIndicator(color: MyColor.primaryColor),
                                  )
                                : const SizedBox.shrink(),
                            controller.isOtpExpired
                                ? const SizedBox.shrink()
                                : OtpTimer(
                                    duration: controller.time,
                                    onTimeComplete: () {
                                      controller.makeOtpExpired(true);
                                    },
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: MyColor.primaryColor, shape: BoxShape.circle),
                          child: GradientRoundedButton(
                            showLoadingIcon: controller.submitLoading,
                            text: MyStrings.submit.tr,
                            press: () {
                              controller.verifyEmail(controller.currentText);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
