// ignore_for_file: avoid_print

import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class TransactionRepo {
  ApiClient apiClient;
  TransactionRepo({required this.apiClient});

  Future<ResponseModel> getTransactionData(
    int page, {
    String searchText = "",
    String transactionType = "",
    String remark = "",
    String historyFrom = "",
  }) async {
    String days = "";

    if (transactionType.isEmpty || transactionType.toLowerCase() == "all type") {
      transactionType = "";
    } else {
      transactionType = transactionType;
    }
    if (historyFrom.isNotEmpty && historyFrom.toLowerCase() != MyStrings.any) {
      days = getOnlynumber(historyFrom);
    }
    if (remark.isEmpty || remark.toLowerCase() == "all remark") {
      remark = "";
    }
    if (searchText.isEmpty) {
      searchText = "";
    }
    print(historyFrom);
    String url = "${UrlContainer.baseUrl}${UrlContainer.transactionEndpoint}?page=$page&type=$transactionType&remark=$remark&search=$searchText&days=$days";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}

String getOnlynumber(String time) {
  if (time.contains("days")) {
    return time.split("days")[0];
  } else if (time.contains("month")) {
    return (int.parse(time.split("month")[0]) * 30).toString();
  } else if (time.contains("year")) {
    return (int.parse(time.split("year")[0]) * 365).toString();
  }
  return "All Time";
}
