// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/donation/donation_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/text/bottom_sheet_header_text.dart';

class DonationHistoryBottomSheet extends StatelessWidget {
  int index;
  DonationHistoryBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonationController>(builder: (controller) {
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
                body: controller.donationHistory[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.date.tr,
                body: "${DateConverter.isoStringToLocalDateTime(controller.donationHistory[index].createdAt ?? "")} ",
                bodyTextStyle: regularSmall.copyWith(),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.name.tr,
                body: "${(controller.donationHistory[index].donationFor?.name ?? "")} ",
              ),
              CardColumn(
                // alignmentEnd: true,
                header: MyStrings.amount.tr,
                body: "${controller.currency}${Converter.formatNumber(controller.donationHistory[index].amount ?? "")}",
              )
            ],
          ),
        ],
      );
    });
  }
}
