import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/make_payment/make_payment_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/text/bottom_sheet_header_text.dart';

class MakePaymentHistoryCardBottomSheet extends StatelessWidget {
  final int index;

  const MakePaymentHistoryCardBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MakePaymentController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [BottomSheetHeaderText(text: MyStrings.details.tr), const BottomSheetCloseButton()],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.transactionId.tr,
                body: controller.paymentHistoryList[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.merchantName.tr,
                body: controller.paymentHistoryList[index].receiverUser?.username ?? "",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.amount.tr,
                body: "${controller.currencySym}${Converter.formatNumber(controller.paymentHistoryList[index].beforeCharge ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.charge.tr,
                body: "${controller.currencySym}${Converter.formatNumber(controller.paymentHistoryList[index].charge ?? "")} ",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.finalAmount.tr,
                body: "${controller.currencySym}${Converter.formatNumber(controller.paymentHistoryList[index].amount ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.remainingBalance.tr,
                body: "${controller.currencySym}${Converter.formatNumber(controller.paymentHistoryList[index].postBalance ?? "")}",
              ),
            ],
          ),
        ],
      );
    });
  }
}
