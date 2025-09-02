import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/text/bottom_sheet_header_text.dart';

class RechargeHistoryCardBottomSheet extends StatelessWidget {
  final int index;

  const RechargeHistoryCardBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeContrller>(builder: (controller) {
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
                body: controller.rechargetHistoryList[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.status.tr,
                textColor: (controller.rechargetHistoryList[index].status == '1')
                    ? MyColor.greenSuccessColor
                    : (controller.rechargetHistoryList[index].status == '2')
                        ? MyColor.redCancelTextColor
                        : MyColor.pendingColor,
                body: (controller.rechargetHistoryList[index].status == '1')
                    ? MyStrings.approved.tr
                    : (controller.rechargetHistoryList[index].status == '2')
                        ? MyStrings.rejected.tr
                        : MyStrings.pending.tr,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.amount.tr,
                body: "${controller.currency}${Converter.formatNumber(controller.rechargetHistoryList[index].transaction?.beforeCharge ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.charge.tr,
                body: "${controller.currency}${Converter.formatNumber(controller.rechargetHistoryList[index].transaction?.charge ?? "")}",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.finalAmount.tr,
                body: "${controller.currency}${Converter.formatNumber(controller.rechargetHistoryList[index].transaction?.amount ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.remainingBalance.tr,
                body: "${controller.currency}${Converter.formatNumber(controller.rechargetHistoryList[index].transaction?.postBalance ?? "")}",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(header: MyStrings.mobileNumber.tr, body: "${(controller.rechargetHistoryList[index].mobile ?? "")} "),
              CardColumn(
                header: MyStrings.mobileOperator.tr,
                body: "${(controller.rechargetHistoryList[index].mobileOperator?.name ?? "")} ",
                alignmentEnd: true,
              ),
            ],
          ),
          controller.rechargetHistoryList[index].adminFeedback == "null" ? const SizedBox.shrink() : const SizedBox(height: Dimensions.space15),
          controller.rechargetHistoryList[index].adminFeedback == "null"
              ? const SizedBox.shrink()
              : CardColumn(
                  header: MyStrings.rejectReason.tr,
                  body: "${(controller.rechargetHistoryList[index].adminFeedback ?? "")} ",
                  bodyMaxLine: 80,
                ),
        ],
      );
    });
  }
}
