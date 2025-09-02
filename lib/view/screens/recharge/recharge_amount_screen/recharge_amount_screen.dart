import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/repo/recharge/recharge_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/environment.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/balance_box_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/image/rechange_image_widget.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class RechargeAmountScreen extends StatefulWidget {
  const RechargeAmountScreen({super.key});

  @override
  State<RechargeAmountScreen> createState() => _RechargeAmountScreenState();
}

class _RechargeAmountScreenState extends State<RechargeAmountScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RechargeRepo(apiClient: Get.find()));
    final controller = Get.put(RechargeContrller(rechargeRepo: Get.find(), contactController: Get.find()));
    //
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.selectedMethod == -1) {
        Get.back();
      }
      if (controller.selectedMethod == 1) {
        controller.numberController.text = "";
      } else {
        controller.selectedContact = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: MyStrings.mobileRecharge.tr,
        isTitleCenter: true,
        elevation: 0.3,
      ),
      body: GetBuilder<RechargeContrller>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleCard(
                  title: MyStrings.for_.tr,
                  onlyBottom: true,
                  widget: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: UserCard(
                      title: controller.selectedContact?.name.toString() ?? controller.selectedContact?.number.toString() ?? "",
                      subtitle: controller.selectedContact?.number.toString() ?? "",
                      rightWidget: RechargeImageWidget(
                        imageUrl: controller.selectedoperator?.getImage.toString() ?? "",
                        boxFit: BoxFit.contain,
                        height: 45,
                        width: 50,
                        radius: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space16,
                ),
                BalanceBoxCard(
                  focusNode: controller.amountFocusNode,
                  textEditingController: controller.amountController,
                  onpress: () {
                    double currntBalance = NumberFormat.decimalPattern().parse(controller.currentBalance).toDouble();
                    if (controller.amountController.text.trim().isNotEmpty) {
                        if (MyUtils().balanceValidation(currentBalance: currntBalance, amount: double.tryParse(controller.amountController.text) ?? 0)) {
                          Get.toNamed(RouteHelper.rechargePinScreen);
                        }
                    } else {
                      CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                    }
                  },
                ),
                const SizedBox(
                  height: Dimensions.space16,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      Environment().mobileRechargeQuickAmount.length,
                      (index) => GestureDetector(
                        onTap: () {
                          controller.amountController.text = Environment().mobileRechargeQuickAmount[index];
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.space16),
                          margin: const EdgeInsets.all(Dimensions.space2),
                          width: 100,
                          decoration: BoxDecoration(
                            color: MyColor.colorWhite,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: MyColor.borderColor,
                              width: 0.7,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              Environment().mobileRechargeQuickAmount[index],
                              style: regularDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
