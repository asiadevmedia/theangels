import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';
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
    return GetBuilder<HomeController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetBar(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomSheetHeaderText(text: MyStrings.details),
              BottomSheetCloseButton(),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.transactionId.tr,
                body: controller.latestTransactions[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.date.tr,
                body: DateConverter.convertIsoToString(controller.latestTransactions[index].createdAt ?? ""),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                alignmentEnd: false,
                header: MyStrings.amount.tr,
                body: "${controller.defaultCurrencySymbol}${Converter.formatNumber(controller.latestTransactions[index].beforeCharge ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.charge.tr,
                body: "${controller.defaultCurrencySymbol}${Converter.formatNumber(controller.latestTransactions[index].charge ?? "")} ",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                alignmentEnd: false,
                header: MyStrings.finalAmount.tr,
                body: "${controller.defaultCurrencySymbol}${Converter.formatNumber(controller.latestTransactions[index].amount ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.remainingBalance.tr,
                body: "${controller.defaultCurrencySymbol}${Converter.formatNumber(controller.latestTransactions[index].postBalance ?? "")} ",
              ),
            ],
          ),
          // const SizedBox(height: Dimensions.space15),
          // controller.latestTransactions[index].details == '' || controller.latestTransactions[index].details!.isEmpty ? const SizedBox.shrink() : Text(controller.latestTransactions[index].details ?? '')
        ],
      ),
    );
  }
}
