import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/cash_out/cash_out_controller.dart';
import 'package:viserpay/data/repo/cashout/cashout_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/card/account_details_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';

class CashOutPinScreen extends StatefulWidget {
  const CashOutPinScreen({super.key});

  @override
  State<CashOutPinScreen> createState() => _CashOutPinScreenState();
}

class _CashOutPinScreenState extends State<CashOutPinScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CashoutRepo(apiClient: Get.find()));
    final controller = Get.put(CashOutController(cashoutRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.pinController.clear();
      controller.changeInfoWidget();
    });
  }

  @override
  void dispose() {
    super.dispose();
    MyUtils.allScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.cashOut,
        isTitleCenter: true,
      ),
      body: GetBuilder<CashOutController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleCard(
                  title: MyStrings.agentNumber,
                  onlyBottom: true,
                  widget: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: UserCard(
                      title: controller.selectedContact?.name ?? controller.numberController.text,
                      subtitle: controller.selectedContact?.number.toString() ?? "",
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space16,
                ),
                AccountDetailsCard(
                  amount: controller.curSymbol + controller.mainAmount.toString(),
                  charge: controller.curSymbol + controller.charge,
                  total: controller.curSymbol + controller.payableText.toString(),
                ),
                const SizedBox(
                  height: Dimensions.space20,
                ),
                controller.otpTypeList.isNotEmpty ? Text(MyStrings.selectOptType.tr, style: mediumDefault.copyWith()) : const SizedBox.shrink(),
                controller.otpTypeList.isNotEmpty
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            controller.otpTypeList.length,
                            (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: controller.selectedOtpType == controller.otpTypeList[index] ? true : false,
                                      onChanged: (p) {
                                        controller.selectotpType(controller.otpTypeList[index]);
                                      },
                                      shape: const CircleBorder(),
                                      activeColor: MyColor.primaryDark,
                                    ),
                                    Text(
                                      controller.otpTypeList[index].toUpperCase(),
                                      style: semiBoldDefault.copyWith(
                                        color: controller.selectedOtpType.toLowerCase() == controller.otpTypeList[index].toLowerCase() ? MyColor.colorBlack : MyColor.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                CustomPinField(
                  onChanged: (p) {
                    MyUtils.vibrate();
                  },
                  controller: controller.pinController,
                  focusNode: controller.pinFocusNode,
                  needOutlineBorder: true,
                  labelText: "",
                  hintText: MyStrings.enterYourPIN,
                  isShowSuffixIcon: true,
                  textInputType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  prefixicon: const SizedBox(
                    width: 22,
                    height: 22,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.lock,
                        color: MyColor.primaryColor,
                      ),
                    ),
                  ),
                  suffixWidget: GestureDetector(
                    onTap: () {
                      submitDialog(controller);
                    },
                    child: const SizedBox(
                      width: 22,
                      height: 22,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_right_alt_sharp,
                          color: MyColor.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  onSubmit: () {
                    submitDialog(controller);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void submitDialog(CashOutController controller) {
    String newBalance = Converter.minus(controller.currentBalance, controller.payableText);

    if (controller.otpTypeList.isNotEmpty && controller.selectedOtpType == 'null') {
      CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp]);
      return;
    }

    if (!MyUtils().validatePinCode(controller.pinController.text)) {
      return;
    }

    AppDialog().confirmDialog(
      context,
      title: MyStrings.cashOut.tr,
      userDetails: UserCard(
        title: controller.selectedContact?.name ?? controller.numberController.text,
        subtitle: controller.selectedContact?.number.toString() ?? "",
      ),
      cashDetails: CashDetailsColumn(
        total: controller.curSymbol + controller.payableText,
        newBalance: controller.curSymbol + newBalance,
        charge: MyUtils.getChargeText("${controller.curSymbol}${controller.charge}"),
      ),
      onfinish: () {},
      onwaiting: () {
        controller.submitCashOutData();
      },
    );
  }
}
