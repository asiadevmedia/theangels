import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/auth/biometric/biometric_controller.dart';
import 'package:viserpay/data/repo/biometric/biometric_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';

class SetupFingerPrintScreen extends StatefulWidget {
  const SetupFingerPrintScreen({super.key});

  @override
  State<SetupFingerPrintScreen> createState() => _SetupFingerPrintScreenState();
}

class _SetupFingerPrintScreenState extends State<SetupFingerPrintScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BiometricRepo(apiClient: Get.find()));
    final controller = Get.put(BioMetricController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.checkBiometricsAvalable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BioMetricController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(title: MyStrings.setupYourFingerPrint),
        body: SingleChildScrollView(
          padding: Dimensions.screenPaddingHV,
          child: !controller.canCheckBiometricsAvalable
              ? Container(
                  margin: EdgeInsets.only(top: context.height * .4),
                  child: Center(child: Text(MyStrings.unavalableBioMsg.tr)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.height * .2),
                    Text(
                      MyStrings.setupYourFingerPrint.tr,
                      style: title.copyWith(fontSize: Dimensions.fontExtraLarge),
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
                    const SizedBox(height: 15),
                    Text(
                      controller.isPermantlyLocked
                          ? MyStrings.permantlyLockedPleaselockyourPhoneandTryagain.tr
                          : controller.isDisable
                              ? "${MyStrings.pleaseTryagainAfter.tr}${controller.countdownSeconds}s  ${MyStrings.later.tr}"
                              : '',
                      style: regularDefault.copyWith(),
                    ),
                    controller.isDisable ? const SizedBox.shrink() : const SizedBox(height: 15),
                  ],
                ),
        ),
      );
    });
  }
}
