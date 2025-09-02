import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/cash_out/cash_out_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/text/bottom_sheet_header_text.dart';

class CashoutHistoryCardBottomSheet extends StatelessWidget {
  final int index;

  const CashoutHistoryCardBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashOutController>(builder: (controller) {
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
                body: controller.cashOutHistoryList[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.agentName.tr,
                body: controller.cashOutHistoryList[index].receiverAgent?.username ?? "",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.amount.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.cashOutHistoryList[index].beforeCharge ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.charge.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.cashOutHistoryList[index].charge ?? "")} ",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.finalAmount.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.cashOutHistoryList[index].amount ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.remainingBalance.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.cashOutHistoryList[index].postBalance ?? "")}",
              ),
            ],
          )
        ],
      );
    });
  }
}
