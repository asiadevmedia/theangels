// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/method.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/authorization/authorization_response_model.dart';
import 'package:viserpay/data/model/general_setting/general_setting_response_model.dart';
import 'package:viserpay/data/model/general_setting/module_settings_response_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';

class ApiClient extends GetxService {
  SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});

  Future<ResponseModel> request(
    String uri,
    String method,
    Map<String, dynamic>? params, {
    bool passHeader = false,
    bool isOnlyAcceptType = false,
  }) async {
    Uri url = Uri.parse(uri);
    http.Response response;

    try {
      if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          if (isOnlyAcceptType) {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
            });
          } else {
            response = await http.post(url, body: params, headers: {"Accept": "application/json", "Authorization": "$tokenType $token"});
          }
        } else {
          response = await http.post(url, body: params);
        }
      } else if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          response = await http.post(url, body: params, headers: {"Accept": "application/json", "Authorization": "$tokenType $token"});
        } else {
          response = await http.post(url, body: params);
        }
      } else if (method == Method.deleteMethod) {
        response = await http.delete(url);
      } else if (method == Method.updateMethod) {
        response = await http.patch(url);
      } else {
        if (passHeader) {
          initToken();
          response = await http.get(url, headers: {"Accept": "application/json", "Authorization": "$tokenType $token"});
        } else {
          response = await http.get(
            url,
          );
        }
      }

      print('url--------------${uri.toString()}');
      print('params-----------${params.toString()}');
      print('status-----------${response.statusCode}');
      print('body-------------${response.body.toString()}');
      print('token------------$token');

      if (response.statusCode == 200) {
        try {
          if (response.body.isEmpty) {
            await logoutUser();
          } else {
            AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(response.body));
            if (model.remark == 'profile_incomplete') {
              Get.toNamed(RouteHelper.profileCompleteScreen);
            } else if (model.remark == 'kyc_verification') {
              Get.offAndToNamed(RouteHelper.kycScreen);
            } else if (model.remark == 'unauthenticated') {
              await logoutUser();
            }
          }
        } catch (e) {
          e.toString();
        }

        return ResponseModel(true, 'Success', 200, response.body);
      } else if (response.statusCode == 401) {
        sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
        Get.offAllNamed(RouteHelper.loginScreen);
        return ResponseModel(false, MyStrings.unAuthorized.tr, 401, response.body);
      } else if (response.statusCode == 500) {
        return ResponseModel(false, MyStrings.serverError.tr, 500, response.body);
      } else {
        return ResponseModel(false, MyStrings.somethingWentWrong.tr, 499, response.body);
      }
    } on SocketException {
      return ResponseModel(false, MyStrings.noInternet.tr, 503, '');
    } on FormatException {
      return ResponseModel(false, MyStrings.badResponseMsg.tr, 400, '');
    } catch (e) {
      return ResponseModel(false, MyStrings.somethingWentWrong.tr, 499, '');
    }
  }

  String token = '';
  String tokenType = '';

  initToken() {
    if (sharedPreferences.containsKey(SharedPreferenceHelper.accessTokenKey)) {
      String? t = sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey);
      String? tType = sharedPreferences.getString(SharedPreferenceHelper.accessTokenType);
      token = t ?? '';
      tokenType = tType ?? 'Bearer';
    } else {
      token = '';
      tokenType = 'Bearer';
    }
  }

  Future<void> logoutUser() async {
    await sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
    await sharedPreferences.remove(SharedPreferenceHelper.token);
    Get.offAllNamed(RouteHelper.loginScreen);
  }

  storeGeneralSetting(GeneralSettingResponseModel model) async {
    String json = jsonEncode(model.toJson());
    await sharedPreferences.setString(SharedPreferenceHelper.generalSettingKey, json);
    getGSData();
  }

  GeneralSettingResponseModel getGSData() {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ?? '';
    GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(jsonDecode(pre));

    return model;
  }

  String getCurrencyOrUsername({bool isCurrency = true, bool isSymbol = false}) {
    if (isCurrency) {
      String pre = sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ?? '';
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(jsonDecode(pre));
      String currency = isSymbol ? model.data?.generalSetting?.curSym ?? '' : model.data?.generalSetting?.curText ?? '';
      return currency;
    } else {
      String username = sharedPreferences.getString(SharedPreferenceHelper.userNameKey) ?? '';
      return username;
    }
  }

  bool getPasswordStrengthStatus() {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ?? '';
    GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    bool checkPasswordStrength = model.data?.generalSetting?.securePassword.toString() == '0' ? false : true;
    return checkPasswordStrength;
  }

  String getTemplateName() {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ?? '';
    GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    String templateName = model.data?.generalSetting?.activeTemplate ?? '';
    return templateName;
  }

  storeModuleSetting(ModuleSettingsResponseModel model) {
    String json = jsonEncode(model.toJson());
    sharedPreferences.setString(SharedPreferenceHelper.moduleSettingKey, json);
    getModuleSettingsData();
  }

  ModuleSettingsResponseModel getModuleSettingsData() {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.moduleSettingKey) ?? '';
    ModuleSettingsResponseModel model = ModuleSettingsResponseModel.fromJson(jsonDecode(pre));
    return model;
  }

  bool getModuleStatus(String key) {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.moduleSettingKey) ?? '';
    ModuleSettingsResponseModel model = ModuleSettingsResponseModel.fromJson(jsonDecode(pre));
    List<User>? userModule = model.data?.moduleSetting?.user;

    var addMoneyModule = userModule?.where((element) => element.slug == key).first;
    bool status = addMoneyModule != null && addMoneyModule.status == '0' ? false : true;

    return status;
  }

  storeQuickAmountList(List<String> list) async {
    await sharedPreferences.setStringList(SharedPreferenceHelper.quickAmount, list);
  }

  List<String> getQuickAmountList() {
    List<String> pre = sharedPreferences.getStringList(SharedPreferenceHelper.quickAmount) ?? [];
    List<String> model = pre;
    return model;
  }

  bool getMultiLanguageStatus() {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ?? '';
    GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    return model.data?.generalSetting?.multiLanguage == "0" ? false : true;
  }

  bool getUserPinStatus() {
    String pre = sharedPreferences.getString(SharedPreferenceHelper.isPinSet) ?? '';
    bool isPinSet = pre == '0' ? false : true;
    return isPinSet;
  }

  storefingerprintStatus(bool status) {
    sharedPreferences.setBool(SharedPreferenceHelper.fingerprintStatus, status);
  }

  storeAppOpeningStatus(bool status) {
    sharedPreferences.setBool(SharedPreferenceHelper.appOpeningStatus, status);
  }

  bool getfingerprintStatus() {
    bool status = sharedPreferences.getBool(SharedPreferenceHelper.fingerprintStatus) ?? false;
    return status;
  }

  bool getFirstTimeAppOpeningStatus() {
    bool status = sharedPreferences.getBool(SharedPreferenceHelper.appOpeningStatus) ?? false;
    return status;
  }

  storePhone(String value) async {
    await sharedPreferences.setString(SharedPreferenceHelper.userPhoneNumberKey, value);
  }

  String getPhoneNumber() {
    return sharedPreferences.getString(SharedPreferenceHelper.userPhoneNumberKey) ?? "-1";
  }

  storePasscode(String value) async {
    await sharedPreferences.setString(SharedPreferenceHelper.passcode, value);
  }

  String getPasscode() {
    return sharedPreferences.getString(SharedPreferenceHelper.passcode) ?? "-1";
  }

  storebalance(String value) async {
    await sharedPreferences.setString(SharedPreferenceHelper.balance, value);
  }

  String getBalance() {
    return sharedPreferences.getString(SharedPreferenceHelper.balance).toString();
  }
}
