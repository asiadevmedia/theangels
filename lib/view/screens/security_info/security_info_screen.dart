import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/auth/biometric/biometric_controller.dart';
import 'package:viserpay/data/repo/biometric/biometric_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/screens/notification/advance_switch/custom_switch.dart';
import 'package:viserpay/view/screens/security_info/widget/fingerprint_bottom_sheet.dart';
import 'package:viserpay/view/screens/security_info/widget/info_card.dart';

import '../../../core/utils/my_color.dart';

class SecurityInfoScreen extends StatefulWidget {
  const SecurityInfoScreen({super.key});

  @override
  State<SecurityInfoScreen> createState() => _SecurityInfoScreenState();
}

class _SecurityInfoScreenState extends State<SecurityInfoScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BiometricRepo(apiClient: Get.find()));
    final controller = Get.put(BioMetricController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(isWhite: true),
      appBar: CustomAppBar(
        title: MyStrings.securityInformation,
        isTitleCenter: true,
        elevation: 0.09,
      ),
      body: GetBuilder<BioMetricController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space20),
            child: Column(
              children: [
                Infocard(
                  icon: MyIcon.lock,
                  title: MyStrings.resetpin.tr,
                  subtitle: MyStrings.resetpinSub.tr,
                  ontap: () {
                    Get.toNamed(RouteHelper.changePasswordScreen);
                  },
                ),
                Infocard(
                  icon: MyImages.twoFa,
                  isSvg: false,
                  title: MyStrings.twoFactorAuth.tr,
                  subtitle: MyStrings.twoFaIconMsg.tr,
                  ontap: () {
                    Get.toNamed(RouteHelper.twoFactorSetupScreen);
                  },
                ),
                if (controller.canCheckBiometricsAvalable) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const CustomSvgPicture(
                                image: MyIcon.finger2,
                                color: MyColor.colorBlack,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(
                                width: Dimensions.space15,
                              ),
                              Expanded(
                                child: CardColumn(
                                  header: MyStrings.setupYourFingerPrint.tr,
                                  body: MyStrings.auAuthenticatewithYourFingerprin.tr,
                                  bodyMaxLine: 8,
                                  headerTextStyle: boldDefault.copyWith(fontSize: 16),
                                  bodyTextStyle: regularDefault.copyWith(color: MyColor.colorGrey),
                                ),
                              )
                            ],
                          ),
                        ),
                        CustomSwitch(
                          value: controller.alradySetup,
                          onChanged: (p) async {
                            controller.passwordController.text = '';
                            if (controller.alradySetup == true) {
                              controller.disableBiometric();
                            } else {
                              CustomBottomSheet(child: const FingerPrintBottomsheet()).customBottomSheet(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
