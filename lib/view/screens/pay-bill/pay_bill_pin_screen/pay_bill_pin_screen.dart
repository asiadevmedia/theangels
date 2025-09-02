import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/card/account_details_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/screens/pay-bill/widget/paybill_icon_widget.dart';

class PayBillPinScreen extends StatefulWidget {
  const PayBillPinScreen({super.key});

  @override
  State<PayBillPinScreen> createState() => _PayBillPinScreenState();
}

class _PayBillPinScreenState extends State<PayBillPinScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaybillRepo(apiClient: Get.find()));
    final controller = Get.put(PaybillController(paybillRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.pinController.clear();
      controller.pinController.text = "";
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
      backgroundColor: MyColor.appBarColor,
      appBar: CustomAppBar(
        title: MyStrings.paybill,
        isTitleCenter: true,
        elevation: 0.09,
      ),
      body: GetBuilder<PaybillController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Dimensions.space25,
                ),
                TitleCard(
                  title: MyStrings.to.tr,
                  onlyBottom: true,
                  widget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.space12, horizontal: Dimensions.space12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BillIcon(
                          imageUrl: controller.selectedUtils?.getImage ?? "",
                          color: MyColor.getSymbolColor(0),
                          radius: 8,
                        ),
                        const SizedBox(width: Dimensions.space10),
                        Text(
                          controller.selectedUtils?.name.toString() ?? "",
                          style: title.copyWith(fontSize: 16),
                        )
                      ],
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
                if (controller.otpTypeList.isNotEmpty) ...[Text(MyStrings.selectOptType.tr, style: mediumDefault.copyWith())],
                if (controller.otpTypeList.isNotEmpty) ...[
                  SingleChildScrollView(
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
                ],
                CustomPinField(
                  onChanged: (val) {},
                  controller: controller.pinController,
                  needOutlineBorder: true,
                  labelText: "",
                  hintText: MyStrings.enterYourPIN.tr,
                  isShowSuffixIcon: true,
                  textInputType: TextInputType.number,
                  inputAction: TextInputAction.send,
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

  void submitDialog(PaybillController controller) {
    String newBalance = Converter.minus(controller.currentBalance, controller.payableText);

    if (controller.otpTypeList.isNotEmpty && controller.selectedOtpType == 'null') {
      CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp.tr]);
      return;
    }

    if (!MyUtils().validatePinCode(controller.pinController.text)) {
      return;
    }

    AppDialog().confirmDialog(
      context,
      title: MyStrings.paybill.tr,
      userDetails: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space12, horizontal: Dimensions.space12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BillIcon(
              imageUrl: controller.selectedUtils?.getImage ?? "",
              color: MyColor.getSymbolColor(0),
              radius: 8,
            ),
            const SizedBox(width: Dimensions.space10),
            Text(
              controller.selectedUtils?.name.toString().tr ?? "",
              style: title.copyWith(fontSize: 16),
            )
          ],
        ),
      ),
      cashDetails: CashDetailsColumn(
        total: controller.curSymbol + controller.payableText,
        newBalance: controller.curSymbol + newBalance,
        charge: MyUtils.getChargeText("${controller.curSymbol}${controller.charge}"),
      ),
      onfinish: () {},
      onwaiting: () {
        controller.submitPayBill();
      },
    );
  }
}
