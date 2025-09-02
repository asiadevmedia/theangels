import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class AddMoneyHistoryRepo {
  ApiClient apiClient;
  AddMoneyHistoryRepo({required this.apiClient});

  Future<ResponseModel> getAddMoneyHistoryData(int page, {String searchText = ""}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.addMoneyHistoryEndPoint}?page=$page&search=$searchText";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
