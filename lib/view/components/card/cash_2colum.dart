import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';

class CashDetailsColumn extends StatelessWidget {

  final String total, newBalance;
  final String? firstTitle, secondTitle;
  final String? charge;
  final TextStyle? totalStyle;
  final TextStyle? newBalanceStyle;
  final double? space;
  final bool needBorder;
  final bool hideCharge ;
  final int chargeMaxLine ;
  const CashDetailsColumn({
    super.key,
    this.needBorder = true,
    required this.total,
    required this.newBalance,
    this.firstTitle,
    this.secondTitle,
    this.totalStyle,
    this.newBalanceStyle,
    this.space = 5,
    this.charge = '',
    this.chargeMaxLine = 2,
    this.hideCharge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: needBorder ? const EdgeInsets.all(Dimensions.space20) : EdgeInsets.zero,
      decoration: needBorder ?
      BoxDecoration(
          color: MyColor.colorWhite,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: MyColor.borderColor,
            width: 0.6,
          ),
        )
      : const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CardColumn(
              header: firstTitle?.tr ?? MyStrings.total.tr,
              body: total,
              bodyTextStyle: totalStyle ??
                boldDefault.copyWith(
                  fontSize: Dimensions.fontMediumLarge - 1,
                ),
              subBody: hideCharge ? '' : '$charge',
              space: space,
              bodyMaxLine: chargeMaxLine,
            ),
          ),
          Container(
            height: Dimensions.space50,
            width: 1,
            color: MyColor.borderColor,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: CardColumn(
                header: secondTitle?.tr ?? MyStrings.newBalance.tr,
                body: newBalance,
                bodyTextStyle: newBalanceStyle ?? boldMediumLarge,
                space: space,
                alignmentEnd: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
