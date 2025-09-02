// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/send_money/sendmoney_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/repo/send_money/rend_money_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/balance_box_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class SendMoneyAmountScreen extends StatefulWidget {
  const SendMoneyAmountScreen({super.key});

  @override
  State<SendMoneyAmountScreen> createState() => _SendMoneyAmountScreenState();
}

class _SendMoneyAmountScreenState extends State<SendMoneyAmountScreen> {
  @override
  void initState() {
    String? username = Get.arguments != null ? Get.arguments[0] : null;
    String? mobile = Get.arguments != null ? Get.arguments[1] : null;

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SendMoneyRepo(apiClient: Get.find()));
    final controller = Get.put(SendMoneyContrller(
      sendMoneyRepo: Get.find(),
      contactController: Get.find(),
    ));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.amountController.clear();
      if (username != null && mobile != null) {
        controller.isLoading = true;
        controller.update();
        controller.initialValue();

        controller.selectContact(UserContactModel(name: username, number: mobile));
        controller.sendMoneyRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
        controller.quickAmountList = controller.sendMoneyRepo.apiClient.getQuickAmountList();

        controller.isLoading = false;
        controller.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: MyStrings.sendMoney,
        isTitleCenter: true,
        elevation: 0.1,
      ),
      body: GetBuilder<SendMoneyContrller>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                child: Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleCard(
                        title: "${MyStrings.to.tr} ",
                        onlyBottom: true,
                        widget: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: UserCard(
                            title: controller.selectedContact?.name ?? '',
                            subtitle: controller.selectedContact?.number ?? "",
                            imgWidget: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColor.primaryColor.withOpacity(0.2),
                              ),
                              child: const CustomSvgPicture(image: MyIcon.user),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.space16,
                      ),
                      BalanceBoxCard(
                        onpress: () {
                          double currntBalance = NumberFormat.decimalPattern().parse(controller.currentBalance).toDouble();

                          if (controller.amountController.text.trim().isNotEmpty) {
                            if (MyUtils().balanceValidation(currentBalance: currntBalance, amount: double.tryParse(controller.amountController.text) ?? 0)) {
                              Get.toNamed(RouteHelper.sendMoneyPinScreen);
                            }
                          } else {
                            CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                          }
                        },
                        textEditingController: controller.amountController,
                        focusNode: controller.amountFocusNode,
                      ),
                      const SizedBox(
                        height: Dimensions.space16,
                      ),
                      SingleChildScrollView(
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
