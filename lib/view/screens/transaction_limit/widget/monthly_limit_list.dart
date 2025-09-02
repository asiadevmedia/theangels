import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/transaction_limit/transaction_limit_controller.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';

class MonthlyLimitList extends StatelessWidget {
  const MonthlyLimitList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionLimitController>(builder: (controller) {
      return Column(
        children: List.generate(controller.transactionChargeList.length, (index) {
          double monthlyLimit = double.tryParse(controller.transactionChargeList[index].monthlyLimit ?? '0.0') ?? 0.0;
          double monthlyused = double.tryParse(controller.transactionChargeList[index].monthlyUsed ?? '0.0') ?? 0.0;
          double remaining = monthlyLimit == -1.0 ? 0.0 : monthlyLimit - monthlyused;

          return AnimatedContainer(
            duration: const Duration(microseconds: 300),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: Dimensions.space12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: MyUtils.getShadow2(blurRadius: 4),
              color: MyColor.getCardBgColor(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.transactionChargeList[index].slug?.replaceAll("_", " ").toTitleCase().tr ?? "",
                  style: heading.copyWith(
                    color: MyColor.primaryColor,
                    fontSize: Dimensions.fontMediumLarge - 1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CardColumn(
                        header: MyStrings.limit.tr,
                        body: monthlyLimit == -1.0
                            ? "∞"
                            : monthlyLimit == 0.0
                                ? "0.0"
                                : "${controller.currencySym}${Converter.formatNumber(
                                    controller.transactionChargeList[index].monthlyLimit ?? "0.00",
                                  )}",
                        space: 8,
                        bodyMaxLine: 4,
                        headerTextStyle: heading.copyWith(fontSize: Dimensions.fontDefault),
                        bodyTextStyle: regularDefault,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CardColumn(
                        alignmentEnd: true,
                        header: MyStrings.used.tr,
                        body: monthlyLimit == -1.0
                            ? "∞"
                            : monthlyLimit == 0.0
                                ? "0.0"
                                : "${controller.currencySym}${Converter.formatNumber(
                                    controller.transactionChargeList[index].monthlyUsed ?? "0.00",
                                  )}",
                        space: 8,
                        headerTextStyle: heading.copyWith(fontSize: Dimensions.fontDefault),
                        bodyTextStyle: regularDefault,
                        bodyMaxLine: 4,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CardColumn(
                        bodyMaxLine: 4,
                        alignmentEnd: true,
                        header: MyStrings.remaining.tr,
                        body: monthlyLimit == -1.0
                            ? "∞"
                            : monthlyLimit == 0.0
                                ? "0.0"
                                : "${controller.currencySym}${Converter.formatNumber(remaining.toString())}",
                        space: 8,
                        headerTextStyle: heading.copyWith(fontSize: Dimensions.fontDefault),
                        bodyTextStyle: regularDefault,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
