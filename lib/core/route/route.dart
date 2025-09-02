import 'package:get/get.dart';
import 'package:viserpay/view/components/bottom-nav-bar/bottom_nav_bar.dart';
import 'package:viserpay/view/screens/Profile/profile_screen.dart';
import 'package:viserpay/view/screens/account/change-password/change_password_screen.dart';
import 'package:viserpay/view/screens/account/delete-account/delete_account_screen.dart';
import 'package:viserpay/view/screens/add-money/add_money/add_money_screen.dart';
import 'package:viserpay/view/screens/add-money/add_money/add_money_web_view.dart';
import 'package:viserpay/view/screens/add-money/add_money_history/add_money_history_screen.dart';
import 'package:viserpay/view/screens/auth/biometrics/setup_fingerprint_screen.dart';

import 'package:viserpay/view/screens/auth/email_verification_page/email_verification_screen.dart';
import 'package:viserpay/view/screens/auth/forget_password/forget_password/forget_password.dart';
import 'package:viserpay/view/screens/auth/forget_password/reset_password/reset_password_screen.dart';
import 'package:viserpay/view/screens/auth/forget_password/verify_forget_password/verify_forget_password_screen.dart';
import 'package:viserpay/view/screens/auth/kyc/kyc.dart';
import 'package:viserpay/view/screens/auth/login/login_screen.dart';
import 'package:viserpay/view/screens/auth/profile_complete/profile_complete_screen.dart';
import 'package:viserpay/view/screens/auth/registration/registration_screen.dart';
import 'package:viserpay/view/screens/auth/sms_verification_page/sms_verification_screen.dart';
import 'package:viserpay/view/screens/auth/two_factor_screen/two_factor_setup_screen.dart';
import 'package:viserpay/view/screens/auth/two_factor_screen/two_factor_verification_screen.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_add_new_bank_screen/add_new_bank_screen.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_amont_screen/bank_transfer_amount_screen.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_history_screen/bank_transfer_history_screen.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_pin_screen/bank_transfer_pin_screen.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_screen/bank_transfer_screen.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_success_screen/bank_transfer_success_screen.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_amount_screen/cash_out_amount_screen.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_history_screen/cash_out_history_screen.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_pin_screen/cash_out_pin_screen.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_screen/cash_out_screen.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_success_screen/cash_out_success_screen.dart';
import 'package:viserpay/view/screens/donation/donation_amount_screen/donation_amount_screen.dart';
import 'package:viserpay/view/screens/donation/donation_history_screen/donation_history_screen.dart';
import 'package:viserpay/view/screens/donation/donation_home_screen/donation_home_screen.dart';
import 'package:viserpay/view/screens/donation/donation_pin_screen/donation_pin_screen.dart';
import 'package:viserpay/view/screens/donation/donation_success_screen/donation_success_screen.dart';
import 'package:viserpay/view/screens/edit_profile/edit_profile_screen.dart';
import 'package:viserpay/view/screens/faq/faq_screen.dart';
import 'package:viserpay/view/screens/helpNsupport/help_n_support_screen.dart';
import 'package:viserpay/view/screens/language/language_screen.dart';

import 'package:viserpay/view/screens/make-payment/make_payment_amount_screen/make_payment_amount_screen.dart';
import 'package:viserpay/view/screens/make-payment/make_payment_history_screen/make_payment_history_screen.dart';
import 'package:viserpay/view/screens/make-payment/make_payment_pin_screen/make_payment_pin_screen.dart';
import 'package:viserpay/view/screens/make-payment/make_payment_screen/make_payment_screen.dart';
import 'package:viserpay/view/screens/make-payment/make_payment_success_screen/make_payment_success_screen.dart';
import 'package:viserpay/view/screens/notification/notification_screen.dart';

