import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class TransactionLimitRepo {
  ApiClient apiClient;
  TransactionLimitRepo({required this.apiClient});
  Future<ResponseModel> getTransactionLimit() async {
    String url = UrlContainer.baseUrl + UrlContainer.limit;
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }
}
