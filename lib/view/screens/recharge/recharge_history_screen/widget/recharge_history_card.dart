// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/model/recharge/recharge_data_response_modal.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/image/rechange_image_widget.dart';

class RechargeHistoryCard extends StatelessWidget {
  final int index;
  final VoidCallback press;
  LatestMobileRecharge transaction;
  String currencySym;
  RechargeHistoryCard({
    super.key,
    required this.index,
    required this.press,
    required this.transaction,
    required this.currencySym,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeContrller>(builder: (controller) {
      return GestureDetector(
        onTap: press,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space10),
          decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 60,
                      alignment: Alignment.center,
                      child: RechargeImageWidget(
                        imageUrl: transaction.mobileOperator?.getImage.toString() ?? '',
                        // radius: 50,
                        height: 40,
                        width: 50,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: Dimensions.space10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${transaction.mobileOperator?.name}".replaceAll("_", " ").toTitleCase().tr,
                            style: regularDefault.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: Dimensions.space5),
                          SizedBox(
                            width: 150,
                            child: Text(
                              transaction.trx.toString(),
                              style: regularSmall.copyWith(color: MyColor.getTextColor().withOpacity(0.5)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: CardColumn(
                  header: "$currencySym${Converter.formatNumber(transaction.amount.toString())}",
                  body: DateConverter.convertIsoToString(transaction.createdAt ?? ""),
                  alignmentEnd: true,
                  headerTextStyle: boldDefault.copyWith(
                    color: (controller.rechargetHistoryList[index].status == '1')
                        ? MyColor.greenSuccessColor
                        : (controller.rechargetHistoryList[index].status == '2')
                            ? MyColor.redCancelTextColor
                            : MyColor.pendingColor,
                    fontSize: Dimensions.fontMediumLarge - 1,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyTextStyle: lightMediumLarge.copyWith(color: MyColor.getGreyText(), fontSize: Dimensions.fontDefault - 1),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
