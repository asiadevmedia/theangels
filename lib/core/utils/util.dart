// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:intl/intl.dart' as intl;
import '../../view/components/snack_bar/show_custom_snackbar.dart';
import 'my_strings.dart';

class MyUtils {
  static void vibrate() {
    HapticFeedback.heavyImpact();
    HapticFeedback.vibrate();
  }

  static splashScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: MyColor.getPrimaryColor(), statusBarIconBrightness: Brightness.light, systemNavigationBarColor: MyColor.getPrimaryColor(), systemNavigationBarIconBrightness: Brightness.light));
  }

  static allScreen() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: MyColor.colorWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: MyColor.screenBgColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: MyColor.colorWhite, statusBarIconBrightness: Brightness.dark, systemNavigationBarColor: MyColor.colorWhite, systemNavigationBarIconBrightness: Brightness.dark);

  static dynamic getShadow() {
    return [
      BoxShadow(blurRadius: 15.0, offset: const Offset(0, 25), color: Colors.grey.shade500.withOpacity(0.6), spreadRadius: -35.0),
    ];
  }

  static dynamic getShadow2({double blurRadius = 8}) {
    return [
      BoxShadow(
        color: MyColor.getShadowColor().withOpacity(0.3),
        blurRadius: blurRadius,
        spreadRadius: 3,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        color: MyColor.getShadowColor().withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: blurRadius,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static getOperationTitle(String value) {
    String number = value;
    RegExp regExp = RegExp(r'^(\d+)(\w+)$');
    Match? match = regExp.firstMatch(number);
    if (match != null) {
      String? num = match.group(1) ?? '';
      String? unit = match.group(2) ?? '';
      String title = '${MyStrings.last.tr} $num ${unit.capitalizeFirst}';
      return title.tr;
    } else {
      return value.tr;
    }
  }

  static String getChargeText(String charge) {
    String chargeText = "${MyStrings.inc.tr} $charge ${MyStrings.charge.tr}";
    return chargeText;
  }

  String maskSensitiveInformation(String input) {
    if (input.isEmpty) {
      return '';
    }

    final int maskLength = input.length ~/ 2; // Mask half of the characters.

    final String mask = '*' * maskLength;

    final String maskedInput = maskLength > 4 ? input.replaceRange(5, maskLength, mask) : input.replaceRange(0, maskLength, mask);

    return maskedInput;
  }

  static List<GlobalFormModle> dynamicFormSelectValueFormatter(List<GlobalFormModle>? dynamicFormList) {
    List<GlobalFormModle> mainFormList = [];

    if (dynamicFormList != null && dynamicFormList.isNotEmpty) {
      mainFormList.clear();

      for (var element in dynamicFormList) {
        if (element.type == 'select') {
          bool? isEmpty = element.options?.isEmpty;
          bool empty = isEmpty ?? true;
          if (element.options != null && empty != true) {
            if (!element.options!.contains(MyStrings.selectOne)) {
              element.options?.insert(0, MyStrings.selectOne);
            }

            element.selectedValue = element.options?.first;
            mainFormList.add(element);
          }
        } else {
          mainFormList.add(element);
        }
      }
    }
    return mainFormList;
  }

  bool validatePinCode(String pin) {
    if (pin.length < 4) {
      MyUtils.vibrate();
      CustomSnackBar.error(errorList: [MyStrings.pinLengthErrorMessage]);
      return false;
    }
    if (pin.isEmpty) {
      MyUtils.vibrate();
      CustomSnackBar.error(errorList: [MyStrings.pinErrorMessage]);
      return false;
    }

    return true;
  }

  bool balanceValidation({
    required double currentBalance,
    required double amount,
  }) {


    print('available balance: $currentBalance  $amount');

    try {
      // Check if amount is an integer
      if (amount > 0) {
        // It's a valid double or int
        if (amount > currentBalance) {
          CustomSnackBar.error(errorList: [MyStrings.yourBalanceIsLow]);
          return false;
        } else {
          return true;
        }
      } else {
        CustomSnackBar.error(errorList: [MyStrings.enterValidAmount]);
        return false;
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [MyStrings.enterValidAmount]);
      return false;
    }
  }

//permissons
  Future<PermissionStatus> isCameraPemissonGranted() async {
    if (await Permission.camera.isGranted) {
      return PermissionStatus.granted;
    } else {
      await Permission.camera.request().then((value) {
        return value;
      });
      return await Permission.camera.status;
    }
  }
}
