import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/auth/verification/email_verification_model.dart';
import 'package:viserpay/data/repo/auth/login_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class VerifyPasswordController extends GetxController {
  LoginRepo loginRepo;

  List<String> errors = [];
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;
  bool remember = false;
  bool hasError = false;
  String currentText = "";

  VerifyPasswordController({required this.loginRepo});

  bool isResendLoading = false;
  void resendForgetPassCode() async {
    isResendLoading = true;
    update();
    String value = email;
    String type = 'email';
    await loginRepo.forgetPassword(type, value);
    isResendLoading = false;
    update();
  }

  bool verifyLoading = false;
  void verifyForgetPasswordCode(String value) async {



    if (value.isNotEmpty) {
      verifyLoading = true;
      update();
      EmailVerificationModel model = await loginRepo.verifyForgetPassCode(value);

      if (model.code == 200) {
        verifyLoading = false;
        CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.requestSuccess]);
        Get.offAndToNamed(RouteHelper.resetPasswordScreen, arguments: [email, value]);
      } else {
        verifyLoading = false;
        update();
        List<String> errorList = [MyStrings.verificationFailed];
        CustomSnackBar.error(errorList: model.message?.error ?? errorList);
      }
      update();
    }
  }

  String getFormatedMail() {
    try {
      List<String> tempList = email.split('0');
      int maskLength = tempList[0].length;
      String maskValue = tempList[0][0].padRight(maskLength, '*');
      String value = '$maskValue*${tempList[1]}';
      return value;
    } catch (e) {
      return email;
    }
  }
}
