import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/menu/my_menu_controller.dart';
import 'package:viserpay/data/repo/auth/general_setting_repo.dart';
import 'package:viserpay/data/repo/menu_repo/menu_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class PrivacySettingScreen extends StatefulWidget {
  const PrivacySettingScreen({super.key});

  @override
  State<PrivacySettingScreen> createState() => _PrivacySettingScreenState();
}

class _PrivacySettingScreenState extends State<PrivacySettingScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(MenuRepo(apiClient: Get.find()));
    Get.put(MyMenuController(menuRepo: Get.find(), repo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.privacySettings.tr,
        isTitleCenter: true,
        elevation: 0.01,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GetBuilder<MyMenuController>(builder: (controller) {
          return controller.removeLoading
              ? const CustomLoader(
                  loaderColor: MyColor.colorRed,
                  isFullScreen: true,
                )
              : Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.toNamed(RouteHelper.privacyScreen);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardColumn(
                              header: MyStrings.privacyPolicyAndUsage.tr,
                              body: MyStrings.listthetypesofdatatheappcollects.tr,
                              headerTextStyle: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontMediumLarge - 1, fontWeight: FontWeight.w500),
                              space: 5,
                              bodyTextStyle: lightDefault.copyWith(
                                fontSize: Dimensions.fontDefault - 1,
                                color: MyColor.bodytextColor,
                              ),
                            ),
                            const CustomSvgPicture(
                              image: MyIcon.arrowRightIos,
                              color: MyColor.colorBlack,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
