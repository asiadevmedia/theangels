class Environment {
/* ATTENTION Please update your desired data. */

  static const String appName = 'Viser Pay';
  static const String version = '1.0.0';

  static String defaultLangCode = "en";
  static String defaultLanguageName = "English";

  static String defaultPhoneCode = "62"; //don't put + here
  static String defaultCountryCode = "ID";
  static int otpTime = 60;
  List<String> mobileRechargeQuickAmount = ["10", "20", "30", "40", "50", "60", "100", "300"]; // it's a static amount you can change its for yourself
}