import 'package:viserpay/view/screens/otp/otp_screen.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_amount_screen/pay_bill_amount_screen.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_history_screen/pay_bill_history_screen.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_home_screen/pay_bill_home_screen.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_pin_screen/pay_bill_pin_screen.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_screen/pay_bill_screen.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_success_screen/pay_bill_success_screen.dart';
import 'package:viserpay/view/screens/preferences/app_preferences_screen.dart';
import 'package:viserpay/view/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:viserpay/view/screens/privay/privacy_settings_screen.dart';
import 'package:viserpay/view/screens/qr_code/my_qr_code.dart';
import 'package:viserpay/view/screens/qr_code/qr_code_scanner.dart';
import 'package:viserpay/view/screens/recharge/recharge_amount_screen/recharge_amount_screen.dart';
import 'package:viserpay/view/screens/recharge/recharge_history_screen/recharge_history_screen.dart';
import 'package:viserpay/view/screens/recharge/recharge_operator_screen/recharge_operator_screen.dart';
import 'package:viserpay/view/screens/recharge/recharge_pin_screen/recharge_pin_screen.dart';
import 'package:viserpay/view/screens/recharge/recharge_screen/recharge_screen.dart';
import 'package:viserpay/view/screens/recharge/recharge_success_screen/recharge_success_screen.dart';
import 'package:viserpay/view/screens/security_info/twoFa/twFa_scan_screen.dart';
import 'package:viserpay/view/screens/security_info/twoFa/twFa_screen.dart';
import 'package:viserpay/view/screens/security_info/twoFa/twFa_success_screen.dart';
import 'package:viserpay/view/screens/security_info/twoFa/twFa_verify_screen.dart';
import 'package:viserpay/view/screens/sendmoney/send_money_amount_screen/send_money_amount_screen.dart';
import 'package:viserpay/view/screens/sendmoney/send_money_history_screen/send_money_history_screen.dart';
import 'package:viserpay/view/screens/sendmoney/send_money_pin_screen/send_money_pin_screen.dart';
import 'package:viserpay/view/screens/sendmoney/send_mone_screen/send_money_screen.dart';
import 'package:viserpay/view/screens/sendmoney/send_money_success_screen/send_money_success_screen.dart';
import 'package:viserpay/view/screens/splash/splash_screen.dart';
import 'package:viserpay/view/screens/transaction/transaction_history_screen.dart';
import 'package:viserpay/view/screens/transaction_limit/transaction_limit.dart';

import 'package:viserpay/view/screens/web%20_view/mywebview_screen.dart';

import '../../view/screens/security_info/security_info_screen.dart';

class RouteHelper {
  static const String uiKit = "/ui_kit";
  static const String splashScreen = "/splash_screen";
  static const String loginScreen = "/login_screen";
  static const String forgotPasswordScreen = "/forgot_password_screen";
  static const String changePasswordScreen = "/change_password_screen";
  static const String registrationScreen = "/registration_screen";
  static const String registrationPinScreen = "/registration_pin_screen";
  static const String otpScreen = "/otp_screen";
  static const String bottomNavBar = "/bottom_nav_bar";
  static const String myWalletScreen = "/my_wallet_screen";

  static const String twoFactorSetupScreen = "/two-factor-setup-screen";

  static const String sendMoneyScreen = "/send_money";
  static const String sendMoneyAmountScreen = "/sendMoney_amount";
  static const String sendMoneyPinScreen = "/sendMoney_pin";
  static const String sendMoneySuccessScreen = "/sendMoney_success";
  static const String sendMoneyHistoryScreen = "/SendMoney_history";

  static const String rechargeScreen = "/recharge_screen";
  static const String rechargeOpartorScreen = "/recharge_opartor_screen";
  static const String rechargeAmountScreen = "/recharge_amount_screen";
  static const String rechargePinScreen = "/recharge_pin_screen";
  static const String rechargeSuccessScreen = "/recharge_success_screen";
  static const String rechargeHistoryScreen = "/recharge_history_screen";

