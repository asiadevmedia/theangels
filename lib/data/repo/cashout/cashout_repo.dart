import 'dart:developer';

import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class CashoutRepo {
  ApiClient apiClient;
  CashoutRepo({required this.apiClient});

  Future<ResponseModel> getCashoutData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cashOutEndpoint}';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> checkUser({required String usernameOrmobile}) async {
    log(usernameOrmobile);
    String url = '${UrlContainer.baseUrl}${UrlContainer.checkAgentUrl}';
    Map<String, String> params = {'agent': usernameOrmobile};
    final responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> cashout({
    required String amount,
    required String usernameOrmobile,
    required String otpType,
    required String pin,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cashOutEndpoint}';
    log(usernameOrmobile);
    Map<String, String> params = {
      'agent': usernameOrmobile,
      'amount': amount,
      'otp_type': otpType,
      'pin': pin,
    };
    log(params.toString());
    final responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> history({required String page}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cashOutEndpoint}/history?page=$page';

    final responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
