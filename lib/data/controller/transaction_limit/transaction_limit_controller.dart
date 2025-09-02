import 'dart:convert';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/transaction_limit/transaction_limit_model.dart';
import 'package:viserpay/data/repo/transaction-limit/transaction_limit_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class TransactionLimitController extends GetxController {
  TransactionLimitRepo repo;
  TransactionLimitController({required this.repo});

  bool isLoading = false;
  String currency = "";
  String currencySym = "";

  List<TransactionChargeModel> transactionChargeList = [];

  loadData() {
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    getTransactionCharges();
  }

  Future<void> getTransactionCharges() async {
    isLoading = true;
    update();

    final response = await repo.getTransactionLimit();
    if (response.statusCode == 200) {
      TransactionLimitResponseModel model = TransactionLimitResponseModel.fromJson(jsonDecode(response.responseJson));
      if (model.status == "success") {
        List<TransactionChargeModel>? tempList = model.data?.transactionCharge;
        if (tempList != null && tempList.isNotEmpty) {
          transactionChargeList.clear();
          transactionChargeList.addAll(tempList);
        }
        update();
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
  }
}