  static const String cashOutScreen = "/cash_out_screen";
  static const String cashOutAmountScreen = "/cash_out_amount_screen";
  static const String cashOutPinScreen = "/cash_out_pin_screen";
  static const String cashOutSuccessScreen = "/cash_out_success_screen";
  static const String cashOutHistoryScreen = "/cash_out_history_screen";

  static const String makePaymentScreen = "/make_payment_screen";
  static const String makePaymentAmountScreen = "/make_payment_amount_screen";
  static const String makePaymentPinScreen = "/make_payment_pin_screen";
  static const String makePaymentSuccessScreen = "/make_payment_success_screen";
  static const String makePaymentHistoryScreen = "/make_payment_history_screen";

  // static const String bankTransferHomeScreen = "/bank_transfer_home_screen";
  static const String bankTransferScreen = "/bank_transfer_screen";
  static const String addNewBankScreen = "/add_new_bank_screen";
  static const String addNewCardScreen = "/add_new_card_screen";
  static const String bankTransferAmountScreen = "/bank_transfer_Amount_screen";
  static const String bankTransferPinScreen = "/bank_transfer_pin_screen";
  static const String bankTransferhistroyScreen = "/bank_transfer_history_screen";
  static const String bankTransferSucessScreen = "/bank_transfer_success_screen";

  static const String donaTionHomeScreen = "/donation_home_screen";
  static const String donationAmountScreen = "/donation_Amount_screen";
  static const String donationPinScreen = "/donation_Pin_screen";
  static const String donationSuccessScreen = "/donation_success_screen";
  static const String donationHistoryScreen = "/donation_history_screen";

  // pay bill
  static const String paybillHistory = "/pay_bill_history_screen";
  static const String paybillHomeScreen = "/pay_bill_home_screen";
  static const String paybillScreen = "/pay_bill_organization_screen";
  static const String paybillAmountScreen = "/pay_bill_amount_screen";
  static const String paybillPinScreen = "/pay_bill_pin_screen";
  static const String paybillSuccessScreen = "/pay_bill_success_screen";

//security
  static const String securityInfoScreen = "/security_info_screen";
  static const String twoFaScreen = "/twoFa_screen";
  static const String twofaScanScreen = "/twoFa_scan_screen";
  static const String twofaVerifyScreen = "/twoFa_verify_screen";
  static const String twofaSuccessScreen = "/twoFa_success_screen";

  static const String notificationSettingsScreen = "/notification_screen";
  static const String privacySettingScreen = "/privacy_settings_screen";
  static const String appPreferenceSettingScreen = "/app_preference_settings_screen";

  static const String helpNsupportScreen = "/help_n_support_screen";
  static const String faqScreen = "/faq_screen";
  static const String mywebViewScreen = "/my_webView_screen";

// old -👇
  static const String addMoneyHistoryScreen = "/add_money_history_screen";
  static const String addMoneyScreen = "/add_money_screen";
  static const String addMoneyWebScreen = "/add_money_web_screen";

  static const String profileCompleteScreen = "/profile_complete_screen";

  static const String emailVerificationScreen = "/verify_email_screen";
  static const String smsVerificationScreen = "/verify_sms_screen";
  static const String verifyPassCodeScreen = "/verify_pass_code_screen";
  static const String twoFactorScreen = "/two-factor-screen";
  static const String resetPasswordScreen = "/reset_pass_screen";

  static const String transactionHistoryScreen = "/transaction_history_screen";

  static const String withdrawMoneyScreen = "/withdraw_money_screen";
  static const String withdrawPreviewScreen = "/withdraw_preview_screen";
  static const String withdrawHistoryScreen = "/withdraw_history_screen";
  static const String addWithdrawMethodScreen = "/add_withdraw_method_screen";
  static const String withdrawMethodScreen = "/withdraw_method_screen";
  static const String editWithdrawMethod = "/withdraw_method_edit_screen";

  // static const String notificationScreen = "/notification_screen";
  static const String profileScreen = "/profile_screen";
  static const String editProfileScreen = "/edit_profile_screen";
  static const String kycScreen = "/kyc_screen";

