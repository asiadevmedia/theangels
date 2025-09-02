import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/make_payment/make_payment_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/repo/money_discharge/make_payment/make_payment_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/balance_box_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class MakePaymentAmountScreen extends StatefulWidget {
  const MakePaymentAmountScreen({super.key});

  @override
  State<MakePaymentAmountScreen> createState() => _MakePaymentAmountScreenState();
}

class _MakePaymentAmountScreenState extends State<MakePaymentAmountScreen> {
  @override
  void initState() {
    String? username = Get.arguments != null ? Get.arguments[0] : null;
    String? mobile = Get.arguments != null ? Get.arguments[1] : null;

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MakePaymentRepo(apiClient: Get.find()));
    final controller = Get.put(MakePaymentController(makePaymentRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (username != null && mobile != null) {
        controller.makePaymentData();

        controller.selectContact(UserContactModel(name: username, number: mobile), fromQr: true);
        controller.quickAmountList = controller.makePaymentRepo.apiClient.getQuickAmountList();
        controller.update();
      } else {
        if (controller.selectedContact == null && controller.numberController.text.isEmpty) {
          Get.back();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: MyStrings.makePayment.tr,
        isTitleCenter: true,
        elevation: 0.3,
      ),
      body: GetBuilder<MakePaymentController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleCard(
                  title: MyStrings.merchant.tr,
                  onlyBottom: true,
                  widget: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: UserCard(
                        title: controller.selectedContact?.name ?? controller.numberController.text,
                        subtitle: controller.selectedContact?.number.toString() ?? "",
                      )),
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
                      if (controller.amountController.text.trim().isNotEmpty) {
                        if (MyUtils().balanceValidation(currentBalance: currntBalance, amount: double.tryParse(controller.amountController.text) ?? 0)) {
                          Get.toNamed(RouteHelper.makePaymentPinScreen);
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
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.quickAmountList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          controller.amountController.text = controller.quickAmountList[index];
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
                              controller.quickAmountList[index],
                              style: regularDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
