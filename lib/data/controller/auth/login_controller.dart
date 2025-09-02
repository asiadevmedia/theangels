// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/auth/login/login_response_model.dart';
import 'package:viserpay/data/model/country_model/country_model.dart';
import 'package:viserpay/data/model/general_setting/general_setting_response_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/auth/login_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

import '../../../environment.dart';

class LoginController extends GetxController {
  LoginRepo loginRepo;

  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode userFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController phoneController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<String> errors = [];
  String? email;
  String? password;
  String userLoginMethod = "";

  LoginController({required this.loginRepo});
  void getGS() {
    gsModel = loginRepo.apiClient.getGSData();

    userLoginMethod = gsModel.data?.generalSetting?.loginMethod.toString() ?? "";
    update();
  }

  GeneralSettingResponseModel gsModel = GeneralSettingResponseModel();

  String? countryName;
  String dialCode = Environment.defaultPhoneCode;
  void updateMobilecode(String code) {
    dialCode = code;
    update();
  }

  selectCountryData(Countries value) {
    selectedCountryData = value;
    update();
  }

  // country data
  Countries selectedCountryData = Countries();

  bool countryLoading = true;
  List<Countries> countryList = [];
  List<Countries> filteredCountries = [];

  Future<dynamic> getCountryData() async {
    ResponseModel mainResponse = await loginRepo.getCountryList();

    if (mainResponse.statusCode == 200) {
      CountryModel model = CountryModel.fromJson(jsonDecode(mainResponse.responseJson));
      List<Countries>? tempList = model.data?.countries;

      if (tempList != null && tempList.isNotEmpty) {
        countryList.addAll(tempList);
      }
      var selectDefCountry = tempList!.firstWhere(
        (country) => country.countryCode!.toLowerCase() == Environment.defaultCountryCode.toLowerCase(),
        orElse: () => Countries(),
      );
      if (selectDefCountry.dialCode != null) {
        selectCountryData(selectDefCountry);
      }
      countryLoading = false;
      update();
      return;
    } else {
      CustomSnackBar.error(errorList: [mainResponse.message]);

      countryLoading = false;
      update();
      return;
    }
  }

  void forgetPassword() {
    clearTextField();
    Get.toNamed(RouteHelper.forgotPasswordScreen, arguments: countryList);
  }

  void checkAndGotoNextStep(LoginResponseModel responseModel) async {
    bool needEmailVerification = responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification = responseModel.data?.user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = responseModel.data?.user?.tv == '1' ? false : true;

    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userIdKey, responseModel.data?.user?.id.toString() ?? '-1');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, responseModel.data?.accessToken ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenType, responseModel.data?.tokenType ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userEmailKey, responseModel.data?.user?.email ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userPhoneNumberKey, responseModel.data?.user?.mobile ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userNameKey, responseModel.data?.user?.username ?? '');

    await loginRepo.sendUserToken();

    bool isProfileCompleteEnable = responseModel.data?.user?.regStep == '0' ? true : false;

    if (needSmsVerification == false && needEmailVerification == false && isTwoFactorEnable == false) {
      if (isProfileCompleteEnable) {
        Get.offAndToNamed(RouteHelper.profileCompleteScreen);
      } else {
        Get.offAndToNamed(RouteHelper.bottomNavBar);
      }
    } else if (needSmsVerification == true && needEmailVerification == true && isTwoFactorEnable == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [true, isProfileCompleteEnable, isTwoFactorEnable]);
    } else if (needSmsVerification == true && needEmailVerification == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [true, isProfileCompleteEnable, isTwoFactorEnable]);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen, arguments: [isProfileCompleteEnable, isTwoFactorEnable]);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [false, isProfileCompleteEnable, isTwoFactorEnable]);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen, arguments: isProfileCompleteEnable);
    }
  }

  bool isSubmitLoading = false;
  void loginUser() async {
    isSubmitLoading = true;
    update();
    if (dialCode.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.selectyourCountry]);
    }
    String phone = "$dialCode${phoneController.text}";

    ResponseModel model = await loginRepo.loginUser(
      password: passwordController.text.toString(),
      phone: phone,
      logInType: userLoginMethod,
    );
    loginRepo.apiClient.storePasscode(passwordController.text);

    if (model.statusCode == 200) {
      LoginResponseModel loginModel = LoginResponseModel.fromJson(jsonDecode(model.responseJson));

      if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
        await loginRepo.apiClient.storePhone(phone);
        checkAndGotoNextStep(loginModel);
      } else {
        CustomSnackBar.error(errorList: loginModel.message?.error ?? [MyStrings.loginFailedTryAgain]);
      }
    } else {
      CustomSnackBar.error(errorList: [model.message]);
    }

    isSubmitLoading = false;
    update();
  }

  void clearTextField() {
    passwordController.text = '';
    emailController.text = '';

    update();
  }

  void loadData() async {
    isDisable = false;
    isPermantlyLocked = false;
    countdownSeconds = 30;
    update();
    checkBiometricsAvalable();
    getGS();
    getCountryData();
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometricsAvalable = false;
  Future<void> checkBiometricsAvalable() async {
    bool t = await auth.isDeviceSupported();

    try {
      await auth.getAvailableBiometrics().then((value) {
        for (var element in value) {
            if ((element == BiometricType.fingerprint || element == BiometricType.weak || element == BiometricType.strong) && t == true) {
              canCheckBiometricsAvalable = true;
              update();
            } else {
              canCheckBiometricsAvalable = false;
              update();
            }
          }
      });
    } catch (e) {
      canCheckBiometricsAvalable = false;
      update();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  bool isDisable = false;
  bool isPermantlyLocked = false;
  bool isBioloading = false;

  Future<void> biomentricLoging() async {
    bool authenticated = false;
    isDisable = false;
    isPermantlyLocked = false;
    countdownSeconds = 30;
    update();

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
        authMessages: [],
      );
      // .timeout(const Duration(seconds: 10));
      if (authenticated == true) {
        isBioloading = true;
        update();
        String ph = loginRepo.apiClient.getPhoneNumber();
        String ps = loginRepo.apiClient.getPasscode();

        ResponseModel model = await loginRepo.loginUser(
          phone: ph,
          password: ps,
          logInType: userLoginMethod,
        );
        loginRepo.apiClient.storePasscode(passwordController.text);

        if (model.statusCode == 200) {
          LoginResponseModel loginModel = LoginResponseModel.fromJson(jsonDecode(model.responseJson));
          if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
            await loginRepo.apiClient.storePhone(ph);
            await loginRepo.apiClient.storePasscode(ps);
            checkAndGotoNextStep(loginModel);
          } else {
            CustomSnackBar.error(errorList: loginModel.message?.error ?? [MyStrings.loginFailedTryAgain]);
          }
        } else {
          CustomSnackBar.error(errorList: [model.message]);
        }
      }
    } on PlatformException catch (e) {
      if (e.code == "PermanentlyLockedOut") {
        // startCountdown();
        isDisable = true;
        isPermantlyLocked = true;
        update();
      } else if (e.code == "LockedOut") {
        isDisable = true;
        update();
        startCountdown();
      }
      update();
    } finally {
      isBioloading = false;
      update();
    }
  }

  int countdownSeconds = 30;
  late Timer countdownTimer;

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds > 0) {
        countdownSeconds--;
        update();
      } else {
        timer.cancel(); // Stop the timer when countdown reaches 0
        countdownSeconds = 0;
        isDisable = false;
        update();
      }
    });
  }
}
