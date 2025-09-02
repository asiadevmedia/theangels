// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/bank-transfer/add_bank_response_model.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:http/http.dart' as http;

class BankTransferRepo {
  ApiClient apiClient;
  BankTransferRepo({required this.apiClient});

  Future<ResponseModel> getBankTransferHistroy(String page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.bankTransferHistoryEndPoint}?page=$page';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> getBankTransferData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.bankTransferEndPoint}';
    final response = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> transferAmount({
    required String bankId,
    required String amount,
    required String otpType,
    required String pin,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.bankTransferEndPoint}';
    Map<String, String> params = {
      'user_bank_id': bankId,
      'amount': amount,
      'otp_type': otpType,
      'pin': pin,
    };
    final response = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return response;
  }

  Future<ResponseModel> removeUserAddedBank({
    required String bankId,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.bankDeleteEndPoint}';
    Map<String, String> params = {
      'user_bank_id': bankId,
    };
    final response = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return response;
  }

  Future<AddBankResponseModel> addNewBank({
    required String bankId,
    required String name,
    required String accountNumber,
    required List<GlobalFormModle> list,
  }) async {
    apiClient.initToken();

    try{
      await modelToMap(list);
      String url = '${UrlContainer.baseUrl}${UrlContainer.addBankEndPoint}';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      Map<String, String> finalMap = {
        'bank_id': bankId,
        'account_number': accountNumber,
        'account_holder': name,
      };

      for (var element in fieldList) {
        finalMap.addAll(element);
      }
      log(finalMap.toString());

      request.headers.addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});

      for (var file in filesList) {
        request.files.add(http.MultipartFile(file.key ?? '', file.value.readAsBytes().asStream(), file.value.lengthSync(), filename: file.value.path.split('/').last));
      }

      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();



      String jsonResponse = await response.stream.bytesToString();
      print('-------${url.toString()}');
      print('-----response: ${jsonResponse.toString()}');
      AddBankResponseModel model = AddBankResponseModel.fromJson(jsonDecode(jsonResponse));
      return model;
    } catch(e){
      print('---------${e.toString()}');
      return AddBankResponseModel(remark: 'error',status: 'error');
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
          fieldList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }
}

class ModelDynamicValue {
  String? key;
  dynamic value;
  ModelDynamicValue(this.key, this.value);
}
