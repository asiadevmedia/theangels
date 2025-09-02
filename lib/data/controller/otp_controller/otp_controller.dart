import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/authorization/authorization_response_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/opt_repo/opt_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

import '../../../environment.dart';

class OtpController extends GetxController {
  OtpRepo repo;
  OtpController({required this.repo});

  String currentText = "";
  bool submitLoading = false;
  bool resendLoading = false;
  String actionId = '';
  String nextRoute = '';
  String otpType = '';
  bool startTime = false;

  void updateOtp(String otpType) {
    this.otpType = otpType;
    String expirationTime = repo.apiClient.getGSData().data?.generalSetting?.otpExpiration ?? Environment.otpTime.toString();
    time = double.parse(expirationTime).toInt();
    update();
  }

  bool isOtpExpired = false;
  int time = Environment.otpTime;

  void makeOtpExpired(bool status) {
    isOtpExpired = status;
    if (status == false) {
      String expirationTime = repo.apiClient.getGSData().data?.generalSetting?.otpExpiration ?? Environment.otpTime.toString();
      time = double.parse(expirationTime).toInt();
    } else {
      time = 0;
    }

    update();
  }

  Future<void> verifyEmail(String text) async {
    if (text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.verify(text, actionId);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        if (nextRoute.isNotEmpty) {
          Get.offAndToNamed(nextRoute, arguments: [responseModel]);
        } else {
          Get.back();
        }
        CustomSnackBar.success(successList: model.message?.success ?? [(MyStrings.emailVerificationSuccess)]);
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [(MyStrings.emailVerificationFailed)]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    submitLoading = false;
    update();
  }

  Future<void> sendCodeAgain() async {
    resendLoading = true;
    update();

    ResponseModel response = await repo.resendVerifyCode(actionId);
    if (response.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == 'success') {
        CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.successfullyCodeResend]);
        makeOtpExpired(false);
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.resendCodeFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    resendLoading = false;
    update();
  }
}
