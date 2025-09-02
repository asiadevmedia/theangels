import 'dart:convert';

import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/paybill/paybill_success_model.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:http/http.dart' as http;

class PaybillRepo {
  ApiClient apiClient;
  PaybillRepo({required this.apiClient});

  Future<ResponseModel> getPaybillData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.paybillEndPoint}';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> getPayBillHistory(String page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.paybillHistoryEndPoint}?page=$page';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> submitBill({
    required String utilityID,
    required String amount,
    required String otpType,
    required String pin,
    required List<GlobalFormModle> list,
  }) async {
    apiClient.initToken();
    if (list.isNotEmpty) {
      await modelToMap(list);
    }
    String url = '${UrlContainer.baseUrl}${UrlContainer.paybillEndPoint}';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String, String> finalMap = {
      'utility_id': utilityID,
      'amount': amount,
      'otp_type': otpType,
      'pin': pin,
    };

    for (var element in fieldList) {
      finalMap.addAll(element);
    }

    request.headers.addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});

    for (var file in filesList) {
      request.files.add(http.MultipartFile(file.key ?? '', file.value.readAsBytes().asStream(), file.value.lengthSync(), filename: file.value.path.split('/').last));
    }

    request.fields.addAll(finalMap);

    http.StreamedResponse response = await request.send();
    String jsonResponse = await response.stream.bytesToString();

    PaybillSuccessResponseModel model = PaybillSuccessResponseModel.fromJson(jsonDecode(jsonResponse));
    if (model.status == "success") {
      return ResponseModel(model.status == "success" ? true : false, "", 200, jsonResponse);
    } else {
      return ResponseModel(model.status == "error" ? true : false, "", response.statusCode, jsonResponse);
    }
  }


  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<dynamic> modelToMap(List<GlobalFormModle> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.imageFile != null) {
          filesList.add(ModelDynamicValue(e.label, e.imageFile!));
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldList.add({e.label ?? '': e.selectedValue.toString()});
        }
      }
    }
  }


  Future<ResponseModel> downLoadinvoice({required String id}) {
    String url = '${UrlContainer.baseUrl}${UrlContainer.paybillDownLoad}/$id';
    final response = apiClient.request(url, Method.getMethod, null);
    return response;
  }
}

class ModelDynamicValue {
  String? key;
  dynamic value;
  ModelDynamicValue(this.key, this.value);
}