  static const String requestMoneyScreen = "/request_money_screen";

  static const String moneyOutScreen = "/money_out_screen";

  static const String transferMoneyScreen = "/transfer_money_screen";
  static const String transactionLimit = "/transaction_screen";

  static const String createVoucherScreen = "/create_voucher_screen";
  static const String redeemLogScreen = "/redeem_log_screen";
  static const String privacyScreen = "/privacy_screen";
  static const String myQrCodeScreen = "/my_qr_code_screen";
  static const String qrCodeScanner = "/qr_code_scanner_screen";

  static const String removeAccountScreen = "/remove_account_screen";
  static const String languageScreen = "/languages_screen";
  static const String setupFingerPrintScreen = "/setupFingerprint_screen";

  List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: forgotPasswordScreen, page: () => const ForgetPasswordScreen()),
    GetPage(name: changePasswordScreen, page: () => const ChangePasswordScreen()),
    GetPage(name: registrationScreen, page: () => const RegistrationScreen()),

    GetPage(name: profileCompleteScreen, page: () => const ProfileCompleteScreen()),
    GetPage(name: bottomNavBar, page: () => const BottomNavBar()),
    // add money
    GetPage(name: addMoneyScreen, page: () => const AddMoneyScreen()),
    GetPage(name: addMoneyWebScreen, page: () => AddMoneyWebView(redirectUrl: Get.arguments)),
    GetPage(name: addMoneyHistoryScreen, page: () => const AddMoneyHistoryScreen()),

    // recharge
    GetPage(name: rechargeScreen, page: () => const RechargeScreen()),
    GetPage(name: rechargeOpartorScreen, page: () => const ReachargeOparatorScreen()),
    GetPage(name: rechargeAmountScreen, page: () => const RechargeAmountScreen()),
    GetPage(name: rechargePinScreen, page: () => const RechargePinScreen()),
    GetPage(name: rechargeSuccessScreen, page: () => const RechargeSuccessScreen()),
    GetPage(name: rechargeHistoryScreen, page: () => const RechargeHistoryScreen()),

    // sendmoney
    GetPage(name: sendMoneyScreen, page: () => const SendmoneyScreen()),
    GetPage(name: sendMoneyAmountScreen, page: () => const SendMoneyAmountScreen()),
    GetPage(name: sendMoneyPinScreen, page: () => const SendMoneyPinScreen()),
    GetPage(name: sendMoneySuccessScreen, page: () => const SendMoneySuccessScreen()),
    GetPage(name: sendMoneyHistoryScreen, page: () => const SendMoneyHistoryScreen()),
    // cashout
    GetPage(name: cashOutScreen, page: () => const CashOutScreen()),
    GetPage(name: cashOutAmountScreen, page: () => const CashOutAmountScreen()),
    GetPage(name: cashOutPinScreen, page: () => const CashOutPinScreen()),
    GetPage(name: cashOutSuccessScreen, page: () => const CashoutSuccessScreen()),
    GetPage(name: cashOutHistoryScreen, page: () => const CashoutHistoryScreen()),
    // make payment
    GetPage(name: makePaymentScreen, page: () => const MakePaymentScreen()),
    GetPage(name: makePaymentAmountScreen, page: () => const MakePaymentAmountScreen()),
    GetPage(name: makePaymentPinScreen, page: () => const MakePaymentPinScreen()),
    GetPage(name: makePaymentSuccessScreen, page: () => const MakePaymentSuccessScreen()),
    GetPage(name: makePaymentHistoryScreen, page: () => const MakePaymentHistoryScreen()),
    // bank transfer
    GetPage(name: bankTransferhistroyScreen, page: () => const BankTransferHistoryScreen()),
    GetPage(name: bankTransferScreen, page: () => const BankTransferScreen()),
    GetPage(name: addNewBankScreen, page: () => const AddNewBankScreen()),

    GetPage(name: bankTransferAmountScreen, page: () => const BankTransferAmountScreen()),
    GetPage(name: bankTransferPinScreen, page: () => const BankTransferPinScreen()),
    GetPage(name: bankTransferSucessScreen, page: () => const BankTransferSuccessScreen()),
    // dontaion
    GetPage(name: donaTionHomeScreen, page: () => const DonationHomeScreen()),
    GetPage(name: donationAmountScreen, page: () => const DonationAmountScreen()),
    GetPage(name: donationPinScreen, page: () => const DonationPinScreen()),
    GetPage(name: donationSuccessScreen, page: () => const DonationSuccessScreen()),
    GetPage(name: donationHistoryScreen, page: () => const DonationHistoryScreen()),
    // pay bill
    GetPage(name: paybillHistory, page: () => const PaybillHistoryScreen()),
    GetPage(name: paybillHomeScreen, page: () => const PaybillHomeScreen()),
    GetPage(name: paybillScreen, page: () => const PaybillScreen()),
    GetPage(name: paybillAmountScreen, page: () => const PaybillAmountScreen()),
    GetPage(name: paybillPinScreen, page: () => const PayBillPinScreen()),
    GetPage(name: paybillSuccessScreen, page: () => const PaybillSuccessScreen()),
    GetPage(name: mywebViewScreen, page: () => MyWebViewScreen(url: Get.arguments)),
