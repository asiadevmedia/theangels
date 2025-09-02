import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/cash_out/cash_out_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/repo/cashout/cashout_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/balance_box_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class CashOutAmountScreen extends StatefulWidget {
  const CashOutAmountScreen({super.key});

  @override
  State<CashOutAmountScreen> createState() => _CashOutAmountScreenState();
}

class _CashOutAmountScreenState extends State<CashOutAmountScreen> {
  @override
  void initState() {
    String? username = Get.arguments != null ? Get.arguments[0] : null;
    String? mobile = Get.arguments != null ? Get.arguments[1] : null;
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CashoutRepo(apiClient: Get.find()));
    final controller = Get.put(CashOutController(cashoutRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.amountController.clear();

      // when user come from direct home page though qr code than argument will be not null, then we have to load cash-out data and select contact here
      if (username != null && mobile != null) {
        controller.loadCashOutData();
        controller.selectContact(UserContactModel(name: username, number: mobile));
        controller.quickAmountList = controller.cashoutRepo.apiClient.getQuickAmountList();
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
      appBar: CustomAppBar(title: MyStrings.cashOut, isTitleCenter: true, elevation: 0.3),
      body: GetBuilder<CashOutController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TitleCard(
                        title: MyStrings.agentNumber.tr,
                        onlyBottom: true,
                        widget: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: UserCard(
                            title: controller.selectedContact?.name ?? '',
                            subtitle: controller.selectedContact?.number ?? "",
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
                              Get.toNamed(RouteHelper.cashOutPinScreen);
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
