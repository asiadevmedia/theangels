import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class NotificationSettingsRepo {

  ApiClient apiClient;
  NotificationSettingsRepo({required this.apiClient});

  Future<ResponseModel> getNotificationSettings() {
    String url = UrlContainer.baseUrl + UrlContainer.notificationSettingsEndPoint;
    final response = apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> changeNotificationSettings({required bool isEmail, required bool isPush, required bool isAllowPromotional}) {
    String url = UrlContainer.baseUrl + UrlContainer.notificationSettingsEndPoint;
    Map<String, String> params = {
      "en": isEmail ? "1" : "0",
      "pn": isPush ? "1" : "0",
      "is_allow_promotional_notify": isAllowPromotional ? "1" : "0",
    };

    final response = apiClient.request(url, Method.postMethod, params, passHeader: true);
    return response;
  }
}
