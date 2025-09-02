import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class MakePaymentRepo {
  ApiClient apiClient;
  MakePaymentRepo({required this.apiClient});

  Future<dynamic> getMakePaymentData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.makePaymentUrl}";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);

    return responseModel;
  }

  Future<ResponseModel> submitPayment({required String pin, required String amount, required String merchant, required String otpType, String? reference}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.makePaymentVerifyOtpUrl}";

    Map<String, String> params = {
      "pin": pin,
      "amount": amount,
      "merchant": merchant,
      "otp_type": otpType,
      "reference": reference.toString(),
    };

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);

    return responseModel;
  }

  Future<ResponseModel> checkMerchant({required String merchant}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.makePaymentCheckMerchantUrl}";
    Map<String, String> params = {"merchant": merchant};
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);

    return responseModel;
  }

  Future<ResponseModel> history({required String page}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.makePaymentUrl}/history?page=$page';

    final responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
