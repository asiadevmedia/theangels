import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/sf_utils.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/model/authorization/authorization_response_model.dart';
import 'package:viserpay/data/model/bank-transfer/add_bank_response_model.dart';
import 'package:viserpay/data/model/bank-transfer/bank_tansfer_success_model.dart';
import 'package:viserpay/data/model/bank-transfer/bank_transfer_history_model.dart';
import 'package:viserpay/data/model/bank-transfer/bank_transfer_response_modal.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/bank_tansfer/bank_transfer_repo.dart';
import 'package:viserpay/view/components/file_download_dialog/download_dialogue.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class BankTransferController extends GetxController {
  BankTransferRepo bankTransferRepo;
  BankTransferController({required this.bankTransferRepo});

  bool isLoading = true;

  TextEditingController searchController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController cardController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();
  FocusNode bankNameFocusNode = FocusNode();
  FocusNode accountNumberFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();
  FocusNode cardFocusNode = FocusNode();

  List<String> quickAmountList = [];
  String filePath = "";
  void initialValue() async {
    currentPage = 0;
    curSymbol = bankTransferRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    currency = bankTransferRepo.apiClient.getCurrencyOrUsername(isSymbol: false);
    quickAmountList = bankTransferRepo.apiClient.getQuickAmountList();
    filePath = "";
    amountController.text = '';
    amountController.clear();

    bankNameController.text = '';
    bankNameController.clear();

    isLoading = true;
    update();

    await loadBankData();

    isLoading = false;
    update();
  }

  bool isSearching = false;
  void filterData(String query) {
    isSearching = true;
    update();

    if (query.isEmpty) {
      filteredBankList = allBankList;
    } else {
      filteredBankList = allBankList.where((element) => element.name.toString().toLowerCase().contains(query.toLowerCase())).toList();
      update();
    }

    isSearching = false;
    update();
  }

  Bank? selectedBank;
  List<GlobalFormModle> formList = [];

  void selectBank(Bank bank) {
    selectedBank = bank;
    formList.clear();

    formList = MyUtils.dynamicFormSelectValueFormatter(bank.form?.formData?.list?.toList() ?? []);

    update();
    Get.toNamed(RouteHelper.addNewBankScreen);
  }

  int selectedMethod = 1; // note: 0 for bank and 1 for card
  void changeSelectedMethod() {
    selectedMethod = 0;
    update();
  }

  double mainAmount = 0;
  String charge = "";
  String payableText = '';
  String curSymbol = '';
  String currency = '';

  String currentBalance = "0";

  void changeInfoWidget() {
    mainAmount = double.tryParse(amountController.text) ?? 0.0;

    // double rate = double.tryParse(sen?.currency?.rate ?? "0") ?? 0;
    double percent = double.tryParse(bankTransferCharge?.percentCharge ?? "0") ?? 0;
    double percentCharge = (mainAmount * percent) / 100;
    double fixedCharge = double.tryParse(bankTransferCharge?.fixedCharge ?? "0") ?? 0;
    double tempTotalCharge = percentCharge + fixedCharge;

    charge = Converter.formatNumber('$tempTotalCharge', precision: 2);
    double payable = tempTotalCharge + mainAmount;
    payableText = Converter.formatNumber(payable.toString(), precision: 2);
    update();
  }

  List<Bank> allBankList = [];
  List<Bank> filteredBankList = [];

  List<MyAddedBankModel> mySavedBankList = [];

  MyAddedBankModel? selectedMyBank;

  void selectMyBank(MyAddedBankModel myBank) {
    selectedMyBank = myBank;
    Get.toNamed(RouteHelper.bankTransferAmountScreen);
    update();
  }

  BankTransferCharge? bankTransferCharge;

  List<String> otpTypeList = [];
  String selectedOtpType = "null";

  void selectOtpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  Future<void> loadBankData() async {
    isLoading = true;
    submitLoading = false;
    update();

    ResponseModel responseModel = await bankTransferRepo.getBankTransferData();
    if (responseModel.statusCode == 200) {
      BankTransferResponseModal modal = BankTransferResponseModal.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        final data = modal.data;
        if (data != null) {
          currentBalance = data.currentBalance ?? '0';
          bankTransferCharge = data.bankTransferCharge;

          otpTypeList.clear();
          otpTypeList.addAll(data.otpType?.toList() ?? []);

          allBankList.clear();
          filteredBankList.clear();

          allBankList.addAll(data.banks?.toList() ?? []);
          filteredBankList.addAll(allBankList);

          mySavedBankList.clear();
          mySavedBankList.addAll(data.myAddedBanks?.toList() ?? []);
          update();
        }
      } else {
        CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
    return;
  }

  String selectOne = MyStrings.selectOne;

  bool submitLoading = false;
  void addNewBank() async {
    List<String> list = hasError();
    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }
    submitLoading = true;
    update();
    AddBankResponseModel model = await bankTransferRepo.addNewBank(
      bankId: selectedBank?.id.toString() ?? '',
      name: accountNameController.text,
      accountNumber: accountNumberController.text,
      list: formList,
    );
    if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      await loadBankData();
      Get.back();
      CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.newBankSuccessMessage]);
    } else {
      CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.requestFail]);
    }

    submitLoading = false;
    update();
  }

  Future<void> transferAmount() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await bankTransferRepo.transferAmount(
      bankId: selectedMyBank?.id.toString() ?? '-1',
      amount: amountController.text,
      otpType: selectedOtpType,
      pin: pinController.text,
    );

    BankTransferSuccessModel model = BankTransferSuccessModel.fromJson(jsonDecode(responseModel.responseJson));
    if (model.status == "success") {
      Get.back();

      if (model.data != null) {
        if (model.data?.actionID == "null") {
          Get.toNamed(RouteHelper.bankTransferSucessScreen, arguments: [responseModel]);
          CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.bankTransferSuccessMessage]);
        } else {
          Get.toNamed(
            RouteHelper.otpScreen,
            arguments: [
              model.data?.actionID,
              RouteHelper.bankTransferSucessScreen,
              pinController.text.toString(),
              selectedOtpType,
            ],
          );
        }
      } else {
        Get.back();
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      Get.back();
      CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
    }
  }

  int deletingBankIndex = -1;
  Future<void> removeAddedBank(int myBankListIndex, {required String userBankID}) async {
    Get.back();

    deletingBankIndex = myBankListIndex;
    update();

    ResponseModel responseModel = await bankTransferRepo.removeUserAddedBank(bankId: userBankID);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.status == "success") {
        mySavedBankList.removeAt(myBankListIndex);
        CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.requestSuccess]);
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    deletingBankIndex = -1;
    update();
  }

  /*bool validatePinCode() {
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
  }*/

  List<BankHistory> bankHistory = [];
  String? nextPageUrl;
  int currentPage = 0;

  bool bankHistoryLoading = true;
  Future<void> getBankHistory() async {
    bankHistoryLoading = true;
    currentPage = currentPage + 1;
    if (currentPage == 1) {
      bankHistory.clear();
    }
    update();

    ResponseModel responseModel = await bankTransferRepo.getBankTransferHistroy(currentPage.toString());
    if (responseModel.statusCode == 200) {
      BankTransferHistoryResponseModel modal = BankTransferHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (modal.status == "success") {
        final data = modal.data;
        filePath = data?.filePath ?? '';
        if (data != null) {
          List<BankHistory> tempList = data.history?.data?.toList() ?? [];

          if (tempList.isNotEmpty) {
            bankHistory.addAll(tempList);
            nextPageUrl = data.history?.nextPageUrl;
            update();
          }
        }
      } else {
        CustomSnackBar.error(errorList: modal.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    bankHistoryLoading = false;
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

  List<String> hasError() {
    List<String> errorList = [];
    errorList.clear();
    if (selectedBank?.form?.formData?.list?.isNotEmpty ?? false) {
      for (var element in formList) {
        if (element.isRequired?.toLowerCase() == 'required') {
          if (element.type == 'checkbox') {
            if (element.cbSelected == null) {
              errorList.add('${element.name} ${MyStrings.isRequired}');
            }
          } else if (element.type == 'file') {
            if (element.imageFile == null) {
              errorList.add('${element.name} ${MyStrings.isRequired}');
            }
          } else {
            if (element.selectedValue == '' || element.selectedValue == selectOne) {
              errorList.add('${element.name} ${MyStrings.isRequired}');
            }
          }
        }
      }
    }

    return errorList;
  }

  void changeSelectedValue(value, int index) {
    formList[index].selectedValue = value;
    update();
  }

  void changeSelectedRadioBtnValue(int listIndex, int selectedIndex) {
    formList[listIndex].selectedValue = formList[listIndex].options?[selectedIndex];
    update();
  }

  void changeSelectedCheckBoxValue(int listIndex, String value) {
    List<String> list = value.split('_');
    int index = int.parse(list[0]);
    bool status = list[1] == 'true' ? true : false;

    List<String>? selectedValue = formList[listIndex].cbSelected;

    if (selectedValue != null) {
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    } else {
      selectedValue = [];
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    }
  }

  void downloadAttachment(String url, BuildContext context) {
    // String mainUrl = '${UrlContainer.baseUrl}assets/images/setup_utility/$url';
    if (url.isNotEmpty && url != 'null') {
      showDialog(
        context: context,
        builder: (context) => DownloadingDialog(
          isPdf: false,
          url: url,
          fileName: '',
          isImage: true,
        ),
      );
      update();
    }
  }

  void pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx']);

    if (result == null) return;

    formList[index].imageFile = File(result.files.single.path!);
    String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
    return;
  }

  void clearAllList() {
    clearValueFromSF(SharedPreferenceHelper.bankTransferRecentKey);
  }
}