//----> settings
    // Security info
    GetPage(name: securityInfoScreen, page: () => const SecurityInfoScreen()),
    GetPage(name: twoFaScreen, page: () => const TwoFaScreen()),
    GetPage(name: twofaScanScreen, page: () => const TwoFaScanScreen()),
    GetPage(name: twofaVerifyScreen, page: () => const TwFaVerifyScreen()),
    GetPage(name: twofaSuccessScreen, page: () => const TwoFaSuccessScreen()),
    //
    GetPage(name: notificationSettingsScreen, page: () => const NotificationScreen()),
    GetPage(name: privacySettingScreen, page: () => const PrivacySettingScreen()),
    GetPage(name: appPreferenceSettingScreen, page: () => const PreferencesScreen()),

    GetPage(name: helpNsupportScreen, page: () => const HelpNsupportScreen()),
    GetPage(name: faqScreen, page: () => const FaqScreen()),

    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: transactionHistoryScreen, page: () => const TransactionHistoryScreen()),
    GetPage(name: kycScreen, page: () => const KycScreen()),
    GetPage(
        name: emailVerificationScreen,
        page: () => EmailVerificationScreen(
              needSmsVerification: Get.arguments[0],
              isProfileCompleteEnabled: Get.arguments[1],
              needTwoFactor: Get.arguments[2],
            )),
    GetPage(name: smsVerificationScreen, page: () => const SmsVerificationScreen()),
    GetPage(name: verifyPassCodeScreen, page: () => const VerifyForgetPassScreen()),
    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),
    GetPage(name: twoFactorScreen, page: () => TwoFactorVerificationScreen(isProfileCompleteEnable: Get.arguments)),
    GetPage(name: otpScreen, page: () => OtpScreen(actionId: Get.arguments[0], nextRoute: Get.arguments[1], otpType: Get.arguments[2])),

    GetPage(name: privacyScreen, page: () => const PrivacyPolicyScreen()),
    GetPage(name: myQrCodeScreen, page: () => const MyQrCodeScreen()),
    GetPage(name: qrCodeScanner, page: () => const QrCodeScannerScreen()),
    GetPage(name: transactionLimit, page: () => const TransactionLimit()),
    GetPage(name: removeAccountScreen, page: () => const DisableAccountScreen()),
    GetPage(name: languageScreen, page: () => const LanguageScreen()),
    GetPage(name: twoFactorSetupScreen, page: () => const TwoFactorSetupScreen()),
    GetPage(name: setupFingerPrintScreen, page: () => const SetupFingerPrintScreen()),
  ];
}
