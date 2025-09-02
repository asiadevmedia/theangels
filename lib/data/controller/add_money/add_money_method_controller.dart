// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/add_money/add_money_insert_response_model.dart';
import 'package:viserpay/data/model/add_money/add_money_method_response_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/add_money/add_money_method_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class AddMoneyMethodController extends GetxController {
  AddMoneyMethodRepo addMoneyMethodRepo;
  AddMoneyMethodController({required this.addMoneyMethodRepo});

  bool isLoading = true;
  String currency = "";
  String currencySym = "";

  PaymentMethods selectedPaymentMethods = PaymentMethods(id: -1);

  String initialOtpType = "";
  String minLimit = "";
  String maxLimit = "";
  String conversionRate = '';
  String inMethodPayable = '';

  TextEditingController amountController = TextEditingController();
  String amount = "";

  double mainAmount = 0;
  double rate = 1;

  List<PaymentMethods> paymentMethodsList = [];

  selectPaymentMethod(PaymentMethods paymentMethods) {
    if (paymentMethods.id != -1) {
      selectedPaymentMethods = paymentMethods;
      minLimit = Converter.formatNumber(paymentMethods.minAmount.toString(), precision: (int.tryParse(paymentMethods.methodCode.toString()) ?? 0) > 499 ? 8 : 2);
      maxLimit = Converter.formatNumber(paymentMethods.maxAmount.toString(), precision: (int.tryParse(paymentMethods.methodCode.toString()) ?? 0) > 499 ? 8 : 2);
      rate = double.tryParse(paymentMethods.rate ?? '0') ?? 0;
      conversionRate = '1 $currency = $rate ${paymentMethods.currency ?? ''}';
      update();
      double amount = double.tryParse(amountController.text) ?? 0.0;
      changeInfoWidgetValue(amount);
    }
  }

  loadData() async {
    paymentMethodsList.clear();
    amountController.text = "";
    selectedPaymentMethods = PaymentMethods(id: -1);
    currency = addMoneyMethodRepo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = addMoneyMethodRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    rate = -1;
    conversionRate = "";
    amount = "";
    inMethodPayable = "";
    mainAmount = 0.0;
    update();
    ResponseModel responseModel = await addMoneyMethodRepo.getAddMoneyMethodData();
    if (responseModel.statusCode == 200) {
      AddMoneyResponseModel model = AddMoneyResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.message != null && model.message?.success != null) {
        List<PaymentMethods>? tempMethodList = model.data?.methods?.toList();
        if (tempMethodList != null && tempMethodList.isNotEmpty) {
          paymentMethodsList.addAll(tempMethodList);
          update();
        }
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> submitData() async {
    if (selectedPaymentMethods.id.toString() == "-1") {
      CustomSnackBar.error(errorList: [MyStrings.selectMethod]);
      return;
    }

    if (amountController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterAmountMsg.tr]);
      return;
    }

    String amount = amountController.text.toString();

    submitLoading = true;
    update();

    ResponseModel responseModel = await addMoneyMethodRepo.insertMoney(
      amount: amount,
      methodCode: selectedPaymentMethods.methodCode ?? "",
      currency: selectedPaymentMethods.currency ?? "",
    );

    if (responseModel.statusCode == 200) {
      AddMoneyInsertResponseModel model = AddMoneyInsertResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
        showWebView(model.data?.redirectUrl ?? "");
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  String charge = "";
  String payable = "";
  String payableText = '';
  void changeInfoWidgetValue(double amount) {
    print(amount);
    print(amount);
    print(amount);
    if (selectedPaymentMethods.id.toString() == "-1") {
      return;
    }
    mainAmount = amount;
    double percent = double.tryParse(selectedPaymentMethods.percentCharge ?? '0') ?? 0;
    double percentCharge = (amount * percent) / 100;
    double temCharge = double.tryParse(selectedPaymentMethods.fixedCharge ?? '0') ?? 0;
    double totalCharge = percentCharge + temCharge;
    charge = '${Converter.formatNumber('$totalCharge', precision: 2)} $currency';
    double payable = totalCharge + amount;
    payableText = '${Converter.formatNumber('$payable', precision: 2)} $currency';
    // inMethodPayable = '${selectedPaymentMethods.currency ?? ''} ${Converter.formatNumber('${rate * payable}', precision: 2)}'; //
    inMethodPayable = Converter.formatNumber('${rate * payable}', precision: 2); //

    update();
  }

  void showWebView(String redirectUrl) {
    Get.offAndToNamed(RouteHelper.addMoneyWebScreen, arguments: redirectUrl);
  }
}
