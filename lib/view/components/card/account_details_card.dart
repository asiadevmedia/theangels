// ignore_for_file: must_be_immutable

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';

class AccountDetailsCard extends StatelessWidget {
  String amount, charge, total;
  AccountDetailsCard({super.key, required this.amount, required this.charge, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.space20),
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: MyColor.borderColor,
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: CardColumn(
              header: MyStrings.amount.tr,
              body: amount,
              space: 5,
              // headerTextDecoration: regularDefault.copyWith(color: MyColor.colorGrey, fontSize: Dimensions.fontDefault-1),
              bodyTextStyle: boldMediumLarge.copyWith(fontSize: 16),
            ),
          ),
          Container(
            height: Dimensions.space50,
            width: 1,
            color: MyColor.borderColor,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Expanded(
            flex: 4,
            child: CardColumn(
              header: MyStrings.charge.tr,
              body: charge,
              space: 5,
              bodyTextStyle: boldMediumLarge.copyWith(fontSize: 16),
            ),
          ),
          Container(
            height: Dimensions.space50,
            width: 1,
            color: MyColor.borderColor,
            margin: const EdgeInsets.symmetric(horizontal: 5),
          ),
          Expanded(
            flex: 4,
            child: CardColumn(
              header: MyStrings.total.tr,
              body: total,
              space: 5,
              alignmentEnd: true,
              bodyTextStyle: boldMediumLarge.copyWith(
                fontSize: Dimensions.fontMediumLarge - 1.5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
