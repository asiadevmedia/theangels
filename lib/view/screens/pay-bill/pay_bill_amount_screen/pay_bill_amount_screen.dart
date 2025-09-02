import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/balance_box_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/screens/pay-bill/widget/paybill_icon_widget.dart';

class PaybillAmountScreen extends StatefulWidget {
  const PaybillAmountScreen({super.key});

  @override
  State<PaybillAmountScreen> createState() => _PaybillAmountScreenState();
}

class _PaybillAmountScreenState extends State<PaybillAmountScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaybillRepo(apiClient: Get.find()));
    final controller = Get.put(PaybillController(paybillRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.amountController.clear();
      if (controller.selectedUtils == null) {
        Get.back();
      }
    });
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
                        const SizedBox(
                          width: Dimensions.space10,
                        ),
                        Text(
                          controller.selectedUtils?.name.toString().tr ?? "",
                          style: title.copyWith(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space25,
                ),
                BalanceBoxCard(
                  focusNode: controller.amountFocusNode,
                  textEditingController: controller.amountController,
                  onpress: () {
                    double currntBalance = NumberFormat.decimalPattern().parse(controller.currentBalance).toDouble();

                    if (controller.amountController.text.trim().isNotEmpty) {
                      if (controller.amountController.text.trim().isNotEmpty) {
                        if (MyUtils().balanceValidation(currentBalance: currntBalance, amount: double.tryParse(controller.amountController.text) ?? 0)) {
                          Get.toNamed(RouteHelper.paybillPinScreen);
                        }
                      } else {
                        CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                      }
                    } else {
                      CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                    }
                  },
                ),
                const SizedBox(
                  height: Dimensions.space16,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
