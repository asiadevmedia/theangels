// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/transctions/transaction_response_model.dart' as transaction;
import 'package:viserpay/data/repo/transaction/transaction_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class TransactionHistoryController extends GetxController {
  TransactionRepo transactionRepo;
  TransactionHistoryController({required this.transactionRepo});

  bool isLoading = true;

  List<String> transactionTypeList = ["All Type", "Plus", "Minus"];
  List<String> operationTypeList = [];
  List<String> historyFormList = [];
  List<String> walletCurrencyList = [];
  List<String> remarkList = [];

  List<transaction.Data> transactionList = [];

  String trxSearchText = "";
  String? nextPageUrl;
  int page = 0;
  String currency = "";
  String currencySym = "";

  TextEditingController trxController = TextEditingController();

  String selectedTransactionType = MyStrings.allType;
  String selectedOperationType = "";
  String selectedHistoryFrom = "";
  String selectedRemark = MyStrings.allRemarks;

  setSelectedTransactionType(String? trxType) {
    selectedTransactionType = trxType ?? "";
    update();
  }

  setSelectedRemark(String? remark) {
    selectedRemark = remark ?? "";
    update();
  }

  setSelectedHistoryFrom(String? historyFrom) {
    selectedHistoryFrom = historyFrom!;
    update();
  }

  void loadDefaultData(String trxType) {
    if (trxType.isNotEmpty) {
      selectedTransactionType = trxType;
      isSearch = true;
    } else {
      selectedTransactionType = MyStrings.allType;
    }

    initialSelectedValue();
  }

  void initialSelectedValue() async {
    page = 0;
    currency = transactionRepo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = transactionRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    selectedOperationType = "";
    selectedHistoryFrom = "";

    trxController.text = "";
    trxSearchText = "";
    transactionList.clear();
    historyFormList.clear();
    selectedTransactionType = MyStrings.allType;
    selectedRemark = MyStrings.allRemarks;
    selectedHistoryFrom = MyStrings.any;
    isLoading = true;
    update();
    await loadTransactionData();
    isLoading = false;
    update();
  }

  Future<void> loadTransactionData() async {
    page = page + 1;

    if (page == 1) {
      operationTypeList.clear();
      operationTypeList.insert(0, MyStrings.allOperations);
      transactionList.clear();
      historyFormList.clear();
    }

    ResponseModel responseModel = await transactionRepo.getTransactionData(
      page,
      searchText: trxSearchText,
      transactionType: selectedTransactionType.toLowerCase(),
      remark: selectedRemark.toLowerCase(),
      historyFrom: selectedHistoryFrom,
    );

    if (responseModel.statusCode == 200) {
      transaction.TransactionResponseModel model = transaction.TransactionResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      nextPageUrl = model.data?.transactions?.nextPageUrl;

      if (model.status.toString().toLowerCase() == "success") {
        List<transaction.Data>? tempDataList = model.data?.transactions?.data;
        if (tempDataList != null && tempDataList.isNotEmpty) {
          transactionList.addAll(tempDataList);
        }

        List<String>? tempRemarkList = model.data?.remarks;
        if (tempRemarkList != null && tempRemarkList.isNotEmpty) {
          remarkList.clear();
          remarkList.add(MyStrings.allRemarks);
          remarkList.addAll(tempRemarkList);
        }

        List<String>? tempOperationList = model.data?.operations;
        if (tempOperationList != null || tempOperationList!.isNotEmpty) {
          operationTypeList.addAll(tempOperationList);
        }
        List<String>? tempHistroyList = model.data?.times;
        if (tempHistroyList != null || tempHistroyList!.isNotEmpty) {
          print(tempHistroyList.length);
          historyFormList.addAll(tempHistroyList);
          print(historyFormList.length);
        }
        update();
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    update();
  }

  Future<void> loadFilteredTransactions() async {
    page = page + 1;

    if (page == 1) {
      transactionList.clear();
    }

    ResponseModel responseModel = await transactionRepo.getTransactionData(
      page,
      searchText: trxSearchText,
      transactionType: selectedTransactionType.toLowerCase(),
      remark: selectedRemark.toLowerCase(),
      historyFrom: selectedHistoryFrom,
    );

    if (page == 1) {
      transactionList.clear();
    }

    if (responseModel.statusCode == 200) {
      transaction.TransactionResponseModel model = transaction.TransactionResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      nextPageUrl = model.data?.transactions?.nextPageUrl;

      if (model.status.toString().toLowerCase() == "success") {
        List<transaction.Data>? tempDataList = model.data?.transactions?.data;
        if (tempDataList != null && tempDataList.isNotEmpty) {
          transactionList.addAll(tempDataList);
        }
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    update();
  }

  bool filterLoading = false;

  Future<void> filterData() async {
    trxSearchText = trxController.text;
    page = 0;
    filterLoading = true;
    update();
    transactionList.clear();
    FocusScope.of(Get.context!).unfocus();
    await loadFilteredTransactions();
    filterLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();
    if (!isSearch) {
      selectedTransactionType = MyStrings.allType;
      initialSelectedValue();
    }
  }
}
