import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/authorization/authorization_response_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/pin/pin_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class PinController extends GetxController {
  PinRepo pinRepo;
  PinController({required this.pinRepo});
  bool isLoading = false;

  final FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  bool isConfirmed = false;
  String pinText = "";
  String passcode = "";

  void updatePinText(String value) {
    pinText = value;
    isConfirmed = true;
    update();
  }

  void initData() {
    passcode = pinRepo.apiClient.getPasscode();
    isSubmitLoading = false;
    update();
  }

  bool isSubmitLoading = false;
  Future<void> updatePin(String userPin, {bool updatePin = false}) async {
    SharedPreferences preferences = pinRepo.apiClient.sharedPreferences;
    isSubmitLoading = true;
    update();

    ResponseModel responseModel = await pinRepo.updatePin(pin: userPin, password: updatePin ? passwordController.text : passcode);
    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == MyStrings.success) {
        await preferences.setString(SharedPreferenceHelper.isPinSet, '1');
        CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.somethingWentWrong]);
        Get.offAllNamed(RouteHelper.bottomNavBar);
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      await preferences.setString(SharedPreferenceHelper.isPinSet, '0');
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isSubmitLoading = false;
    update();
  }
}
