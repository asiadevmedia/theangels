import 'package:flutter/material.dart';

class MyColor {

  static const Color primaryColor = Color(0xff2176FF);
  static const bgColor1 = Color(0xFFF9F9F9);
  static const bgColor1Ex = Color(0xffF1F3F4);
  static const successBG = Color(0xffdcdde0);
  static const Color secondaryColor = Color(0xffF6F7FE);
  static const Color screenBgColor = Color(0xFFF9F9F9);
  static Color secondaryScreenBgColor = primaryColor.withOpacity(.4);
  static const Color primaryTextColor = Color(0xff262626);
  static const Color contentTextColor = Color(0xff777777);
  static const Color primaryStatusBarColor = primaryColor;
  static const Color underlineTextColor = primaryColor;
  static const Color lineColor = Color(0xffECECEC);
  static const Color borderColor = Color(0xffD9D9D9);
  static const Color primaryDark = Color(0xff11275A);
  static const Color greyText = Color(0xff0a1128);
  // app bar
  static const Color appBarColor = colorWhite;
  static const Color appBarContentColor = colorBlack;
  // text field
  static Color labelTextColor = colorBlack.withOpacity(0.6);
  static const Color textFieldDisableBorderColor = Color(0xffCFCEDB);
  static const Color textFieldEnableBorderColor = primaryColor;
  static const Color hintTextColor = Color(0xff98a1ab);
  // button
  static const Color primaryButtonColor = primaryColor;
  static const Color primaryButtonTextColor = colorWhite;
  static const Color secondaryButtonColor = colorWhite;
  static const Color secondaryButtonTextColor = colorBlack;

  // icon
  static const Color iconColor = Color(0xff555555);
  static const Color filterEnableIconColor = primaryColor;
  static const Color filterIconColor = iconColor;
  static const Color searchEnableIconColor = colorRed;
  static const Color searchIconColor = iconColor;
  static const Color bottomSheetCloseIconColor = colorBlack;

  static const Color bodytextColor = Color(0xFF0A1128);
  static const Color colorWhite = Color(0xffFFFFFF);
  static const Color colorBlack = Color(0xff262626);
  static const Color colorGreen = Color(0xff28C76F);
  static const Color colorGreen100 = Color(0xffD4F4E2);
  static const Color colorOrange = Color(0xffFF9F43);
  static const Color colorOrange100 = Color(0xffFFECD9);
  static const Color colorRed = Color(0xffEA5455);
  static const Color delteBtnTextColor = Color(0xff6C3137);
  static const Color delteBtnColor = Color(0xffFDD6D7);
  static const Color colorRed100 = Color(0xffFCE9E9);
  static const Color colorGrey = Color(0xff555555);
  static const Color colorGrey2 = Color(0xffEDF2F6);
  static const Color transparentColor = Colors.transparent;

  static const Color greenSuccessColor = colorGreen;
  static const Color redCancelTextColor = Color(0xFFF93E2C);
  static const Color highPriorityPurpleColor = Color(0xFF7367F0);
  static const Color pendingColor = Colors.orange;

  static const Color otpBgColor = Color(0xFF172B33);
  static const Color colorBlack2 = Color(0xff25282B);
  static const Color colorGrey1 = Color(0xffF8F8F8);
  static const Color colorGrey3 = Color(0xffF1F3F4);
  static const Color shadowColor = Color(0xffEAEAEA);
  // module colors
  static const Color sendMoneyBaseColor = Color(0xFF59ADF6);
  static const Color rechargeBaseColor = Color(0xFF08CAD1);
  static const Color cashoutBaseColor = Color(0xFFFFB480);
  static const Color paymentBaseColor = Color(0xFF9D94FF);
  static const Color bankTransferBaseColor = Color(0xFFC780E8);
  static const Color paybillBaseColor = Color(0xFFFEDE6C);
  static const Color donationBaseColor = Color(0xFFFF6961);
  static const Color addMoneyBaseColor = Color(0xFF42D6A4);

  static Color getPrimaryColor() {
    return primaryColor;
  }

  static Color getScreenBgColor({bool isWhite = false}) {
    return isWhite ? Colors.white : screenBgColor;
  }

  static Color getGreyText() {
    return MyColor.colorBlack.withOpacity(0.5);
  }

  static Color getSecondaryScreenBgColor() {
    return secondaryScreenBgColor;
  }

  static Color getAppBarColor() {
    return appBarColor;
  }

  static Color getAppBarContentColor() {
    return appBarContentColor;
  }

  static Color getHeadingTextColor() {
    return primaryTextColor;
  }

  static Color getContentTextColor() {
    return contentTextColor;
  }

  static Color getLabelTextColor() {
    return colorBlack;
  }

  static Color getHintTextColor() {
    return hintTextColor;
  }

  static Color getTextFieldDisableBorder() {
    return textFieldDisableBorderColor;
  }

  static Color getTextFieldEnableBorder() {
    return textFieldEnableBorderColor;
  }

  static Color getPrimaryButtonColor() {
    return primaryButtonColor;
  }

  static Color getPrimaryButtonTextColor() {
    return primaryButtonTextColor;
  }

  static Color getSecondaryButtonColor() {
    return secondaryButtonColor;
  }

  static Color getSecondaryButtonTextColor() {
    return secondaryButtonTextColor;
  }

  // icon color
  static Color getIconColor() {
    return iconColor;
  }

  static Color getFilterDisableIconColor() {
    return filterIconColor;
  }

  static Color getFilterEnableIconColor() {
    return filterEnableIconColor;
  }

  static Color getSearchIconColor() {
    return searchIconColor;
  }

  static Color getSearchEnableIconColor() {
    return colorRed;
  }

  static Color getTransparentColor() {
    return transparentColor;
  }

  static Color getTextColor() {
    return colorBlack;
  }

  static Color getCardBgColor() {
    return colorWhite;
  }

  static Color getShadowColor() {
    return shadowColor;
  }

  static List<Color> symbolPlate = [
    sendMoneyBaseColor,
    rechargeBaseColor,
    cashoutBaseColor,
    paymentBaseColor,
    bankTransferBaseColor,
    paybillBaseColor,
    donationBaseColor,
    addMoneyBaseColor,
    cashoutBaseColor,
    paymentBaseColor,
  ];

  static getSymbolColor(int index) {
    int colorIndex = index > 10 ? index % 10 : index;
    return symbolPlate[colorIndex];
  }
}
