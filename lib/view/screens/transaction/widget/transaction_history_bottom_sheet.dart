
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/transaction/transaction_history_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/text/bottom_sheet_header_text.dart';

class TransactionHistoryBottomSheet extends StatelessWidget {
  final int index;
  const TransactionHistoryBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryController>(
      builder: (controller) => Column(
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
                body: controller.transactionList[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.date.tr,
                body: DateConverter.convertIsoToString(controller.transactionList[index].createdAt ?? ""),
              )
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(header: MyStrings.amount.tr, body: "${controller.currencySym}${Converter.formatNumber(controller.transactionList[index].beforeCharge ?? "")} "),
              CardColumn(
                header: MyStrings.charge.tr,
                body: "${controller.currencySym}${Converter.formatNumber(controller.transactionList[index].charge ?? "")}",
                alignmentEnd: true,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(header: MyStrings.finalAmount.tr, body: "${controller.currencySym}${Converter.formatNumber(controller.transactionList[index].amount ?? "")} "),
              CardColumn(
                header: MyStrings.remainingBalance.tr,
                body: "${controller.currencySym}${Converter.formatNumber(controller.transactionList[index].postBalance ?? "")}",
                alignmentEnd: true,
              ),
            ],
          ),
          // const SizedBox(height: Dimensions.space15),
          // controller.transactionList[index].remark!.contains("mobile")
          //     ? CardColumn(
          //         header: MyStrings.details.tr,
          //         body: controller.transactionList[index].mobileRecharge?.adminFeedback ?? "--",
          //         bodyMaxLine: 80,
          //       )
          //     : controller.transactionList[index].remark!.contains("bill")
          //         ? CardColumn(
          //             header: MyStrings.details.tr,
          //             body: controller.transactionList[index].utilitybill?.adminFeedback ?? "",
          //             bodyMaxLine: 80,
          //           )
          //         : controller.transactionList[index].remark!.contains("bank")
          //             ? CardColumn(
          //                 header: MyStrings.details.tr,
          //                 body: controller.transactionList[index].details ?? "",
          //                 bodyMaxLine: 80,
          //               )
          //             : CardColumn(
          //                 header: MyStrings.details.tr,
          //                 body: controller.transactionList[index].details ?? "",
          //                 bodyMaxLine: 80,
          //               ),
        ],
      ),
    );
  }
}
