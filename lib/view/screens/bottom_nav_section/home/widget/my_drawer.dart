import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';
import 'package:viserpay/data/controller/menu/my_menu_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/bottom-sheet/delete_account_bottom_sheet_body.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/drawer.dart';
import 'package:viserpay/view/screens/edit_profile/widget/profile_image.dart';

import '../../../../components/cash-card/user/drawer_user_card.dart';

class MyDrawer extends StatefulWidget {
  final Function() onDrawerItemTap;
  const MyDrawer({super.key, required this.onDrawerItemTap});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyMenuController>(builder: (controller) {
      return ClipRRect(
        borderRadius: const BorderRadiusDirectional.only(),
        child: Drawer(
          width: context.width / 1.4,
          backgroundColor: MyColor.colorWhite,
          surfaceTintColor: MyColor.colorWhite,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 5.0, end: 4),
            child: GetBuilder<HomeController>(builder: (homecontroller) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Dimensions.space10,
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(end: Dimensions.space16),
                      height: Dimensions.space60,
                      width: double.infinity,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => widget.onDrawerItemTap(),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.close_rounded,
                            size: 30,
                            color: MyColor.getTextColor(),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.profileScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: Dimensions.space10,
                        ),
                        child: DrawerUserCard(
                          fullname: homecontroller.fullName,
                          username: homecontroller.username,
                          subtitle: "+${homecontroller.mobileNo}",
                          imgWidget: Container(
                            decoration: BoxDecoration(border: Border.all(color: MyColor.borderColor, width: 0.5), shape: BoxShape.circle),
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: homecontroller.userimage == "null" || homecontroller.userimage == "" ? ProfileWidget(imagePath: "", onClicked: () {}) : MyImageWidget(imageUrl: homecontroller.userimage, boxFit: BoxFit.cover),
                            ),
                          ),
                          imgHeight: 40,
                          imgwidth: 40,
                        ),
                      ),
                    ),
                    const CustomDivider(
                      onlyTop: true,
                      space: Dimensions.space20,
                      onlybottom: true,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: Dimensions.space10, top: Dimensions.space10),
                      child: Column(
                        children: [
                          DrawerItem(
                            svgIcon: MyIcon.person,
                            name: MyStrings.personalInformation.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.profileScreen);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.menuQrCode,
                            name: MyStrings.myQrCode.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.myQrCodeScreen);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.lock,
                            name: MyStrings.securityInformation.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.securityInfoScreen);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.notification,
                            name: MyStrings.notificationSettings.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.notificationSettingsScreen);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.privacy,
                            name: MyStrings.privacyPolicy.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.privacyScreen);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          controller.repo.apiClient.getMultiLanguageStatus()
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DrawerItem(
                                      svgIcon: MyIcon.settings,
                                      name: MyStrings.appPreference.tr,
                                      ontap: () {
                                        Get.toNamed(RouteHelper.appPreferenceSettingScreen);
                                      },
                                    ),
                                    const SizedBox(
                                      height: Dimensions.space30,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          DrawerItem(
                            svgIcon: MyIcon.clock,
                            name: MyStrings.transactionHistory.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.transactionHistoryScreen, arguments: "-1");
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.danger,
                            name: MyStrings.transactionLimit.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.transactionLimit);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.info,
                            name: MyStrings.faq.tr,
                            ontap: () {
                              Get.toNamed(RouteHelper.faqScreen);
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                          DrawerItem(
                            svgIcon: MyIcon.userDelete,
                            name: MyStrings.accountDelete.tr,
                            iconColor: MyColor.colorRed,
                            titleStyle: regularDefault.copyWith(
                              fontSize: Dimensions.fontLarge,
                              color: MyColor.colorRed,
                            ),
                            ontap: () {
                              widget.onDrawerItemTap();
                              controller.passwordController.text = "";
                              CustomBottomSheet(
                                isNeedMargin: true,
                                child: const DeleteAccountBottomsheetBody(),
                              ).customBottomSheet(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.space30,
                    ),
                    const CustomDivider(
                      onlyTop: true,
                      space: Dimensions.space20,
                      onlybottom: true,
                    ),
                    //Logout Section
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: Dimensions.space10, top: Dimensions.space10),
                      child: Column(
                        children: [
                          // const Spacer(),

                          controller.logoutLoading
                              ? const CustomLoader(
                                  isPagination: true,
                                )
                              : DrawerItem(
                                  svgIcon: MyIcon.logout,
                                  name: MyStrings.logout.tr,
                                  ontap: () => controller.logout(),
                                ),
                          const SizedBox(
                            height: Dimensions.space30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
