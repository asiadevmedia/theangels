
import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class PinRepo {
  ApiClient apiClient;
  PinRepo({required this.apiClient});

  Future<ResponseModel> updatePin({required String pin, required String password}) async {
    String url = UrlContainer.baseUrl + UrlContainer.pinEndPoint;
    Map<String, String> params = {'pin': pin, 'current_password': password};

    final response = await apiClient.request(url, Method.postMethod, params, passHeader: true,);
    return response;
  }
}
