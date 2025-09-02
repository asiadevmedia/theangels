import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class RechargeRepo {
  ApiClient apiClient;
  RechargeRepo({required this.apiClient});

  Future<ResponseModel> rechargeData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.mobilerechargeEndpoint}';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> submitRecharge({required String amount, required String mobile, required String otpType, required String pin, required String operatorID}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.mobilerechargeEndpoint}';
    Map<String, String> params = {
      'mobile': mobile,
      'amount': amount,
      'otp_type': otpType,
      'pin': pin,
      'operator_id': operatorID,
    };
    final response = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return response;
  }

  Future<ResponseModel> history({required String page}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.mobilerechargeEndpoint}/history?page=$page';

    final responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
