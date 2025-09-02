import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/model/donation/donation_history_response_model.dart';
import 'package:viserpay/data/model/donation/donation_response_modal.dart';
import 'package:viserpay/data/model/donation/donation_submit_response.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/donation/donation_repo.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class DonationController extends GetxController {
  DonationRepo donationRepo;
  DonationController({required this.donationRepo});

  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController referanceController = TextEditingController();

  TextEditingController pinController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode searchFocusNode = FocusNode();

  FocusNode amountFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();

  bool hideIdentity = false;
  void changehideIdentity(bool val) {
    hideIdentity = val;
    update();
  }

  bool isSearching = false;

  void filterData(String query) {
    isSearching = true;
    update();

    if (query.isEmpty) {
      tempOrganizations = organizations;
    } else {
      tempOrganizations = organizations.where((element) => element.name.toString().toLowerCase().contains(query.toLowerCase())).toList();
    }

    isSearching = false;
    update();
  }

  String currentBalance = "0";
  DonationOrganization? selectedDonation;

  void selectDonation(DonationOrganization donationOrganization) {
    selectedDonation = donationOrganization;
    update();
    Get.toNamed(
      RouteHelper.donationAmountScreen,
    );
  }

  void initialValue({bool isSubmit = false}) async {
    isLoading = true;
    update();
    nameController.clear();
    nameController.text = "";

    referanceController.clear();
    referanceController.text = "";

    amountController.clear();
    amountController.text = "";

    emailController.clear();
    emailController.text = "";

    pinController.clear();
    pinController.text = "";
    hideIdentity = false;

    selectedDonation;

    currentBalance = "0";
    currency = donationRepo.apiClient.getCurrencyOrUsername(isSymbol: true);

    update();

    if (!isSubmit) {
      await getDonationData();
    }
    isLoading = false;
    update();
  }

  String currency = "";
  List<String> otpTypeList = [];
  String selectedOtpType = "null";
  void selectotpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  List<DonationOrganization> organizations = [];
  List<DonationOrganization> tempOrganizations = [];

  Future<void> getDonationData() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await donationRepo.getDonationData();
    if (responseModel.statusCode == 200) {
      DonationResponseModal model = DonationResponseModal.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == "success") {
        final data = model.data;
        if (data != null) {
          currentBalance = data.currentBalance.toString();
          organizations.clear();
          organizations.addAll(data.organizations?.toList() ?? []);
          tempOrganizations.clear();
          tempOrganizations.addAll(data.organizations?.toList() ?? []);

          otpTypeList.clear();
          otpTypeList.addAll(data.otpType?.toList() ?? []);
          update();
        }
      }
    } else {
      log("Incomplete");
    }
    isLoading = false;
    update();
  }

//
  void submitDonation() async {
    if (validateDonationForm()) {
      isLoading = true;
      update();
      ResponseModel responseModel = await donationRepo.submitDonation(
        pin: pinController.text,
        donationID: selectedDonation!.id.toString(),
        amount: amountController.text,
        otpType: selectedOtpType,
        email: emailController.text,
        name: nameController.text,
        hideIdentity: hideIdentity ? "0" : "1",
        reference: referanceController.text,
      );
      if (responseModel.statusCode == 200) {
        DonationSubmitResponseModal modal = DonationSubmitResponseModal.fromJson(jsonDecode(responseModel.responseJson));
        if (modal.status == "success") {
          Get.back();

          if (modal.data?.actionID == "null") {
            Get.toNamed(RouteHelper.donationSuccessScreen, arguments: [responseModel]);
          } else {
            Get.toNamed(
              RouteHelper.otpScreen,
              arguments: [
                modal.data?.actionID,
                RouteHelper.donationSuccessScreen,
                pinController.text.toString(),
                selectedOtpType,
              ],
            );
          }
        } else {
          Get.back();
          CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        Get.back();
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    }
  }

  //validateDonationForm
  bool validateDonationForm() {
    if (selectedDonation == null) {
      CustomSnackBar.error(errorList: [MyStrings.selectAOrganization]);
      return false;
    }
    if (nameController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterYourName]);
      return false;
    }
    if (emailController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterYourEmail]);
      return false;
    }
    if (amountController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
      return false;
    }

    return true;
  }

  List<DonationHistory> donationHistory = [];
  String? nextPageUrl;
  int currentPage = 0;
  Future<void> getDonationHistory() async {
    isLoading = true;
    currentPage = 1;
    donationHistory.clear();
    update();

    ResponseModel responseModel = await donationRepo.getDonationHistory(currentPage.toString());
    if (responseModel.statusCode == 200) {
      DonationHistoryResponseModel model = DonationHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == "success") {
        final data = model.data;
        if (data != null) {
          List<DonationHistory> tempList = data.history?.data?.toList() ?? [];

          if (tempList.isNotEmpty) {
            donationHistory.addAll(tempList);
            nextPageUrl = data.history?.nextPageUrl;
            update();
          }
        }
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  Future<void> getDonationHistoryPaginateData() async {
    currentPage = currentPage + 1;
    isLoading = false;
    update();

    ResponseModel responseModel = await donationRepo.getDonationHistory(currentPage.toString());
    if (responseModel.statusCode == 200) {
      DonationHistoryResponseModel model = DonationHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == "success") {
        final data = model.data;
        if (data != null) {
          List<DonationHistory> tempList = data.history?.data?.toList() ?? [];

          if (tempList.isNotEmpty) {
            donationHistory.addAll(tempList);
            nextPageUrl = data.history?.nextPageUrl;
            update();
          }
        }
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  String getStatus(String status) {
    if (status == '1') {
      return MyStrings.succeed;
    } else {
      return status == "0" ? MyStrings.pending : MyStrings.rejected;
    }
  }

  Color getStatusColor(String status) {
    if (status == '1') {
      return MyColor.greenSuccessColor;
    } else {
      return status == "0" ? MyColor.pendingColor : MyColor.colorRed;
    }
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  bool validatePinCode() {
    if (pinController.text.length != 4) {
      MyUtils.vibrate();
      CustomSnackBar.error(errorList: [MyStrings.pinLengthErrorMessage]);
      return false;
    }
    if (pinController.text.isEmpty) {
      MyUtils.vibrate();
      CustomSnackBar.error(errorList: [MyStrings.pinErrorMessage]);
      return false;
    }

    return true;
  }
}
