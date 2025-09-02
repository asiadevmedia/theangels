// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/model/auth/login/login_response_model.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/biometric/biometric_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class BioMetricController extends GetxController {
  BioMetricController({required this.repo});
  final LocalAuthentication auth = LocalAuthentication();

  BiometricRepo repo;
  bool isLoading = false;
  TextEditingController passwordController = TextEditingController();

  bool alradySetup = false;
  initValue() {
    alradySetup = repo.apiClient.getfingerprintStatus();
    checkBiometricsAvalable();
  }

  disableBiometric() {
    alradySetup = false;
    repo.apiClient.storefingerprintStatus(false);
    update();
  }

  Future<void> enableFingerPrint() async {
    isBioloading = true;
    update();
    try {
      if (MyUtils().validatePinCode(passwordController.text)) {
        await biomentricLoging();
      }
    } catch (e) {
      print(e);
    } finally {
      isBioloading = false;
    }
  }

  bool pinvalidate() {
    int storepin = int.parse(repo.apiClient.getPasscode());
    int pin = int.parse(passwordController.text);
    if (storepin == pin) {
      return true;
    } else {
      return false;
    }
  }

  bool canCheckBiometricsAvalable = false;
  Future<void> checkBiometricsAvalable() async {
    passwordController.text = '';
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
      if (authenticated == true) {
        isBioloading = authenticated;
        update();
      }
      String ph = repo.apiClient.getPhoneNumber();
      String ps = passwordController.text;

      ResponseModel model = await repo.pinValidate(
        password: ps,
      );

      if (model.statusCode == 200) {
        LoginResponseModel loginModel = LoginResponseModel.fromJson(jsonDecode(model.responseJson));
        if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
          await repo.apiClient.storePhone(ph);
          await repo.apiClient.storePasscode(ps);
          await repo.apiClient.storefingerprintStatus(true);
          alradySetup = true;
          Get.back();
          CustomSnackBar.success(successList: ["Biometric enabled succssfully"]);
        } else {
          CustomSnackBar.error(errorList: loginModel.message?.error ?? [MyStrings.loginFailedTryAgain]);
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
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
    } finally {
      isBioloading = false;
    }
    update();
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
