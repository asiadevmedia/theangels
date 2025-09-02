import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/bank_transfer/bank_tranfer_controller.dart';
import 'package:viserpay/data/repo/bank_tansfer/bank_transfer_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/balance_box_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class BankTransferAmountScreen extends StatefulWidget {
  const BankTransferAmountScreen({super.key});

  @override
  State<BankTransferAmountScreen> createState() => _BankTransferAmountScreenState();
}

class _BankTransferAmountScreenState extends State<BankTransferAmountScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BankTransferRepo(apiClient: Get.find()));
    final controller = Get.put(BankTransferController(bankTransferRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.amountController.clear();
      controller.amountController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: MyStrings.bankTransfer,
        isTitleCenter: true,
        elevation: 0.3,
      ),
      body: GetBuilder<BankTransferController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleCard(
                  title: MyStrings.bankName,
                  onlyBottom: true,
                  widget: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: UserCard(
                      title: controller.selectedMyBank?.bank?.name.toString() ?? "",
                      subtitle: MyUtils().maskSensitiveInformation(controller.selectedMyBank?.accountNumber.toString() ?? ""),
                      isAsset: false,
                      imgWidget: MyImageWidget(
                        imageUrl: controller.selectedMyBank?.bank?.getImage.toString() ?? "",
                        height: 40,
                        width: 40,
                        boxFit: BoxFit.contain,
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
                      if (controller.amountController.text.trim().isNotEmpty) {
                        if (MyUtils().balanceValidation(currentBalance: currntBalance, amount: double.tryParse(controller.amountController.text) ?? 0)) {
                          Get.toNamed(RouteHelper.bankTransferPinScreen);
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
