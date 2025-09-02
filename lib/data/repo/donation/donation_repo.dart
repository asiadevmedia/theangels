import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';

class DonationRepo {
  ApiClient apiClient;
  DonationRepo({required this.apiClient});

  Future<ResponseModel> getDonationHistory(String page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.donationHistoryEndPoint}?page=$page';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> getDonationData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.donationEndPoint}?page=2';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> submitDonation({
    required String pin,
    required String donationID,
    required String amount,
    required String otpType,
    required String email,
    required String name,
    required String hideIdentity,
    String? reference,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.donationEndPoint}';
    Map<String, String> params = {
      'pin': pin,
      'setup_donation_id': donationID,
      'amount': amount,
      'otp_type': otpType,
      'email': email,
      'name': name,
      'hide_identity': hideIdentity,
      'reference': reference ?? '',
    };
    final responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }
}
