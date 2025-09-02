

import 'dart:convert';

import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/notification_settings/notification_settings_model.dart';
import 'package:viserpay/data/repo/notification_settings/notification_settings_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class NotificationSettingsController extends GetxController {
  NotificationSettingsRepo notificationSettingsRepo;
  NotificationSettingsController({required this.notificationSettingsRepo});
  //
  bool isLoading = false;
  bool isPushNotificationEnable = false;
  bool isEmailhNotificationEnable = false;
  bool isAllowPromotional = false;

  void iniitialValue() {
    isLoading = true;
    update();

    getNotificationSettingsData();

    isLoading = false;
    update();
  }

  //
  Future<void> getNotificationSettingsData() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await notificationSettingsRepo.getNotificationSettings();
    if (responseModel.statusCode == 200) {
      NotificationSettingsResponseModal modal = NotificationSettingsResponseModal.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == MyStrings.success) {
        if (modal.data != null) {
          String en = modal.data?.user?.en ?? "1";
          String pn = modal.data?.user?.pn ?? "1";
          isAllowPromotional = modal.data?.user?.allowPromotionalNotifications == "1"? true : false;
          //
          if (en == "1") {
            isEmailhNotificationEnable = true;
          }
          if (pn == "1") {
            isPushNotificationEnable = true;
          }

          update();
        } else {
          CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
        }
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

// post notification settings
  Future<void> changeNotification() async {
    ResponseModel responseModel = await notificationSettingsRepo.changeNotificationSettings(isEmail: isEmailhNotificationEnable, isPush: isPushNotificationEnable, isAllowPromotional: isAllowPromotional);
    if (responseModel.statusCode == 200) {
      // CustomSnackBar.success(successList: [MyStrings.success]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
  }
}
