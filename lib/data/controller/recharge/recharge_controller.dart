// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/sf_utils.dart';
import 'package:viserpay/data/controller/contact/contact_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/recharge/recharge_data_response_modal.dart';
import 'package:viserpay/data/model/recharge/recharge_history_response_model.dart';
import 'package:viserpay/data/model/recharge/recharge_submit_response_modal.dart';
import 'package:viserpay/data/repo/recharge/recharge_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class RechargeContrller extends GetxController {
  RechargeRepo rechargeRepo;
  ContactController contactController;
  RechargeContrller({required this.rechargeRepo, required this.contactController});
  TextEditingController amountController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  FocusNode amountFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();

  bool isLoading = false;

  List<String> quickAmountList = [];
  bool isContactPermissonEnabled = false;

  void initialValue() {
    amountFocusNode.unfocus();
    amountController.text = '';
    amountController.clear();
    selectedoperator;
    contactController.getContact().then((value) {
      update();
    });
    currency = rechargeRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    currencyText = rechargeRepo.apiClient.getCurrencyOrUsername(isCurrency: true);
    userName = rechargeRepo.apiClient.getCurrencyOrUsername(isCurrency: false);
    quickAmountList = rechargeRepo.apiClient.getQuickAmountList();
    update();
    rechargeData();
  }
//info: number validation :note: currently unused

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
//info: select contact

  UserContactModel? selectedContact;
  int selectedMethod = 1; // note: 0 for number and 1 for contact

  void selectContact(UserContactModel contact) {
    if (contact.number.isNotEmpty) {
      selectedContact = contact;
      selectedMethod = 1;
      update();

      numberController.clear();
      contactController.filterContact.clear();
      contactController.filterContact.addAll(contactController.contacts);
      Get.toNamed(RouteHelper.rechargeOpartorScreen, arguments: contact);
    } else {
      selectedContact = null;
      CustomSnackBar.error(errorList: [MyStrings.selectAvailableNumberPlease]);
    }
  }

  void changeSelectedMethod() {
    selectedMethod = 0;
    update();
  }
//info: recharge operator

  MobileOperator? selectedoperator;
  void clearOperator() {
    selectedoperator = MobileOperator(id: -1);
    update();
  }

  void selectOperator(MobileOperator mobileOperator) {
    selectedoperator = mobileOperator;
    update();
    Get.toNamed(RouteHelper.rechargeAmountScreen);
  }

//info: select recent Recharge and go to amount screen
  void selectRecentRecharge({required UserContactModel contact, required MobileOperator operator}) {
    if (contact.number.isNotEmpty && operator.id != -1) {
      selectedContact = contact;
      selectedoperator = operator;

      selectedMethod = 1;
      update();

      numberController.clear();
      contactController.filterContact.clear();
      contactController.filterContact.addAll(contactController.contacts);
      //
      Get.toNamed(RouteHelper.rechargeAmountScreen);
    } else {
      selectedContact = null;
      selectedoperator = null;
      CustomSnackBar.error(errorList: [MyStrings.selectAvailableNumberPlease]);
    }
  }

//info: user charges calculate function
  double mainAmount = 0;
  String charge = "";
  String payableText = '';
  String currency = '';
  String currencyText = '';
  void changeInfoWidget() {
    mainAmount = double.tryParse(amountController.text) ?? 0.0;
    update();
    double percent = double.tryParse(rechargeCharge?.percentCharge ?? "0") ?? 0;
    double percentCharge = mainAmount * percent / 100;
    double fixedCharge = double.tryParse(rechargeCharge?.fixedCharge ?? "0") ?? 0;
    double tempTotalCharge = percentCharge + fixedCharge;

    charge = Converter.formatNumber('$tempTotalCharge', precision: 2);
    double payable = tempTotalCharge + mainAmount;
    payableText = Converter.formatNumber(payable.toString(), precision: 2);
    isLoading = false;
    update();
  }

  String currentBalance = "0";
  String userName = "0";
  String userPhone = "0";
  String userImage = "0";
  List<String> otpTypeList = [];
  String selectedOtpType = "null";
  RechargeCharge? rechargeCharge;
  List<LatestMobileRecharge> rechargeHistory = [];
  List<MobileOperator> operators = [];

//info: select otp type
  void selectotpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

//info: mobile recharge data , get recharge all information,
  Future<void> rechargeData() async {
    isLoading = true;
    isContactPermissonEnabled = await Permission.contacts.isGranted;
    update();
    ResponseModel responseModel = await rechargeRepo.rechargeData();
    if (responseModel.statusCode == 200) {
      RechargeResponseModel modal = RechargeResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == "success") {
        final data = modal.data;
        if (data != null) {
          currentBalance = data.currentBalance.toString();
          operators.clear();
          otpTypeList.clear();
          otpTypeList.addAll(data.otpType!.toList());
          if (data.mobileOperators != null) {
            operators.addAll(data.mobileOperators!.toList());
          }
          rechargeCharge = data.rechargeCharge;
          if (data.latestRechargeHistory != null) {
            rechargeHistory.clear();
            rechargeHistory.addAll(data.latestRechargeHistory!.toList());
          }
          update();
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

//info:: submit recharge
  Future<void> submitRechage() async {
    isLoading = true;
    update();

    if (selectedoperator == null) {
      CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOperator]);
    }
    ResponseModel responseModel = await rechargeRepo.submitRecharge(
      amount: amountController.text,
      mobile: selectedContact!.number,
      otpType: selectedOtpType,
      pin: pinController.text,
      operatorID: selectedoperator!.id.toString(),
    );
    RechargeSubmitResponseModel modal = RechargeSubmitResponseModel.fromJson(jsonDecode(responseModel.responseJson));

    if (modal.status == "success") {
      Get.back();
      if (modal.data?.actionID == 'null') {
        Get.toNamed(RouteHelper.rechargeSuccessScreen, arguments: [responseModel]);
        CustomSnackBar.success(successList: [MyStrings.rechargeSuccessMessage]);
      } else {
        Get.toNamed(
          RouteHelper.otpScreen,
          arguments: [
            modal.data?.actionID,
            RouteHelper.rechargeSuccessScreen,
            pinController.text.toString(),
            selectedOtpType,
          ],
        );
      }
    } else {
      Get.back();
      CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
    }
    isLoading = false;
    update();
  }

  void clearAllList() {
    clearValueFromSF(SharedPreferenceHelper.rechargeRecentKey);
  }

//info:: recharge history data is here
  int page = 0;
  String? nextPageUrl;
  clearPageData() {
    page = 0;
    nextPageUrl = null;
    update();
  }

  List<LatestMobileRecharge> rechargetHistoryList = [];

  Future<void> getRechargeHistory() async {
    page = page + 1;
    if (page == 1) {
      rechargetHistoryList.clear();
      isLoading = true;
      update();
    }
    try {
      ResponseModel responseModel = await rechargeRepo.history(page: page.toString());
      if (responseModel.statusCode == 200) {
        RechargeHistoryResponseModel model = RechargeHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          nextPageUrl = model.data?.history?.nextPageUrl;
          rechargetHistoryList.addAll(model.data?.history?.data ?? []);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message?.error ?? []);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      print('come only finaly---------');
    }

    print('come here---------');
    isLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }
}
