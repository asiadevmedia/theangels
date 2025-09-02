// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/url_container.dart';
import 'package:viserpay/data/model/authorization/authorization_response_model.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/paybill/paybill_history_model.dart';
import 'package:viserpay/data/model/paybill/paybill_response_model.dart';
import 'package:viserpay/data/model/paybill/paybill_success_model.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/view/components/file_download_dialog/download_dialogue.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:open_file/open_file.dart';

import '../../../core/utils/util.dart';
import 'package:http/http.dart' as http;

class PaybillController extends GetxController {
  PaybillRepo paybillRepo;
  PaybillController({required this.paybillRepo});

  // @override
  // void onReady() {
  //   _checkPermission();
  //   super.onReady();
  // }

  bool isLoading = true;

  TextEditingController organizationController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  FocusNode orgFocusNode = FocusNode();
  FocusNode cIdFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();

  String filePath = "";
  void initialValue() async {
    amountController.clear();
    amountController.text = "";
    currentBalance = paybillRepo.apiClient.getBalance();
    filePath = "";
    pinController.clear();
    pinController.text = "";
    attachMentfilePath = "";
    isLoading = true;
    nextPageUrl = null;
    currentPage = 0;
    billHistoryList.clear();
    update();
    await loadPayBillMethodAndBillingHistory();
    isLoading = false;
    update();
  }

  List<String> otpTypeList = [];
  String selectedOtpType = "null";

  void selectotpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  Utility? selectedUtils;
  void selectUtils(Utility utils) {
    selectedUtils = utils;
    formList.clear();
    var mainFormList = MyUtils.dynamicFormSelectValueFormatter(selectedUtils?.form?.formData?.list?.toList());
    formList.addAll(mainFormList);
    update();
    Get.toNamed(RouteHelper.paybillScreen);
  }

  String currentBalance = "0";
  double mainAmount = 0;
  String charge = "";
  String payableText = '';
  String curSymbol = '';

  void changeInfoWidget() {
    curSymbol = paybillRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    mainAmount = double.tryParse(amountController.text) ?? 0.0;

    double percent = double.tryParse(selectedUtils?.percentCharge ?? "0") ?? 0;
    double percentCharge = (mainAmount * percent) / 100;
    double fixedCharge = double.tryParse(selectedUtils?.fixedCharge ?? "0") ?? 0;
    double tempTotalCharge = percentCharge + fixedCharge;

    charge = Converter.formatNumber('$tempTotalCharge', precision: 2);
    double payable = tempTotalCharge + mainAmount;
    payableText = Converter.formatNumber(payable.toString(), precision: 2);

    update();
  }

  List<GlobalFormModle> formList = [];
  List<Utility> utility = [];
  List<PayBilHistroy> paybillHistory = [];
  List<PayBilHistroy> billHistoryList = [];

