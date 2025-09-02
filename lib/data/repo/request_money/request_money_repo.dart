import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class RequestMoneyRepo {
  ApiClient apiClient;
  RequestMoneyRepo({required this.apiClient});

  Future<ResponseModel> getWalletData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.requestMoneyEndPoint}";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> submitRequestMoney({
    required String walletId,
    required String amount,
    required String username,
    required String note,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.requestMoneySubmitEndPoint}";
    Map<String, String> params = {
      "wallet_id": walletId,
      "amount": amount,
      "user": username,
      "note": note,
    };

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> checkUser({required String user}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.checkUserUrl}";
    Map<String, String> params = {"user": user};
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }
}
