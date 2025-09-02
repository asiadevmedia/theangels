// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/sf_utils.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/model/global/marchent_exist/marchent_exist_modal.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/make_payment/make_payment_history_response_model.dart';
import 'package:viserpay/data/model/make_payment/make_payment_response_modal.dart';
import 'package:viserpay/data/model/make_payment/make_payment_submit_response_modal.dart';
import 'package:viserpay/data/repo/money_discharge/make_payment/make_payment_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class MakePaymentController extends GetxController {
  MakePaymentRepo makePaymentRepo;
  MakePaymentController({required this.makePaymentRepo});
  bool isLoading = false;
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  FocusNode numberFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();

  List<UserContactModel> recentList = [];
  List<String> quickAmountList = [];

  void initialValue() {
    currency = makePaymentRepo.apiClient.getCurrencyOrUsername(isCurrency: false);
    currencySym = makePaymentRepo.apiClient.getCurrencyOrUsername(isSymbol: true);

    quickAmountList = makePaymentRepo.apiClient.getQuickAmountList();

    amountFocusNode.unfocus();
    amountController.text = '';
    amountController.clear();

    numberController.text = '';
    numberController.clear();
    makePaymentData();
  }

  bool isValidNumber = false; // note: user number valid
  numberValidation(val) {
    final parse = int.tryParse(numberController.text);
    if (numberController.text.length == 11 && parse.runtimeType.toString() == "int") {
      isValidNumber = true;
      update();
    } else {
      isValidNumber = false;
      update();
    }
  }

  UserContactModel? selectedContact;
  void selectContact(UserContactModel contact, {bool fromQr = false}) {
    if (contact.number.isNotEmpty) {
      selectedContact = contact;
      selectedMethod = 1;
      update();
      // refill filter contact clear filter data
      checkMarchantExist(fromQr: fromQr);
    } else {
      selectedContact = null;
      CustomSnackBar.error(errorList: [MyStrings.selectAvailableNumberPlease]);
    }
  }

  int selectedMethod = -1; // note: 0 for number and 1 for contact
  void changeSelectedMethod() {
    selectedMethod = 0;
    update();
  }

  String currentBalance = '0';
  MakePaymentCharge? makePaymentCharge;
  List<LatestMakePaymentHistory> makePaymentHistory = [];
  List<String> otpTypeList = [];
  String selectedOtpType = "null";

  void selectotpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  double mainAmount = 0;
  String charge = "";
  String totalCharge = "";
  String payableText = '';
  String currency = '';
  String currencySym = '';
  String percentCharge = "";
  String fixedCharge = "";

  void changeInfoWidget() {
    currency = makePaymentRepo.apiClient.getCurrencyOrUsername(isSymbol: false);
    currencySym = makePaymentRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    update();
    mainAmount = double.tryParse(amountController.text) ?? 0.0;
    update();
    double percent = double.tryParse(percentCharge) ?? 0;

    double tempPercentCharge = mainAmount * percent / 100;
    double tempFixedCharge = double.tryParse(fixedCharge) ?? 0;
    double tempTotalCharge = tempPercentCharge + tempFixedCharge;

    charge = Converter.formatNumber('$tempTotalCharge', precision: 2);
    double payable = tempTotalCharge + mainAmount;
    payableText = Converter.formatNumber(payable.toString(), precision: 2);
    update();
  }

// sendMoney datas
  Future<void> makePaymentData() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await makePaymentRepo.getMakePaymentData();
    if (responseModel.statusCode == 200) {
      MakepaymentResponseModal modal = MakepaymentResponseModal.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == "success") {
        final data = modal.data;
        if (data != null) {
          currentBalance = data.currentBalance.toString();

          otpTypeList.clear();
          otpTypeList.addAll(data.otpType!.toList());

          // makePaymentCharge = data.makePaymentCharge;
          percentCharge = data.makePaymentCharge?.merchantPercentCharge ?? "0.0";
          fixedCharge = data.makePaymentCharge?.merchantFixedCharge ?? "0.0";
          update();

          if (data.latestMakePaymentHistory != null) {
            makePaymentHistory.clear();
            makePaymentHistory.addAll(data.latestMakePaymentHistory!.toList());
            update();
          }
        }
      } else {
        CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  Future<void> checkMarchantExist({bool fromQr = false}) async {
    isLoading = true;
    update();
    String name = '';
    if (selectedMethod == 1) {
      name = selectedContact!.number.toString();
    } else {
      name = numberController.text.toString();
    }
    ResponseModel responseModel = await makePaymentRepo.checkMerchant(merchant: name);
    if (responseModel.statusCode == 200) {
      MarchentExistingModel modal = MarchentExistingModel.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == "success") {
        if (modal.data != null) {
          selectedContact = UserContactModel(name: modal.data!.user?.username?.toString() ?? "", number: modal.data!.user?.mobile.toString() ?? "");
          update();
          if (!fromQr) Get.toNamed(RouteHelper.makePaymentAmountScreen);
        }
      } else {
        CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.userNotFound]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

//submit
  Future<void> submitMakePayment() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await makePaymentRepo.submitPayment(
      amount: mainAmount.toString(),
      otpType: selectedOtpType,
      pin: pinController.text,
      merchant: selectedContact?.number.toString() ?? "",
    );
    if (responseModel.statusCode == 200) {
      MakePaymentSubmitResponseModal modal = MakePaymentSubmitResponseModal.fromJson(jsonDecode(responseModel.responseJson));

      if (modal.status == "success") {
        Get.back();

        if (modal.data?.actionID == 'null') {
          Get.toNamed(RouteHelper.makePaymentSuccessScreen, arguments: [responseModel]);
          CustomSnackBar.success(successList: [MyStrings.makePaymentSuccess]);
        } else {
          Get.toNamed(
            RouteHelper.otpScreen,
            arguments: [
              modal.data?.actionID,
              RouteHelper.makePaymentSuccessScreen,
              pinController.text.toString(),
              selectedOtpType,
            ],
          );
        }
      } else {
        Get.back();
        CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      Get.back();
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  bool validatePinCode() {
    if (pinController.text.length != 4) {
      MyUtils.vibrate();
      CustomSnackBar.error(errorList: [MyStrings.pinLengthErrorMessage]);
      return false;
    }
    if (pinController.text.isEmpty) {
      MyUtils.vibrate();
      CustomSnackBar.error(errorList: [MyStrings.pinErrorMessage]);
      return false;
    }

    return true;
  }

  //danger clear all recent value
  void clearAllList() {
    clearValueFromSF(SharedPreferenceHelper.mPaymentRecentKey);
  }

  //
  List<LatestMakePaymentHistory> paymentHistoryList = [];
  //
  int page = 0;
  String? nextPageUrl;
  clearPageData() {
    page = 0;
    nextPageUrl = null;
    update();
  }

  // histroy
  Future<void> getPaymentHistory() async {
    page = page + 1;
    if (page == 1) {
      paymentHistoryList.clear();
      isLoading = true;
      update();
    }
    try {
      ResponseModel responseModel = await makePaymentRepo.history(page: page.toString());
      if (responseModel.statusCode == 200) {
        MakePaymentHistoryResponseModel model = MakePaymentHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          nextPageUrl = model.data?.history?.nextPageUrl;
          paymentHistoryList.addAll(model.data?.history?.data ?? []);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message?.error ?? []);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      print(e.toString());
    }

    isLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }
}