  Future<void> loadPayBillMethodAndBillingHistory() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await paybillRepo.getPaybillData();
    if (responseModel.statusCode == 200) {
      PaybillResponseModel model = PaybillResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        final data = model.data;
        if (data != null) {
          currentBalance = data.currentBalance ?? "0";

          utility.clear();
          utility.addAll(data.utility?.toList() ?? []);

          otpTypeList.clear();
          otpTypeList.addAll(data.otpType?.toList() ?? []);

          paybillHistory.clear();
          paybillHistory.addAll(data.latestPayBillHistory?.toList() ?? []);
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

  Future<void> submitPayBill() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await paybillRepo.submitBill(
      utilityID: selectedUtils?.id.toString() ?? "",
      amount: amountController.text,
      list: formList,
      otpType: selectedOtpType,
      pin: pinController.text,
    );

    if (responseModel.statusCode == 200) {
      PaybillSuccessResponseModel model = PaybillSuccessResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.status == MyStrings.success) {
        Get.back();

        if (model.data?.actionID == "null") {
          Get.toNamed(RouteHelper.paybillSuccessScreen, arguments: [responseModel]);
          CustomSnackBar.success(successList: [MyStrings.billCompletedSuccessFully]);
        } else {
          Get.toNamed(
            RouteHelper.otpScreen,
            arguments: [model.data?.actionID, RouteHelper.paybillSuccessScreen, pinController.text.toString(), selectedOtpType],
          );
        }
      } else {
        Get.back();
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      Get.back();
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
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

  int currentPage = 0;
  String? nextPageUrl;
  String attachMentfilePath = '';

  Future<void> loadBillingHistoryData() async {
    isLoading = true;

    curSymbol = paybillRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    currentPage = 0;
    downLoadId = "-1";

    currentPage = 1;
    billHistoryList.clear();
    update();

    ResponseModel responseModel = await paybillRepo.getPayBillHistory(currentPage.toString());
    if (responseModel.statusCode == 200) {
      PaybillHistoryResponseModel model = PaybillHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        filePath = model.data?.filePath.toString() ?? "null";
        nextPageUrl = model.data?.history?.nextPageUrl;
        List<PayBilHistroy> tempList = model.data?.history?.playbillhistory?.toList() ?? [];
        if (tempList.isNotEmpty) {
          billHistoryList.addAll(model.data?.history?.playbillhistory?.toList() ?? []);
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

  Future<void> loadBillHistoryPaginationData() async {
    currentPage = currentPage + 1;
    if (currentPage == 1) {
      billHistoryList.clear();
    }

    update();

    ResponseModel responseModel = await paybillRepo.getPayBillHistory(currentPage.toString());
    if (responseModel.statusCode == 200) {
      PaybillHistoryResponseModel model = PaybillHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == MyStrings.success) {
        filePath = model.data?.filePath.toString() ?? "null";
        nextPageUrl = model.data?.history?.nextPageUrl;
        List<PayBilHistroy> tempList = model.data?.history?.playbillhistory?.toList() ?? [];
        if (tempList.isNotEmpty) {
          billHistoryList.addAll(model.data?.history?.playbillhistory?.toList() ?? []);
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

  bool isDownloading = false;
  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
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

// kyc controller
  String selectOne = MyStrings.selectOne;
  List<String> hasError() {
    List<String> errorList = [];
    errorList.clear();
    if (formList.isNotEmpty) {
      for (var element in formList) {
        if (element.isRequired == 'required') {
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

    if (selectedValue != null && selectedValue.isNotEmpty) {
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

  void pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx']);

    if (result == null) return;

    formList[index].imageFile = File(result.files.single.path!);
    String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
    return;
  }

  TargetPlatform? platform;
  String _localPath = '';
  String downLoadId = "";

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      await Permission.storage.request();
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        await Permission.storage.request();
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return directory.path;
      } else {
        return (await getExternalStorageDirectory())?.path ?? "";
      }
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return null;
    }
  }

  void downloadAttachmentFile({required String id, required String name}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.paybillDownLoad}/$id";
    downLoadId = id;
    isDownloading = true;
    update();

    try {
      bool permission = await _checkPermission();
      if (permission) {
        await _prepareSaveDir();
        await downloadPDF(url, name);
      } else {
        downLoadId = "";
        update();
        CustomSnackBar.error(errorList: [MyStrings.downloadPermissionMsg]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [MyStrings.billDownloadingFailed]);
    }

    isDownloading = false;
    downLoadId = "";
    update();
  }

  Future<void> downloadPDF(String pdfUrl, String name) async {
    final headers = {
      'Authorization': "Bearer ${paybillRepo.apiClient.token}",
    };
    final response = await http.get(Uri.parse(pdfUrl), headers: headers);
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await saveAndOpenPDF(bytes, '$name.pdf');
    } else {
      try {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(response.body));
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      } catch (e) {
        // CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      }
    }
  }

  Future<void> saveAndOpenPDF(List<int> bytes, String fileName) async {
    final path = '$_localPath/$fileName';
    print("path $path");
    final file = File(path);
    await file.writeAsBytes(bytes);

    await openPDF(path);
  }

  Future<void> openPDF(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final result = await OpenFile.open(path);
      if (result.type == ResultType.done) {
      } else {
        CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
      }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
    }
  }
}
