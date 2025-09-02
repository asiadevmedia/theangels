import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/notification_settings/notification_settings_controller.dart';
import 'package:viserpay/data/repo/notification_settings/notification_settings_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/screens/notification/advance_switch/custom_switch.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(NotificationSettingsRepo(apiClient: Get.find()));
    final controller = Get.put(NotificationSettingsController(notificationSettingsRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.iniitialValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.notificationSettings,
        isTitleCenter: true,
        elevation: 0.01,
      ),
      body: GetBuilder<NotificationSettingsController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardColumn(
                              bodyMaxLine: 3,
                              header: MyStrings.receivePushNotification.tr,
                              body: MyStrings.receivePushNotificationSubtitle.tr,
                              headerTextStyle: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontMediumLarge - 1, fontWeight: FontWeight.w500),
                              space: 5,
                              bodyTextStyle: lightDefault.copyWith(
                                fontSize: Dimensions.fontDefault - 1,
                                color: MyColor.bodytextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.space15),
                          CustomSwitch(
                            value: controller.isPushNotificationEnable,
                            onChanged: (p) async {
                              if (await Permission.notification.isDenied) {
                                Permission.notification.request().then((value) {
                                  if (value.isGranted) {
                                    controller.isPushNotificationEnable = !controller.isPushNotificationEnable;
                                    controller.update();
                                    !controller.isLoading ? controller.changeNotification() : null;
                                  } else {
                                    CustomSnackBar.error(errorList: ["Please allow push notification"]);
                                    openAppSettings();
                                  }
                                });
                              } else {
                                controller.isPushNotificationEnable = !controller.isPushNotificationEnable;
                                controller.update();
                                !controller.isLoading ? controller.changeNotification() : null;
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.space25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardColumn(
                              header: MyStrings.emailNotification.tr,
                              body: MyStrings.emailNotificationSubtitle.tr,
                              headerTextStyle: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontMediumLarge - 1, fontWeight: FontWeight.w500),
                              space: 5,
                              bodyMaxLine: 3,
                              bodyTextStyle: lightDefault.copyWith(
                                fontSize: Dimensions.fontDefault - 1,
                                color: MyColor.bodytextColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.space25,
                          ),
                          CustomSwitch(
                            value: controller.isEmailhNotificationEnable,
                            onChanged: (p) {
                              controller.isEmailhNotificationEnable = !controller.isEmailhNotificationEnable;
                              controller.update();
                              !controller.isLoading ? controller.changeNotification() : null;
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.space25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardColumn(
                              header: MyStrings.promotionalOffer.tr,
                              body: MyStrings.promotionalOfferSubtitle.tr,
                              headerTextStyle: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontMediumLarge - 1, fontWeight: FontWeight.w500),
                              space: 5,
                              bodyMaxLine: 2,
                              bodyTextStyle: lightDefault.copyWith(
                                fontSize: Dimensions.fontDefault - 1,
                                color: MyColor.bodytextColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.space20,
                          ),
                          CustomSwitch(
                            value: controller.isAllowPromotional,
                            onChanged: (p) {
                              controller.isAllowPromotional = !controller.isAllowPromotional;
                              controller.update();
                              !controller.isLoading ? controller.changeNotification() : null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.space25,
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
