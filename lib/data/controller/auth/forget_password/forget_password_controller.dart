import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/auth/login_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/data/model/country_model/country_model.dart';

import '../../../../environment.dart';

class ForgetPasswordController extends GetxController {
  LoginRepo loginRepo;

  ForgetPasswordController({required this.loginRepo});

  bool submitLoading = false;
  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  final FocusNode phoneFocusNode = FocusNode();

  void submitForgetPassCode() async {
    if (phoneController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterYourPhoneNumber]);
      return;
    }
    String input = selectedCountryData.dialCode.toString() + phoneController.text.toString();

    submitLoading = true;
    update();
    String type = 'mobile';
    String responseEmail = await loginRepo.forgetPassword(type, input);
    if (responseEmail.isNotEmpty) {
      phoneController.text = '';
      searchController.text = '';
      Get.toNamed(RouteHelper.verifyPassCodeScreen, arguments: responseEmail);
    }

    submitLoading = false;
    update();
  }

  Countries selectedCountryData = Countries();
  selectCountryData(Countries value) {
    selectedCountryData = value;
    update();
  }

  bool countryLoading = false;
  List<Countries> countryList = [];
  List<Countries> filteredCountries = [];

  setCountryData(List<Countries> tempList) async {
    countryLoading = true;
    update();

    if (tempList.isNotEmpty) {
      countryList.addAll(tempList);
      Countries selectDefCountry = tempList.firstWhere(
        (country) => country.countryCode!.toLowerCase() == Environment.defaultCountryCode.toLowerCase(),
        orElse: () => Countries(country: "USA", countryCode: "1", dialCode: "1"),
      );
      if (selectDefCountry.dialCode != null) {
        selectCountryData(selectDefCountry);
      }
      update();
    }
    countryLoading = false;
    update();
  }

  Future<dynamic> getCountryData() async {
    countryLoading = true;
    update();

    ResponseModel mainResponse = await loginRepo.getCountryList();

    if (mainResponse.statusCode == 200) {
      CountryModel model = CountryModel.fromJson(jsonDecode(mainResponse.responseJson));
      if (model.status == "success") {
        List<Countries>? tempList = model.data?.countries;
        if (tempList != null && tempList.isNotEmpty) {
          setCountryData(tempList);
        }
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [mainResponse.message]);

      return;
    }
    countryLoading = false;
    update();
  }
}
