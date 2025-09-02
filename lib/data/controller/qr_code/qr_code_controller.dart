import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/qr_code/qr_code_download_response_model.dart';
import 'package:viserpay/data/model/qr_code/qr_code_response_model.dart';
import 'package:viserpay/data/model/qr_code/qr_code_scan_response_model.dart';
import 'package:viserpay/data/repo/qr_code/qr_code_repo.dart';
import 'package:viserpay/view/components/file_download_dialog/download_dialogue.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';

class QrCodeController extends GetxController {
  QrCodeRepo qrCodeRepo;
  QrCodeController({required this.qrCodeRepo});

  bool isLoading = true;
  QrCodeResponseModel model = QrCodeResponseModel();

  String qrCode = "";
  String username = '';

  Future<void> loadData() async {
    username = qrCodeRepo.apiClient.getCurrencyOrUsername(isCurrency: false);
    isLoading = true;
    update();

    ResponseModel responseModel = await qrCodeRepo.getQrData();
    if (responseModel.statusCode == 200) {
      model = QrCodeResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == "success") {
        qrCode = model.data?.qrCode ?? "";
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  String downloadUrl = "";
  String downloadFileName = "";
  bool downloadLoading = false;
  Future<void> downloadImage() async {
    downloadLoading = true;
    update();

    ResponseModel responseModel = await qrCodeRepo.qrCodeDownLoad();
    if (responseModel.statusCode == 200) {
      QrCodeDownloadResponseModel model = QrCodeDownloadResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == "success") {
        downloadUrl = model.data?.downloadLink ?? "";
        downloadFileName = model.data?.downloadFileName ?? "";
        if (downloadUrl.isNotEmpty && downloadUrl != 'null') {
          showDialog(
            context: Get.context!,
            builder: (context) => DownloadingDialog(isImage: true, isPdf: false, url: downloadUrl, fileName: downloadFileName),
          );
        }
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    downloadLoading = false;
    update();
  }

  Future<void> shareImage() async {
    final box = Get.context!.findRenderObject() as RenderBox?;

    await Share.share(
      qrCode,
      subject: MyStrings.share.tr,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  bool isScannerLoading = false;
  Future<bool> submitQrData({
    required String scannedData,
    String expectedType = "-1",
    String nextRouteName = "-1",
  }) async {
    isScannerLoading = true;
    update();

    bool requestStatus = false;

    ResponseModel responseModel = await qrCodeRepo.qrCodeScan(scannedData);
    if (responseModel.statusCode == 200) {
      QrCodeSubmitScanResponseModel scanModel = QrCodeSubmitScanResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (scanModel.status.toString().toLowerCase() == "success") {
        String userType = scanModel.data?.userType ?? "";
        String userName = scanModel.data?.userData?.username ?? "";
        String userNumber = scanModel.data?.userData?.mobile ?? "";
        List<TransactionCharge>? tempTransactionCharge = scanModel.data?.transactionChargeList ?? [];
        if (expectedType != "-1") {
          if (userType.toLowerCase() == expectedType.toLowerCase()) {
            Get.offAndToNamed(nextRouteName, arguments: [userName, userNumber]);
          } else {
            Get.back();
            String subTitle = expectedType.toLowerCase() == 'merchant'
                ? MyStrings.scanMerchantQrCode
                : expectedType.toLowerCase() == 'agent'
                    ? MyStrings.scanAgentQrCode
                    : MyStrings.scanUserQrCode;
            AppDialog().unaValableQrCode(subTitle);
          }
        } else {
          if (tempTransactionCharge.isNotEmpty) {
            if (userType.toLowerCase() == 'agent') {
              Get.offAndToNamed(RouteHelper.cashOutAmountScreen, arguments: [userName, userNumber]);
            } else if (userType.toLowerCase() == 'merchant') {
              Get.offAndToNamed(RouteHelper.makePaymentAmountScreen, arguments: [userName, userNumber]);
            } else if (userType.toLowerCase() == 'user') {
              Get.offAndToNamed(RouteHelper.sendMoneyAmountScreen, arguments: [userName, userNumber]);
            } else {
              Get.back();
            }
          } else {
            Get.back();
            CustomSnackBar.error(errorList: [MyStrings.invalidUserType]);
          }
        }
      } else {
        Get.back();
        requestStatus = false;
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.requestFail]);
      }
    } else {
      requestStatus = false;
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isScannerLoading = false;
    update();

    return requestStatus;
  }
  //
}
