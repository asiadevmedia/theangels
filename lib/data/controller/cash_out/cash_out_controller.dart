// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/cash_out/cash_out_history_response_model.dart';
import 'package:viserpay/data/model/cash_out/cash_out_response_modal.dart';
import 'package:viserpay/data/model/cash_out/cash_out_submit_response.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/model/global/agent_exist/agent_check_response_modal.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/cashout/cashout_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class CashOutController extends GetxController {
  CashoutRepo cashoutRepo;
  CashOutController({required this.cashoutRepo});

  bool isLoading = false;
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  FocusNode numberFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();

  List<UserContactModel> recentList = [];
  List<String> quickAmountList = [];

  void initialValue() async {
    numberFocusNode.unfocus();
    quickAmountList = cashoutRepo.apiClient.getQuickAmountList();
    curSymbol = cashoutRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    currency = cashoutRepo.apiClient.getCurrencyOrUsername(isCurrency: true);

    amountFocusNode.unfocus();
    amountController.text = '';
    amountController.clear();

    pinController.text = '';
    pinController.clear();

    numberController.text = '';
    numberController.clear();

    clearUser();
    isLoading = true;
    update();
    await loadCashOutData();

    isLoading = false;
    update();
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
  void clearUser() {
    selectedContact = UserContactModel(name: "-1", number: "-1");
    update();
  }

  void selectContact(UserContactModel contact, {bool shouldCheckUser = false}) {
    if (contact.number.isNotEmpty) {
      selectedContact = contact;
      numberController.clear();
      update();

      if (shouldCheckUser) {
        checkUserAndGoToAmountScreen();
      }
    } else {
      selectedContact = null;
      CustomSnackBar.error(errorList: [MyStrings.selectAvailableNumberPlease]);
    }
  }

  int selectedMethod = -1; // note: 0 for number and 1 for contact

  String currentBalance = "0";
  double mainAmount = 0;
  String charge = "";
  String payableText = '';
  String curSymbol = '';
  String currency = '';
  String percentCharge = "";
  String fixedCharge = "";

  void changeInfoWidget() {
    curSymbol = cashoutRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    currency = cashoutRepo.apiClient.getCurrencyOrUsername(isSymbol: false);
    mainAmount = double.tryParse(amountController.text) ?? 0.0;

    double percent = double.tryParse(percentCharge) ?? 0;

    double tempPercent = (mainAmount * percent) / 100;
    double tempFixed = double.tryParse(fixedCharge) ?? 0;

    double tempTotalCharge = tempPercent + tempFixed;

    charge = Converter.formatNumber('$tempTotalCharge', precision: 2);

    double payable = tempTotalCharge + mainAmount;
    payableText = Converter.formatNumber(payable.toString(), precision: 2);
    update();
  }

  List<String> otpTypeList = [];
  String selectedOtpType = "null";
  void selectotpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  CashoutCharge? cashOutCharge;
  List<LatestCashOutHistory> latestCashOutHistory = [];

  Future<void> loadCashOutData() async {
    ResponseModel responseModel = await cashoutRepo.getCashoutData();
    if (responseModel.statusCode == 200) {
      CashOutResponseModal modal = CashOutResponseModal.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == "success") {
        final data = modal.data;
        if (data != null) {
          cashOutCharge = modal.data?.cashOutCharge;
          currentBalance = data.currentBalance.toString();

          percentCharge = cashOutCharge?.percentCharge.toString() ?? "0.0";
          fixedCharge = cashOutCharge?.fixedCharge.toString() ?? "0.0";
          otpTypeList.clear();
          otpTypeList.addAll(data.otpType?.toList() ?? []);
        }
        if (data?.latestCashOutHistory != null) {
          final list = data!.latestCashOutHistory?.toList() ?? [];
          latestCashOutHistory.clear();
          latestCashOutHistory.addAll(list);
        }
      } else {
        CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
  }

  Future<void> checkUserAndGoToAmountScreen() async {
    String name = '';

    name = selectedContact?.number.toString() ?? "";

    isLoading = true;
    update();

    ResponseModel responseModel = await cashoutRepo.checkUser(usernameOrmobile: name);
    if (responseModel.statusCode == 200) {
      AgentCheckResponseModal modal = AgentCheckResponseModal.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == "success") {
        if (modal.data != null) {
          selectedContact = UserContactModel(name: modal.data?.user?.username?.toString() ?? "", number: modal.data?.user?.mobile.toString() ?? "");
          Get.toNamed(RouteHelper.cashOutAmountScreen);
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
  Future<void> submitCashOutData() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await cashoutRepo.cashout(
      amount: mainAmount.toString(),
      otpType: selectedOtpType,
      pin: pinController.text,
      usernameOrmobile: selectedContact?.number.toString() ?? "",
    );
    if (responseModel.statusCode == 200) {
      CashoutSubmitResponseModal modal = CashoutSubmitResponseModal.fromJson(jsonDecode(responseModel.responseJson));

      if (modal.status == "success") {
        Get.back();
        if (modal.data?.actionID == 'null') {
          Get.toNamed(RouteHelper.cashOutSuccessScreen, arguments: [responseModel]);
          CustomSnackBar.success(successList: [MyStrings.cashOutSuccessMessage]);
        } else {
          Get.toNamed(
            RouteHelper.otpScreen,
            arguments: [
              modal.data?.actionID,
              RouteHelper.cashOutSuccessScreen,
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

//
  int page = 0;
  String? nextPageUrl;
  clearPageData() {
    page = 0;
    nextPageUrl = null;
    update();
  }

  List<LatestCashOutHistory> cashOutHistoryList = [];
  //
  // histroy
  Future<void> getCashoutHistory() async {
    page = page + 1;
    if (page == 1) {
      cashOutHistoryList.clear();
      isLoading = true;
      update();
    }
    try {
      ResponseModel responseModel = await cashoutRepo.history(page: page.toString());
      if (responseModel.statusCode == 200) {
        CashoutHistoryResponseModel model = CashoutHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          nextPageUrl = model.data?.history?.nextPageUrl;
          cashOutHistoryList.addAll(model.data?.history?.data ?? []);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message?.error ?? []);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }
}
